package com.idvey.afya.security.service;

import com.idvey.afya.models.MyMedicine;
import com.idvey.afya.models.Prescription;
import com.idvey.afya.models.Treatment;
import com.idvey.afya.payload.request.CreateTreatmentRequest;
import com.idvey.afya.payload.request.UpdateTreatmentRequest;
import com.idvey.afya.payload.response.MedicineResponse;
import com.idvey.afya.payload.response.MyMedicineResponse;
import com.idvey.afya.payload.response.TreatmentResponse;
import com.idvey.afya.repository.MyMedicineRepository;
import com.idvey.afya.repository.PrescriptionRepository;
import com.idvey.afya.repository.TreatmentRepository;
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
public class TreatmentService {

    private final TreatmentRepository treatmentRepository;
    private final PrescriptionRepository prescriptionRepository;
    private final MyMedicineRepository myMedicineRepository;
    private final PrescriptionService prescriptionService;

    @Transactional
    public TreatmentResponse createTreatment(UUID userId, CreateTreatmentRequest request) {
        log.info("Creating treatment for prescription: {} by user: {}", request.getPrescriptionId(), userId);

        Prescription prescription = prescriptionRepository.findById(request.getPrescriptionId())
                .orElseThrow(() -> new NoSuchElementException("Prescription not found"));

        // Verify ownership
        if (!prescription.getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Prescription does not belong to user");
        }

        MyMedicine myMedicine = myMedicineRepository.findById(request.getMyMedicineId())
                .orElseThrow(() -> new NoSuchElementException("MyMedicine not found"));

        Treatment treatment = Treatment.builder()
                .dosage(request.getDosage())
                .frequency(request.getFrequency())
                .durationDays(request.getDurationDays())
                .prescription(prescription)
                .myMedicine(myMedicine)
                .build();

        Treatment saved = treatmentRepository.save(treatment);
        log.info("Treatment created with ID: {}", saved.getId());

        // Update prescription end date after adding treatment
        prescriptionService.updatePrescriptionEndDate(prescription.getId());

        return toResponse(saved);
    }

    @Transactional
    public TreatmentResponse updateTreatment(UUID userId, UUID treatmentId, UpdateTreatmentRequest request) {
        log.info("Updating treatment: {} by user: {}", treatmentId, userId);

        Treatment treatment = treatmentRepository.findById(treatmentId)
                .orElseThrow(() -> new NoSuchElementException("Treatment not found"));

        // Verify ownership
        if (!treatment.getPrescription().getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Treatment does not belong to user");
        }

        treatment.setDosage(request.getDosage());
        treatment.setFrequency(request.getFrequency());
        treatment.setDurationDays(request.getDurationDays());

        Treatment updated = treatmentRepository.save(treatment);
        log.info("Treatment updated: {}", treatmentId);

        // Update prescription end date after updating treatment
        prescriptionService.updatePrescriptionEndDate(treatment.getPrescription().getId());

        return toResponse(updated);
    }

    @Transactional
    public void deleteTreatment(UUID userId, UUID treatmentId) {
        log.info("Deleting treatment: {} by user: {}", treatmentId, userId);

        Treatment treatment = treatmentRepository.findById(treatmentId)
                .orElseThrow(() -> new NoSuchElementException("Treatment not found"));

        // Verify ownership
        if (!treatment.getPrescription().getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Treatment does not belong to user");
        }

        UUID prescriptionId = treatment.getPrescription().getId();
        treatmentRepository.deleteById(treatmentId);
        log.info("Treatment deleted: {}", treatmentId);

        // Update prescription end date after deleting treatment
        prescriptionService.updatePrescriptionEndDate(prescriptionId);
    }

    @Transactional(readOnly = true)
    public List<TreatmentResponse> getTreatmentsByPrescription(UUID userId, UUID prescriptionId) {
        log.info("Fetching treatments for prescription: {} by user: {}", prescriptionId, userId);

        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new NoSuchElementException("Prescription not found"));

        // Verify ownership
        if (!prescription.getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Prescription does not belong to user");
        }

        return treatmentRepository.findByPrescriptionIdOrderByCreatedAtDesc(prescriptionId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<TreatmentResponse> getAllUserTreatments(UUID userId) {
        log.info("Fetching all treatments for user: {}", userId);

        return treatmentRepository.findAllByUserId(userId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public long getUserTreatmentCount(UUID userId) {
        log.info("Counting treatments for user: {}", userId);
        return treatmentRepository.countByUserId(userId);
    }

    private TreatmentResponse toResponse(Treatment treatment) {
        return new TreatmentResponse(
                treatment.getId(),
                treatment.getDosage(),
                treatment.getFrequency(),
                treatment.getDurationDays(),
                treatment.getCreatedAt(),
                treatment.getUpdatedAt(),
                treatment.getPrescription().getId(),
                treatment.getPrescription().getName(),
                toMyMedicineResponse(treatment.getMyMedicine())
        );
    }

    private MyMedicineResponse toMyMedicineResponse(MyMedicine myMedicine) {
        return new MyMedicineResponse(
                myMedicine.getId(),
                myMedicine.getName(),
                myMedicine.getForm(),
                myMedicine.getPharmacyBox().getId(),
                myMedicine.getPharmacyBox().getGroup().getName(),
                new MedicineResponse(
                        myMedicine.getMedicine().getId(),
                        myMedicine.getMedicine().getName(),
                        myMedicine.getMedicine().getManufacturer(),
                        myMedicine.getMedicine().getDosageForm(),
                        myMedicine.getMedicine().isRequiresPrescription(),
                        myMedicine.getMedicine().getBarcode()
                ),
                0, // totalQuantityPurchased - can be calculated if needed
                0, // purchaseHistoryCount - can be calculated if needed
                myMedicine.getCreatedAt(),
                myMedicine.getUpdatedAt()
        );
    }
}