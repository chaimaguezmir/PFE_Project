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
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineService {

	private final MedicineRepository medicineRepository;

	@Transactional
	public MedicineResponse createMedicine(CreateMedicineRequest request) {
		log.info("Creating medicine with name: {}", request.getName());

		// Normalize inputs
		String normalizedName = request.getName().trim();
		String normalizedDosage = request.getDosage() != null ? request.getDosage().trim() : null;
		String normalizedForm = request.getForm() != null ? request.getForm().trim() : null;

		// ✅ PHARMACEUTICAL APPROACH: Allow same drug name with different strengths/forms
		// But prevent exact duplicates of the complete medicine specification

		// Check for exact duplicate (name + dosage + form combination)
		if (normalizedDosage != null && normalizedForm != null) {
			boolean exactDuplicateExists = medicineRepository.existsByNameAndDosageAndForm(
					normalizedName, normalizedDosage, normalizedForm);

			if (exactDuplicateExists) {
				throw new IllegalStateException(
						String.format("Medicine already exists: %s %s %s",
								normalizedName, normalizedDosage, normalizedForm)
				);
			}
		} else {
			// If dosage or form is missing, check just by name (stricter)
			if (medicineRepository.existsByNameIgnoreCase(normalizedName)) {
				throw new IllegalStateException("Medicine with name '" + normalizedName + "' already exists");
			}
		}

		// ✅ BARCODE CHECK (always unique)
		if (request.getBarcode() != null && !request.getBarcode().trim().isEmpty()) {
			if (medicineRepository.existsByBarcode(request.getBarcode().trim())) {
				throw new IllegalStateException("Medicine with barcode '" + request.getBarcode() + "' already exists");
			}
		}

		// 💡 HELPFUL SUGGESTION: Find similar medicines
		List<Medicine> similarMedicines = medicineRepository.findByNameIgnoreCase(normalizedName);
		if (!similarMedicines.isEmpty()) {
			log.info("ℹ️ Found {} existing medicines with similar name '{}': {}",
					similarMedicines.size(),
					normalizedName,
					similarMedicines.stream()
							.map(m -> String.format("%s %s %s", m.getName(), m.getDosage(), m.getForm()))
							.collect(Collectors.joining(", "))
			);
		}

		Medicine medicine = Medicine.builder()
				.name(normalizedName)
				.manufacturer(request.getManufacturer() != null ? request.getManufacturer().trim() : "Unknown")
				.requiresPrescription(request.isRequiresPrescription())
				.barcode(request.getBarcode() != null ? request.getBarcode().trim() : null)
				.designation(request.getDesignation() != null ? request.getDesignation().trim() : null)
				.dosage(normalizedDosage)
				.form(normalizedForm)
				.build();

		Medicine saved = medicineRepository.save(medicine);
		log.info("✅ Medicine created: {} {} {} (ID: {})",
				saved.getName(), saved.getDosage(), saved.getForm(), saved.getId());

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
	public List<MedicineResponse> findByForm(String form) {
		log.info("Finding medicines by form: {}", form);
		return medicineRepository.findByForm(form).stream().map(this::toResponse).toList();
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
		return new MedicineResponse(
				medicine.getId(),
				medicine.getName(),
				medicine.getManufacturer(),
				medicine.isRequiresPrescription(),
				medicine.getBarcode(),
				medicine.getDesignation(),
				medicine.getDosage(),
				medicine.getForm()
		);
	}

}