package com.idvey.afya.security.service;

import com.idvey.afya.models.Medication;
import com.idvey.afya.models.MyMedication;
import com.idvey.afya.models.Prescription;
import com.idvey.afya.models.groupe.Group;
import com.idvey.afya.payload.request.PrescriptionRequest;
import com.idvey.afya.payload.response.PrescriptionResponse;
import com.idvey.afya.repository.MedicationRepository;
import com.idvey.afya.repository.MyMedicationRepository;
import com.idvey.afya.repository.PrescriptionRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;
@Service
@RequiredArgsConstructor
public class PrescriptionService {

    private final PrescriptionRepository prescriptionRepository;
    private final MyMedicationRepository myMedicationRepository;
    private final MedicationRepository medicationRepository;



    @Transactional
    public PrescriptionResponse create(UUID userId, PrescriptionRequest request) {
        Medication medication = medicationRepository
                .getByName(request.getMedicationName())
                .orElse(null);

        MyMedication myMedication = null;
        if (medication == null) {
            myMedication = myMedicationRepository.findByName(request.getMedicationName())
                    .orElse(null);
            if (myMedication == null) {
                throw new NoSuchElementException("Medication not found in user's box or my medications");
            }
        }

        // Check group membership
        boolean isUserInGroup = false;
        if (medication != null) {
            isUserInGroup = medication.getMyMedications().stream()
                    .anyMatch(med -> med.getPharmacyBox().getGroup().getMembers().stream()
                            .anyMatch(member -> member.getUser().getId().equals(userId)));
        }
        if (myMedication != null) {
            isUserInGroup = myMedication.getPharmacyBox().getGroup().getMembers().stream()
                    .anyMatch(member -> member.getUser().getId().equals(userId));
        }
        if (!isUserInGroup) {
            throw new SecurityException("Access denied: medication not in your group");
        }

        Prescription p = Prescription.builder()
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .dosagePerDay(request.getDosagePerDay())
                .medication(medication) // can be null
                .myMedication(myMedication) // add this field to Prescription if not present
                .build();

        return toResponse(prescriptionRepository.save(p));
    }

    public List<PrescriptionResponse> getAllForUser(UUID userId) {
        return prescriptionRepository.findByUserId(userId).stream()
                .map(this::toResponse)
                .toList();
    }

//    public void delete(UUID id, UUID userId) {
//        Prescription p = prescriptionRepository.findById(id)
//                .orElseThrow(() -> new NoSuchElementException("Not found"));
//
//        UUID ownerId = p.getMyMedication().getPharmacyBox().getGroup().getMembers().stream()
//                .filter(m -> m.getRole().name().equals("MANAGER")) // logique adaptable
//                .findFirst().map(m -> m.getUser().getId())
//                .orElseThrow();
//
//        if (!ownerId.equals(userId)) throw new SecurityException("Not authorized");
//
//        prescriptionRepository.delete(p);
//    }

    private PrescriptionResponse toResponse(Prescription p) {
        return new PrescriptionResponse(
                p.getId(),
                p.getStartDate(),
                p.getEndDate(),
                p.getDosagePerDay(),
                p.getMedication().getName()
        );
    }
}