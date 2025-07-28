package com.idvey.afya.security.service;

import com.idvey.afya.models.Medicine;
import com.idvey.afya.models.MyMedicine;
import com.idvey.afya.models.PharmacyBox;
import com.idvey.afya.payload.request.CreateMyMedicineRequest;
import com.idvey.afya.payload.request.UpdateMyMedicineRequest;
import com.idvey.afya.payload.response.*;
import com.idvey.afya.repository.MedicineRepository;
import com.idvey.afya.repository.MyMedicineRepository;
import com.idvey.afya.repository.PharmacyBoxRepository;
import com.idvey.afya.repository.GroupMemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.AccessDeniedException;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class MyMedicineService {

	private final MyMedicineRepository myMedicineRepository;
	private final PharmacyBoxRepository pharmacyBoxRepository;
	private final MedicineRepository medicineRepository;
	private final GroupMemberRepository groupMemberRepository;
	private final PurchaseHistoryService purchaseHistoryService;

	@Transactional
	public MyMedicineResponse createMyMedicine(UUID userId, CreateMyMedicineRequest request)
			throws AccessDeniedException {
		log.info("Creating MyMedicine for pharmacy box: {} by user: {}", request.getPharmacyBoxId(), userId);

		PharmacyBox pharmacyBox = pharmacyBoxRepository.findById(request.getPharmacyBoxId())
				.orElseThrow(() -> new NoSuchElementException("Pharmacy box not found"));

		// 🔒 AUTHORIZATION CHECK
		validateUserAccessToPharmacyBox(userId, pharmacyBox);

		Medicine medicine = null;

		// If medicineId is provided, fetch from global database
		if (request.getMedicineId() != null) {
			medicine = medicineRepository.findById(request.getMedicineId())
					.orElseThrow(() -> new NoSuchElementException("Medicine not found"));

			// Check if this medicine already exists in pharmacy box (only for global medicines)
			if (myMedicineRepository.existsByPharmacyBox_IdAndMedicine_Id(
					request.getPharmacyBoxId(), request.getMedicineId())) {
				throw new IllegalStateException("This medicine already exists in the pharmacy box");
			}
		} else {
			// For custom medicines, check if a custom medicine with the same name exists
			if (myMedicineRepository.existsByPharmacyBox_IdAndNameAndMedicine_IsNull(
					request.getPharmacyBoxId(), request.getName())) {
				throw new IllegalStateException("A custom medicine with this name already exists in the pharmacy box");
			}
		}

		MyMedicine.MyMedicineBuilder builder = MyMedicine.builder()
				.name(request.getName())
				.form(request.getForm())
				.pharmacyBox(pharmacyBox)
				.medicine(medicine); // Can be null

		// If it's a custom medicine (medicineId is null), set custom fields
		if (medicine == null) {
			builder.customManufacturer(request.getManufacturer())
					.customDosageForm(request.getDosageForm())
					.customRequiresPrescription(request.isRequiresPrescription());
		}

		MyMedicine myMedicine = builder.build();
		MyMedicine saved = myMedicineRepository.save(myMedicine);

		log.info("MyMedicine created with ID: {} (custom: {}) by user: {}",
				saved.getId(), saved.isCustomMedicine(), userId);

		return toResponse(saved);
	}

	@Transactional(readOnly = true)
	public List<MyMedicineResponse> getMyMedicinesByPharmacyBox(UUID userId, UUID pharmacyBoxId)
			throws AccessDeniedException {
		log.info("Fetching medicines for pharmacy box: {} by user: {}", pharmacyBoxId, userId);

		PharmacyBox pharmacyBox = pharmacyBoxRepository.findById(pharmacyBoxId)
				.orElseThrow(() -> new NoSuchElementException("Pharmacy box not found"));

		validateUserAccessToPharmacyBox(userId, pharmacyBox);

		return myMedicineRepository.findByPharmacyBoxIdWithMedicine(pharmacyBoxId)
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional(readOnly = true)
	public List<MyMedicineResponse> getMyMedicinesByPharmacyBoxOrdered(UUID userId, UUID pharmacyBoxId)
			throws AccessDeniedException {
		log.info("Fetching medicines for pharmacy box ordered by creation date: {} by user: {}", pharmacyBoxId, userId);

		PharmacyBox pharmacyBox = pharmacyBoxRepository.findById(pharmacyBoxId)
				.orElseThrow(() -> new NoSuchElementException("Pharmacy box not found"));

		validateUserAccessToPharmacyBox(userId, pharmacyBox);

		return myMedicineRepository.findByPharmacyBoxIdOrderByCreatedAtDesc(pharmacyBoxId)
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional(readOnly = true)
	public List<MyMedicineResponse> searchMyMedicinesInPharmacyBox(UUID userId, UUID pharmacyBoxId, String name)
			throws AccessDeniedException {
		log.info("Searching medicines in pharmacy box {} with name: {} by user: {}", pharmacyBoxId, name, userId);

		PharmacyBox pharmacyBox = pharmacyBoxRepository.findById(pharmacyBoxId)
				.orElseThrow(() -> new NoSuchElementException("Pharmacy box not found"));

		validateUserAccessToPharmacyBox(userId, pharmacyBox);

		return myMedicineRepository.findByPharmacyBoxIdAndNameContaining(pharmacyBoxId, name)
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional(readOnly = true)
	public List<MyMedicineResponse> findByPharmacyBoxAndForm(UUID userId, UUID pharmacyBoxId, String form)
			throws AccessDeniedException {
		log.info("Finding medicines in pharmacy box {} with form: {} by user: {}", pharmacyBoxId, form, userId);

		PharmacyBox pharmacyBox = pharmacyBoxRepository.findById(pharmacyBoxId)
				.orElseThrow(() -> new NoSuchElementException("Pharmacy box not found"));

		validateUserAccessToPharmacyBox(userId, pharmacyBox);

		return myMedicineRepository.findByPharmacyBoxIdAndForm(pharmacyBoxId, form)
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional(readOnly = true)
	public List<MyMedicineResponse> findByMedicineId(UUID medicineId) {
		log.info("Finding all MyMedicines for medicine ID: {}", medicineId);
		return myMedicineRepository.findByMedicine_Id(medicineId).stream().map(this::toResponse).toList();
	}

	@Transactional(readOnly = true)
	public boolean existsInPharmacyBox(UUID userId, UUID pharmacyBoxId, UUID medicineId) throws AccessDeniedException {
		log.info("Checking if medicine {} exists in pharmacy box {} by user: {}", medicineId, pharmacyBoxId, userId);

		PharmacyBox pharmacyBox = pharmacyBoxRepository.findById(pharmacyBoxId)
				.orElseThrow(() -> new NoSuchElementException("Pharmacy box not found"));

		validateUserAccessToPharmacyBox(userId, pharmacyBox);

		return myMedicineRepository.existsByPharmacyBox_IdAndMedicine_Id(pharmacyBoxId, medicineId);
	}

	@Transactional(readOnly = true)
	public long countMedicinesInPharmacyBox(UUID userId, UUID pharmacyBoxId) throws AccessDeniedException {
		log.info("Counting medicines in pharmacy box: {} by user: {}", pharmacyBoxId, userId);

		PharmacyBox pharmacyBox = pharmacyBoxRepository.findById(pharmacyBoxId)
				.orElseThrow(() -> new NoSuchElementException("Pharmacy box not found"));

		validateUserAccessToPharmacyBox(userId, pharmacyBox);

		return myMedicineRepository.countByPharmacyBoxId(pharmacyBoxId);
	}

	@Transactional(readOnly = true)
	public MyMedicineDetailResponse getMyMedicineDetail(UUID userId, UUID id) throws AccessDeniedException {
		log.info("Fetching detailed MyMedicine: {} by user: {}", id, userId);

		MyMedicine myMedicine = myMedicineRepository.findByIdWithPurchaseHistory(id)
				.orElseThrow(() -> new NoSuchElementException("MyMedicine not found"));

		validateUserAccessToPharmacyBox(userId, myMedicine.getPharmacyBox());

		List<PurchaseHistoryResponse> purchaseHistory = purchaseHistoryService.getPurchaseHistoryByMyMedicine(id);
		int totalQuantity = purchaseHistory.stream().mapToInt(PurchaseHistoryResponse::getQuantityPurchased).sum();

		// Handle medicine response for both global and custom medicines
		MedicineResponse medicineResponse = null;
		if (myMedicine.getMedicine() != null) {
			medicineResponse = toMedicineResponse(myMedicine.getMedicine());
		}

		return new MyMedicineDetailResponse(
				myMedicine.getId(),
				myMedicine.getName(),
				myMedicine.getForm(),
				myMedicine.getPharmacyBox().getId(),
				myMedicine.getPharmacyBox().getGroup().getName(),
				medicineResponse, // Can be null for custom medicines
				totalQuantity,
				purchaseHistory,
				myMedicine.getCreatedAt(),
				myMedicine.getUpdatedAt()
		);
	}

	@Transactional
	public MyMedicineResponse updateMyMedicine(UUID userId, UUID id, UpdateMyMedicineRequest request)
			throws AccessDeniedException {
		log.info("Updating MyMedicine: {} by user: {}", id, userId);

		MyMedicine myMedicine = myMedicineRepository.findById(id)
				.orElseThrow(() -> new NoSuchElementException("MyMedicine not found"));

		validateUserAccessToPharmacyBox(userId, myMedicine.getPharmacyBox());

		myMedicine.setName(request.getName());
		myMedicine.setForm(request.getForm());

		MyMedicine updated = myMedicineRepository.save(myMedicine);
		log.info("MyMedicine updated: {} by user: {}", id, userId);

		return toResponse(updated);
	}

	@Transactional
	public void deleteMyMedicine(UUID userId, UUID id) throws AccessDeniedException {
		log.info("Deleting MyMedicine: {} by user: {}", id, userId);

		MyMedicine myMedicine = myMedicineRepository.findById(id)
				.orElseThrow(() -> new NoSuchElementException("MyMedicine not found"));

		validateUserAccessToPharmacyBox(userId, myMedicine.getPharmacyBox());

		myMedicineRepository.deleteById(id);
		log.info("MyMedicine deleted: {} by user: {}", id, userId);
	}
	@Transactional(readOnly = true)
	public MyMedicineResponse getMyMedicineByMedicineIdAndPharmacyBox(UUID userId, UUID pharmacyBoxId, UUID medicineId)
			throws AccessDeniedException {
		log.info("Fetching MyMedicine for medicine: {} in pharmacy box: {} by user: {}", medicineId, pharmacyBoxId, userId);

		PharmacyBox pharmacyBox = pharmacyBoxRepository.findById(pharmacyBoxId)
				.orElseThrow(() -> new NoSuchElementException("Pharmacy box not found"));

		// 🔒 AUTHORIZATION CHECK
		validateUserAccessToPharmacyBox(userId, pharmacyBox);

		MyMedicine myMedicine = myMedicineRepository.findByPharmacyBoxIdAndMedicineId(pharmacyBoxId, medicineId)
				.orElseThrow(() -> new NoSuchElementException("Medicine not found in this pharmacy box"));

		return toResponse(myMedicine);
	}

	@Transactional(readOnly = true)
	public PharmacyBoxMedicinesResponse getPharmacyBoxMedicines(UUID userId, UUID pharmacyBoxId)
			throws AccessDeniedException {
		log.info("Fetching pharmacy box medicines overview: {} by user: {}", pharmacyBoxId, userId);

		PharmacyBox pharmacyBox = pharmacyBoxRepository.findById(pharmacyBoxId)
				.orElseThrow(() -> new NoSuchElementException("Pharmacy box not found"));

		validateUserAccessToPharmacyBox(userId, pharmacyBox);

		List<MyMedicineResponse> medicines = getMyMedicinesByPharmacyBox(userId, pharmacyBoxId);

		return new PharmacyBoxMedicinesResponse(
				pharmacyBoxId,
				pharmacyBox.getGroup().getName(),
				medicines.size(),
				medicines
		);
	}

	// 🔒 AUTHORIZATION VALIDATION METHOD
	private void validateUserAccessToPharmacyBox(UUID userId, PharmacyBox pharmacyBox) throws AccessDeniedException {
		boolean hasAccess = groupMemberRepository.existsByUser_IdAndGroup_Id(userId, pharmacyBox.getGroup().getId());
		if (!hasAccess) {
			throw new AccessDeniedException("User does not have access to this pharmacy box");
		}
	}

	// UPDATED: Enhanced toResponse method
	private MyMedicineResponse toResponse(MyMedicine myMedicine) {
		// Use repository method to get total quantity
		Long totalQuantity = purchaseHistoryService.getTotalQuantityPurchased(myMedicine.getId());
		long purchaseCount = purchaseHistoryService.getPurchaseHistoryCount(myMedicine.getId());

		MedicineResponse medicineResponse = null;
		if (myMedicine.getMedicine() != null) {
			medicineResponse = toMedicineResponse(myMedicine.getMedicine());
		}

		return new MyMedicineResponse(
				myMedicine.getId(),                                // 1. id
				myMedicine.getName(),                              // 2. name
				myMedicine.getForm(),                              // 3. form
				myMedicine.getPharmacyBox().getId(),               // 4. pharmacyBoxId
				myMedicine.getPharmacyBox().getGroup().getName(),  // 5. pharmacyBoxName
				medicineResponse,                                  // 6. medicine (can be null for custom medicines)
				myMedicine.isCustomMedicine(),                     // 7. isCustomMedicine
				myMedicine.getCustomManufacturer(),                // 8. customManufacturer
				myMedicine.getCustomDosageForm(),                  // 9. customDosageForm
				myMedicine.getCustomRequiresPrescription(),        // 10. customRequiresPrescription
				totalQuantity != null ? totalQuantity.intValue() : 0, // 11. totalQuantityPurchased
				purchaseCount,                                     // 12. purchaseHistoryCount
				myMedicine.getCreatedAt(),                         // 13. createdAt
				myMedicine.getUpdatedAt()                          // 14. updatedAt
		);
	}

	private MedicineResponse toMedicineResponse(Medicine medicine) {
		return new MedicineResponse(
				medicine.getId(),
				medicine.getName(),
				medicine.getManufacturer(),
				medicine.getDosageForm(),
				medicine.isRequiresPrescription(),
				medicine.getBarcode()
		);
	}
}