package com.idvey.afya.security.service;

import com.idvey.afya.models.Medicine;
import com.idvey.afya.payload.request.CreateMedicineRequest;
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
		log.info("Creating medicine with name: {}", request.getName());

		if (medicineRepository.existsByName(request.getName())) {
			throw new IllegalStateException("Medicine with name '" + request.getName() + "' already exists");
		}

		if (request.getBarcode() != null && medicineRepository.existsByBarcode(request.getBarcode())) {
			throw new IllegalStateException("Medicine with barcode '" + request.getBarcode() + "' already exists");
		}

		Medicine medicine = Medicine.builder()
			.name(request.getName())
			.manufacturer(request.getManufacturer())
			.dosageForm(request.getDosageForm())
			.requiresPrescription(request.isRequiresPrescription())
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
		return medicineRepository.findByNameContainingIgnoreCase(name).stream().map(this::toResponse).toList();
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findByManufacturer(String manufacturer) {
		log.info("Finding medicines by manufacturer: {}", manufacturer);
		return medicineRepository.findByManufacturerContainingIgnoreCase(manufacturer)
			.stream()
			.map(this::toResponse)
			.toList();
	}

	@Transactional(readOnly = true)
	public List<MedicineResponse> findByDosageForm(String dosageForm) {
		log.info("Finding medicines by dosage form: {}", dosageForm);
		return medicineRepository.findByDosageForm(dosageForm).stream().map(this::toResponse).toList();
	}

	@Transactional(readOnly = true)
	public MedicineResponse findByName(String name) {
		log.info("Finding medicine by exact name: {}", name);
		Medicine medicine = medicineRepository.findByName(name)
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
	public List<MedicineResponse> findByRequiresPrescription(boolean requiresPrescription) {
		log.info("Finding medicines by prescription requirement: {}", requiresPrescription);
		return medicineRepository.findByRequiresPrescription(requiresPrescription)
			.stream()
			.map(this::toResponse)
			.toList();
	}

	private MedicineResponse toResponse(Medicine medicine) {
		return new MedicineResponse(medicine.getId(), medicine.getName(), medicine.getManufacturer(),
				medicine.getDosageForm(), medicine.isRequiresPrescription(), medicine.getBarcode());
	}

}