package com.idvey.afya.security.service;

import com.idvey.afya.models.Medication;
import com.idvey.afya.models.MyMedication;
import com.idvey.afya.models.PharmacyBox;
import com.idvey.afya.payload.request.MyMedicationUpdateRequest;
import com.idvey.afya.payload.request.MyMedicationRequest;
import com.idvey.afya.payload.response.MyMedicationResponse;
import com.idvey.afya.repository.GroupMemberRepository;
import com.idvey.afya.repository.MedicationRepository;
import com.idvey.afya.repository.MyMedicationRepository;
import com.idvey.afya.repository.PharmacyBoxRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MyMedicationService {

	private final MyMedicationRepository myMedicationRepository;

	private final PharmacyBoxRepository pharmacyBoxRepository;

	private final MedicationRepository medicationRepository;

	private final GroupMemberRepository groupMemberRepository;

	public MyMedicationResponse create(MyMedicationRequest request, UUID userId) {
		PharmacyBox box = pharmacyBoxRepository.findById(request.getPharmacyBoxId())
				.orElseThrow(() -> new NoSuchElementException("PharmacyBox not found"));

		UUID groupId = box.getGroup().getId();
		if (!groupMemberRepository.existsByUser_IdAndGroup_Id(userId, groupId)) {
			throw new SecurityException("Access denied: not a member of the group");
		}

		Medication med = null;
		if (request.getMedicationId() != null && !request.getMedicationId().toString().isEmpty()) {
			med = medicationRepository.findById(request.getMedicationId()).orElse(null);
			// Always add new MyMedication when medicationId is provided
			MyMedication myMed = MyMedication.builder()
					.pharmacyBox(box)
					.medication(med)
					.name(request.getName())
					.quantity(request.getQuantity())
					.expirationDate(request.getExpirationDate())
					.build();
			return toResponse(myMedicationRepository.save(myMed));
		} else {
			// Update by name if exists, else add new
			MyMedication myMed = myMedicationRepository
					.findByPharmacyBoxIdAndName(request.getPharmacyBoxId(), request.getName())
					.orElse(null);
			if (myMed != null) {
				myMed.setExpirationDate(request.getExpirationDate());
				String quantity = String.valueOf(Integer.parseInt(myMed.getQuantity()) + Integer.parseInt(request.getQuantity()));
				myMed.setQuantity(quantity);
			} else {
				myMed = MyMedication.builder()
						.pharmacyBox(box)
						.medication(null)
						.name(request.getName())
						.quantity(request.getQuantity())
						.expirationDate(request.getExpirationDate())
						.build();
			}
			return toResponse(myMedicationRepository.save(myMed));
		}
	}
	public List<MyMedicationResponse> getByBox(UUID boxId, UUID userId) {
		PharmacyBox box = pharmacyBoxRepository.findById(boxId)
			.orElseThrow(() -> new NoSuchElementException("PharmacyBox not found"));

		UUID groupId = box.getGroup().getId();
		if (!groupMemberRepository.existsByUser_IdAndGroup_Id(userId, groupId)) {
			throw new SecurityException("Access denied: not a member of the group");
		}

		// Use the eager fetch method here
		return myMedicationRepository.findByPharmacyBoxIdWithMedication(boxId).stream().map(this::toResponse).toList();
	}

	@Transactional
	public void delete(UUID id, UUID userId) {
		MyMedication myMed = myMedicationRepository.findById(id)
			.orElseThrow(() -> new NoSuchElementException("MyMedication not found"));

		UUID groupId = myMed.getPharmacyBox().getGroup().getId();
		if (!groupMemberRepository.existsByUser_IdAndGroup_Id(userId, groupId)) {
			throw new SecurityException("Access denied: not a member of the group");
		}

		myMedicationRepository.deleteById(id);
	}

	@Transactional
	public MyMedicationResponse update(UUID myMedicationId, UUID userId, MyMedicationUpdateRequest request) {
		MyMedication myMedication = myMedicationRepository.findById(myMedicationId)
				.orElseThrow(() -> new NoSuchElementException("MyMedication not found"));

		UUID groupId = myMedication.getPharmacyBox().getGroup().getId();
		boolean isMember = groupMemberRepository.existsByUser_IdAndGroup_Id(userId, groupId);
		if (!isMember) {
			throw new SecurityException("You are not a member of this group");
		}

		if (request.getQuantity() != null) {
			myMedication.setQuantity(request.getQuantity());
		}
		if (request.getExpirationDate() != null) {
			myMedication.setExpirationDate(request.getExpirationDate());
		}

		MyMedication saved = myMedicationRepository.save(myMedication);
		Medication medication = saved.getMedication();
		return MyMedicationResponse.builder()
				.id(saved.getId())
				.quantity(saved.getQuantity())
				.expirationDate(saved.getExpirationDate())
				.medicationName(medication != null ? medication.getName() : saved.getName())
				.build();
	}

	private MyMedicationResponse toResponse(MyMedication med) {
		return new MyMedicationResponse(med.getId() ,med.getName(), med.getQuantity(), med.getExpirationDate());
	}

}
