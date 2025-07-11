package com.idvey.afya.security.service;

import com.idvey.afya.models.Medication;
import com.idvey.afya.payload.request.MedicationRequest;
import com.idvey.afya.payload.response.MedicationResponse;
import com.idvey.afya.repository.MedicationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MedicationService {

	private final MedicationRepository medicationRepository;

	public MedicationResponse create(MedicationRequest request) {
		if (medicationRepository.findByNameContainingIgnoreCase(request.getName())
			.stream()
			.anyMatch(m -> m.getName().equalsIgnoreCase(request.getName()))) {
			throw new IllegalStateException("Medication name already exists");
		}
		if (medicationRepository.existsByBarcode(request.getBarcode())) {
			throw new IllegalStateException("A medication with this barcode already exists");
		}
		try {
			Medication med = Medication.builder()
				.name(request.getName())
				.code(request.getCode())
				.manufacturer(request.getManufacturer())
				.barcode(request.getBarcode())
				.build();
			return toResponse(medicationRepository.save(med));
		}
		catch (DataIntegrityViolationException ex) {
			throw new IllegalStateException("Invalid data or duplicate entry");
		}
		catch (Exception ex) {
			throw new RuntimeException("Unexpected error while creating medication");
		}
	}

	public List<MedicationResponse> getAll() {
		try {
			return medicationRepository.findAll().stream().map(this::toResponse).toList();
		}
		catch (Exception ex) {
			throw new RuntimeException("Failed to fetch medications");
		}
	}

	public List<MedicationResponse> searchByName(String name) {
		try {
			return medicationRepository.findByNameContainingIgnoreCase(name).stream().map(this::toResponse).toList();
		}
		catch (Exception ex) {
			throw new RuntimeException("Failed to search medications by name");
		}
	}

	public MedicationResponse getByBarcode(String barcode) {
		try {
			Medication med = medicationRepository.findByBarcode(barcode)
				.orElseThrow(() -> new NoSuchElementException("Medication not found with barcode"));
			return toResponse(med);
		}
		catch (NoSuchElementException ex) {
			throw ex;
		}
		catch (Exception ex) {
			throw new RuntimeException("Failed to fetch medication by barcode");
		}
	}

	public MedicationResponse update(UUID id, MedicationRequest request) {
		try {
			Medication med = medicationRepository.findById(id)
				.orElseThrow(() -> new NoSuchElementException("Medication not found"));
			// Check if the name is changing and if the new name already exists
			if (medicationRepository.findByNameContainingIgnoreCase(request.getName())
				.stream()
				.anyMatch(m -> m.getName().equalsIgnoreCase(request.getName()))) {
				throw new IllegalStateException("Medication name already exists");
			}
			// Check if the barcode is changing and if the new barcode already exists
			if (!med.getBarcode().equals(request.getBarcode())
					&& medicationRepository.existsByBarcode(request.getBarcode())) {
				throw new IllegalStateException("A medication with this barcode already exists");
			}

			med.setName(request.getName());
			med.setCode(request.getCode());
			med.setManufacturer(request.getManufacturer());
			med.setBarcode(request.getBarcode());

			return toResponse(medicationRepository.save(med));
		}
		catch (NoSuchElementException | IllegalStateException ex) {
			throw ex;
		}
		catch (DataIntegrityViolationException ex) {
			throw new IllegalStateException("Invalid data or duplicate entry");
		}
		catch (Exception ex) {
			throw new RuntimeException("Failed to update medication");
		}
	}

	public void delete(UUID id) {
		try {
			if (!medicationRepository.existsById(id)) {
				throw new NoSuchElementException("Medication not found");
			}
			medicationRepository.deleteById(id);
		}
		catch (NoSuchElementException ex) {
			throw ex;
		}
		catch (Exception ex) {
			throw new RuntimeException("Failed to delete medication");
		}
	}

	private MedicationResponse toResponse(Medication med) {
		return new MedicationResponse(med.getId(), med.getBarcode(), med.getName(), med.getCode(),
				med.getManufacturer());
	}

}