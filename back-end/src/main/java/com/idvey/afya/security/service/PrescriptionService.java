package com.idvey.afya.security.service;

import com.idvey.afya.models.*;
import com.idvey.afya.payload.request.CreatePrescriptionRequest;
import com.idvey.afya.payload.request.UpdatePrescriptionRequest;
import com.idvey.afya.payload.response.*;
import com.idvey.afya.repository.DiseaseRepository;
import com.idvey.afya.repository.PrescriptionRepository;
import com.idvey.afya.repository.TreatmentRepository;
import com.idvey.afya.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class PrescriptionService {

    private final PrescriptionRepository prescriptionRepository;
    private final UserRepository userRepository;
    private final DiseaseRepository diseaseRepository;
    private final TreatmentRepository treatmentRepository;

    @Transactional
    public PrescriptionResponse createPrescription(UUID userId, CreatePrescriptionRequest request) {
        log.info("Creating prescription for user: {}", userId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NoSuchElementException("User not found"));

        // Get diseases
        Set<Disease> diseases = request.getDiseaseIds().stream()
                .map(id -> diseaseRepository.findById(id)
                        .orElseThrow(() -> new NoSuchElementException("Disease not found with ID: " + id)))
                .collect(Collectors.toSet());

        // Create prescription with current date as start date
        Prescription prescription = Prescription.builder()
                .name(request.getName())
                .startDate(LocalDate.now()) // Always start from today
                .endDate(null) // Will be calculated when treatments are added
                .user(user)
                .diseases(diseases)
                .build();

        Prescription saved = prescriptionRepository.save(prescription);
        log.info("Prescription created with ID: {}", saved.getId());

        return toResponse(saved);
    }

    @Transactional
    public PrescriptionResponse updatePrescription(UUID userId, UUID prescriptionId, UpdatePrescriptionRequest request) {
        log.info("Updating prescription: {} for user: {}", prescriptionId, userId);

        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new NoSuchElementException("Prescription not found"));

        // Verify ownership
        if (!prescription.getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Prescription does not belong to user");
        }

        // Update diseases
        Set<Disease> diseases = request.getDiseaseIds().stream()
                .map(id -> diseaseRepository.findById(id)
                        .orElseThrow(() -> new NoSuchElementException("Disease not found with ID: " + id)))
                .collect(Collectors.toSet());

        prescription.setName(request.getName());
        prescription.setDiseases(diseases);

        Prescription updated = prescriptionRepository.save(prescription);
        log.info("Prescription updated: {}", prescriptionId);

        return toResponse(updated);
    }

    /**
     * Calculate and update prescription end date based on treatments
     * Logic: Find the treatment that ends last and set prescription end date to that date
     */
    @Transactional
    public void updatePrescriptionEndDate(UUID prescriptionId) {
        log.info("Updating prescription end date for prescription: {}", prescriptionId);

        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new NoSuchElementException("Prescription not found"));

        List<Treatment> treatments = treatmentRepository.findByPrescription_Id(prescriptionId);

        if (treatments.isEmpty()) {
            // No treatments, set end date to null
            prescription.setEndDate(null);
        } else {
            // Find the latest end date among all treatments
            LocalDate latestEndDate = treatments.stream()
                    .map(this::calculateTreatmentEndDate)
                    .max(LocalDate::compareTo)
                    .orElse(prescription.getStartDate());

            prescription.setEndDate(latestEndDate);
        }

        prescriptionRepository.save(prescription);
        log.info("Prescription end date updated to: {}", prescription.getEndDate());
    }

    /**
     * Calculate treatment end date based on creation time and duration
     */
    private LocalDate calculateTreatmentEndDate(Treatment treatment) {
        LocalDateTime createdAt = treatment.getCreatedAt();
        Integer durationDays = treatment.getDurationDays();

        // Start date is the creation date, end date is start + duration
        LocalDate startDate = createdAt.toLocalDate();
        return startDate.plusDays(durationDays);
    }

    @Transactional(readOnly = true)
    public List<PrescriptionResponse> getUserPrescriptions(UUID userId) {
        log.info("Fetching prescriptions for user: {}", userId);
        return prescriptionRepository.findByUserIdOrderByCreatedAtDesc(userId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<PrescriptionResponse> getActivePrescriptions(UUID userId) {
        log.info("Fetching active prescriptions for user: {}", userId);
        return prescriptionRepository.findActiveByUserId(userId, LocalDate.now())
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public PrescriptionDetailResponse getPrescriptionDetail(UUID userId, UUID prescriptionId) {
        log.info("Fetching prescription detail: {} for user: {}", prescriptionId, userId);

        Prescription prescription = prescriptionRepository.findByIdWithTreatments(prescriptionId)
                .orElseThrow(() -> new NoSuchElementException("Prescription not found"));

        // Verify ownership
        if (!prescription.getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Prescription does not belong to user");
        }

        return toDetailResponse(prescription);
    }

    @Transactional
    public void deletePrescription(UUID userId, UUID prescriptionId) {
        log.info("Deleting prescription: {} for user: {}", prescriptionId, userId);

        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new NoSuchElementException("Prescription not found"));

        // Verify ownership
        if (!prescription.getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Prescription does not belong to user");
        }

        prescriptionRepository.deleteById(prescriptionId);
        log.info("Prescription deleted: {}", prescriptionId);
    }

    private PrescriptionResponse toResponse(Prescription prescription) {
        return new PrescriptionResponse(
                prescription.getId(),
                prescription.getName(),
                prescription.getStartDate(),
                prescription.getEndDate(),
                prescription.getCreatedAt(),
                prescription.getUpdatedAt(),
                prescription.getDiseases().stream()
                        .map(d -> new DiseaseResponse(d.getId(), d.getName(), d.getPrescriptions().size()))
                        .toList(),
                prescription.getTreatments().size()
        );
    }

    private PrescriptionDetailResponse toDetailResponse(Prescription prescription) {
        return new PrescriptionDetailResponse(
                prescription.getId(),
                prescription.getName(),
                prescription.getStartDate(),
                prescription.getEndDate(),
                prescription.getCreatedAt(),
                prescription.getUpdatedAt(),
                prescription.getDiseases().stream()
                        .map(d -> new DiseaseResponse(d.getId(), d.getName(), d.getPrescriptions().size()))
                        .toList(),
                prescription.getTreatments().stream()
                        .map(t -> new TreatmentResponse(
                                t.getId(),
                                t.getDosage(),
                                t.getFrequency(),
                                t.getDurationDays(),
                                t.getCreatedAt(),
                                t.getUpdatedAt(),
                                t.getPrescription().getId(),
                                t.getPrescription().getName(),
                                toMyMedicineResponse(t.getMyMedicine())
                        ))
                        .toList()
        );
    }

    private MyMedicineResponse toMyMedicineResponse(MyMedicine myMedicine) {
        MedicineResponse medicineResponse = null;
        if (myMedicine.getMedicine() != null) {
            medicineResponse = new MedicineResponse(
                    myMedicine.getMedicine().getId(),
                    myMedicine.getMedicine().getName(),
                    myMedicine.getMedicine().getManufacturer(),
                    myMedicine.getMedicine().getDosageForm(),
                    myMedicine.getMedicine().isRequiresPrescription(),
                    myMedicine.getMedicine().getBarcode()
            );
        }

        return new MyMedicineResponse(
                myMedicine.getId(),
                myMedicine.getName(),
                myMedicine.getForm(),
                myMedicine.getPharmacyBox().getId(),
                myMedicine.getPharmacyBox().getGroup().getName(),
                medicineResponse, // Can be null
                0, // totalQuantityPurchased - can be calculated if needed
                0, // purchaseHistoryCount - can be calculated if needed
                myMedicine.getCreatedAt(),
                myMedicine.getUpdatedAt()
        );
    }
}