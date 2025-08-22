package com.idvey.afya.security.service;

import com.idvey.afya.models.Medicine;
import com.idvey.afya.payload.request.CreateMedicineRequest;
import com.idvey.afya.payload.request.UpdateMedicineBarcodeRequest;
import com.idvey.afya.payload.response.MedicineResponse;
import com.idvey.afya.repository.MedicineRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineService {

	private final MedicineRepository medicineRepository;

	@Transactional
	public MedicineResponse createMedicine(CreateMedicineRequest request) {
		log.info("Creating medicine with name: {}", request.getMedicationName());

		if (medicineRepository.existsByMedicationName(request.getMedicationName())) {
			throw new IllegalStateException("Medicine with name '" + request.getMedicationName() + "' already exists");
		}

		if (request.getBarcode() != null && medicineRepository.existsByBarcode(request.getBarcode())) {
			throw new IllegalStateException("Medicine with barcode '" + request.getBarcode() + "' already exists");
		}

		Medicine medicine = Medicine.builder()
				.medicationName(request.getMedicationName())
				.dosage(request.getDosage())
				.form(request.getForm())
				.presentation(request.getPresentation())
				.dci(request.getDci())
				.therapeuticClass(request.getTherapeuticClass())
				.subClass(request.getSubClass())
				.laboratory(request.getLaboratory())
				.ammNumber(request.getAmmNumber())
				.ammDate(request.getAmmDate())
				.primaryPackaging(request.getPrimaryPackaging())
				.packagingSpecification(request.getPackagingSpecification())
				.scheduleCategory(request.getScheduleCategory())
				.shelfLife(request.getShelfLife())
				.indications(request.getIndications())
				.medicationType(request.getMedicationType())
				.veicClassification(request.getVeicClassification())
				.barcode(request.getBarcode())
				.build();

		Medicine saved = medicineRepository.save(medicine);
		log.info("Medicine created with ID: {}", saved.getId());

		return toResponse(saved);
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> getAllMedicines() {
		log.info("Fetching all medicines");
		return medicineRepository.findAll().stream().map(this::toResponse).toList();
	}

	@Transactional(readOnly = true)
	public MedicineResponse getMedicineById(UUID id) {
		log.info("Fetching medicine with ID: {}", id);
		Medicine medicine = medicineRepository.findById(id)
				.orElseThrow(() -> new NoSuchElementException("Medicine not found with ID: " + id));
		return toResponse(medicine);
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> searchMedicines(String searchTerm) {
		log.info("Searching medicines with term: {}", searchTerm);
		return medicineRepository.searchMedicines(searchTerm).stream().map(this::toResponse).toList();
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findByNameContaining(String name) {
		log.info("Finding medicines by name containing: {}", name);
		return medicineRepository.findByMedicationNameContainingIgnoreCase(name).stream().map(this::toResponse).toList();
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findByLaboratory(String laboratory) {
		log.info("Finding medicines by laboratory: {}", laboratory);
		return medicineRepository.findByLaboratoryContainingIgnoreCase(laboratory)
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findByForm(String form) {
		log.info("Finding medicines by form: {}", form);
		return medicineRepository.findByForm(form).stream().map(this::toResponse).toList();
	}

	@Transactional(readOnly = true)
	public MedicineResponse findByName(String name) {
		log.info("Finding medicine by exact name: {}", name);
		Medicine medicine = medicineRepository.findByMedicationName(name)
				.orElseThrow(() -> new NoSuchElementException("Medicine not found with name: " + name));
		return toResponse(medicine);
	}

	@Transactional(readOnly = true)
	public MedicineResponse findByBarcode(String barcode) {
		log.info("Finding medicine by barcode: {}", barcode);
		Medicine medicine = medicineRepository.findByBarcode(barcode)
				.orElseThrow(() -> new NoSuchElementException("Medicine not found with barcode: " + barcode));
		return toResponse(medicine);
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findByMedicationType(String medicationType) {
		log.info("Finding medicines by medication type: {}", medicationType);
		return medicineRepository.findByMedicationType(medicationType)
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findPrescriptionMedicines() {
		log.info("Finding prescription medicines");
		return medicineRepository.findPrescriptionMedicines()
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findOTCMedicines() {
		log.info("Finding OTC medicines");
		return medicineRepository.findOTCMedicines()
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findByTherapeuticClass(String therapeuticClass) {
		log.info("Finding medicines by therapeutic class: {}", therapeuticClass);
		return medicineRepository.findByTherapeuticClass(therapeuticClass)
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findByDci(String dci) {
		log.info("Finding medicines by DCI: {}", dci);
		return medicineRepository.findByDciContainingIgnoreCase(dci)
				.stream()
				.map(this::toResponse)
				.toList();
	}

	@Transactional
	public MedicineResponse updateMedicineBarcode(UUID medicineId, UpdateMedicineBarcodeRequest request) {
		log.info("Updating barcode for medicine: {} to: {}", medicineId, request.getBarcode());

		Medicine medicine = medicineRepository.findById(medicineId)
				.orElseThrow(() -> new NoSuchElementException("Medicine not found with ID: " + medicineId));

		// Check if the new barcode is already in use by another medicine
		if (medicineRepository.existsByBarcode(request.getBarcode())) {
			Medicine existingMedicine = medicineRepository.findByBarcode(request.getBarcode())
					.orElse(null);

			if (existingMedicine != null && !existingMedicine.getId().equals(medicineId)) {
				throw new IllegalStateException("Barcode '" + request.getBarcode() + "' is already in use by another medicine");
			}
		}

		medicine.setBarcode(request.getBarcode());
		Medicine updated = medicineRepository.save(medicine);

		log.info("Medicine barcode updated successfully for ID: {}", medicineId);
		return toResponse(updated);
	}

	@Transactional
	public MedicineResponse removeMedicineBarcode(UUID medicineId) {
		log.info("Removing barcode for medicine: {}", medicineId);

		Medicine medicine = medicineRepository.findById(medicineId)
				.orElseThrow(() -> new NoSuchElementException("Medicine not found with ID: " + medicineId));

		medicine.setBarcode(null);
		Medicine updated = medicineRepository.save(medicine);

		log.info("Medicine barcode removed successfully for ID: {}", medicineId);
		return toResponse(updated);
	}

	private MedicineResponse toResponse(Medicine medicine) {
		return new MedicineResponse(
				medicine.getId(),
				medicine.getMedicationName(),
				medicine.getDosage(),
				medicine.getForm(),
				medicine.getPresentation(),
				medicine.getDci(),
				medicine.getTherapeuticClass(),
				medicine.getSubClass(),
				medicine.getLaboratory(),
				medicine.getAmmNumber(),
				medicine.getAmmDate(),
				medicine.getPrimaryPackaging(),
				medicine.getPackagingSpecification(),
				medicine.getScheduleCategory(),
				medicine.getShelfLife(),
				medicine.getIndications(),
				medicine.getMedicationType(),
				medicine.getVeicClassification(),
				medicine.getBarcode(),
				medicine.isRequiresPrescription()
		);
	}

}