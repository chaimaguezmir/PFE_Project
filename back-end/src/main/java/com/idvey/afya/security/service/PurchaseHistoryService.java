package com.idvey.afya.security.service;

import com.idvey.afya.models.MedicinePurchaseHistory;
import com.idvey.afya.models.MyMedicine;
import com.idvey.afya.payload.request.AddPurchaseHistoryRequest;
import com.idvey.afya.payload.request.UpdatePurchaseHistoryRequest;
import com.idvey.afya.payload.response.PurchaseHistoryResponse;
import com.idvey.afya.repository.MedicinePurchaseHistoryRepository;
import com.idvey.afya.repository.MyMedicineRepository;
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
public class PurchaseHistoryService {

    private final MedicinePurchaseHistoryRepository purchaseHistoryRepository;
    private final MyMedicineRepository myMedicineRepository;
    private final GroupMemberRepository groupMemberRepository;

    @Transactional
    public PurchaseHistoryResponse addPurchaseHistory(UUID userId, AddPurchaseHistoryRequest request) throws AccessDeniedException {
        log.info("Adding purchase history for MyMedicine: {} by user: {}", request.getMyMedicineId(), userId);

        MyMedicine myMedicine = myMedicineRepository.findById(request.getMyMedicineId())
                .orElseThrow(() -> new NoSuchElementException("MyMedicine not found"));

        // 🔒 AUTHORIZATION CHECK
        validateUserAccessToMyMedicine(userId, myMedicine);

        MedicinePurchaseHistory history = MedicinePurchaseHistory.builder()
                .quantityPurchased(request.getQuantityPurchased())
                .expiryDate(request.getExpiryDate())
                .myMedicine(myMedicine)
                .build();

        MedicinePurchaseHistory saved = purchaseHistoryRepository.save(history);
        log.info("Purchase history created with ID: {} by user: {}", saved.getId(), userId);

        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public List<PurchaseHistoryResponse> getPurchaseHistoryByMyMedicine(UUID userId, UUID myMedicineId) throws AccessDeniedException {
        log.info("Fetching purchase history for MyMedicine: {} by user: {}", myMedicineId, userId);

        MyMedicine myMedicine = myMedicineRepository.findById(myMedicineId)
                .orElseThrow(() -> new NoSuchElementException("MyMedicine not found"));

        validateUserAccessToMyMedicine(userId, myMedicine);

        return purchaseHistoryRepository.findByMyMedicineIdOrderByCreatedAtDesc(myMedicineId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    // Internal method (no authorization needed)
    @Transactional(readOnly = true)
    public List<PurchaseHistoryResponse> getPurchaseHistoryByMyMedicine(UUID myMedicineId) {
        log.info("Fetching purchase history for MyMedicine (internal): {}", myMedicineId);
        return purchaseHistoryRepository.findByMyMedicineIdOrderByCreatedAtDesc(myMedicineId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<PurchaseHistoryResponse> getPurchaseHistoryByMyMedicineBasic(UUID userId, UUID myMedicineId) throws AccessDeniedException {
        log.info("Fetching basic purchase history for MyMedicine: {} by user: {}", myMedicineId, userId);

        MyMedicine myMedicine = myMedicineRepository.findById(myMedicineId)
                .orElseThrow(() -> new NoSuchElementException("MyMedicine not found"));

        validateUserAccessToMyMedicine(userId, myMedicine);

        return purchaseHistoryRepository.findByMyMedicine_Id(myMedicineId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<PurchaseHistoryResponse> getPurchaseHistoryByDateRange(UUID userId, UUID myMedicineId,
                                                                       java.time.LocalDateTime startDate, java.time.LocalDateTime endDate) throws AccessDeniedException {
        log.info("Fetching purchase history for MyMedicine {} between {} and {} by user: {}",
                myMedicineId, startDate, endDate, userId);

        MyMedicine myMedicine = myMedicineRepository.findById(myMedicineId)
                .orElseThrow(() -> new NoSuchElementException("MyMedicine not found"));

        validateUserAccessToMyMedicine(userId, myMedicine);

        return purchaseHistoryRepository.findByMyMedicineIdAndCreatedAtBetween(myMedicineId, startDate, endDate)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<PurchaseHistoryResponse> getExpiredPurchases() {
        log.info("Fetching expired purchases");
        return purchaseHistoryRepository.findExpiredPurchases(java.time.LocalDate.now())
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<PurchaseHistoryResponse> getPurchasesExpiringBetween(java.time.LocalDate startDate,
                                                                     java.time.LocalDate endDate) {
        log.info("Fetching purchases expiring between {} and {}", startDate, endDate);
        return purchaseHistoryRepository.findPurchasesExpiringBetween(startDate, endDate)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<PurchaseHistoryResponse> getPurchaseHistoryByPharmacyBox(UUID userId, UUID pharmacyBoxId) throws AccessDeniedException {
        log.info("Fetching purchase history for pharmacy box: {} by user: {}", pharmacyBoxId, userId);

        // Validate user access to pharmacy box
        if (!groupMemberRepository.existsByUser_IdAndGroup_Id(userId, pharmacyBoxId)) {
            throw new AccessDeniedException("User does not have access to this pharmacy box");
        }

        return purchaseHistoryRepository.findByPharmacyBoxIdOrderByCreatedAtDesc(pharmacyBoxId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional
    public PurchaseHistoryResponse updatePurchaseHistory(UUID userId, UUID id, UpdatePurchaseHistoryRequest request) throws AccessDeniedException {
        log.info("Updating purchase history: {} by user: {}", id, userId);

        MedicinePurchaseHistory history = purchaseHistoryRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Purchase history not found"));

        validateUserAccessToMyMedicine(userId, history.getMyMedicine());

        history.setQuantityPurchased(request.getQuantityPurchased());
        history.setExpiryDate(request.getExpiryDate());

        MedicinePurchaseHistory updated = purchaseHistoryRepository.save(history);
        log.info("Purchase history updated: {} by user: {}", id, userId);

        return toResponse(updated);
    }

    @Transactional
    public void deletePurchaseHistory(UUID userId, UUID id) throws AccessDeniedException {
        log.info("Deleting purchase history: {} by user: {}", id, userId);

        MedicinePurchaseHistory history = purchaseHistoryRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Purchase history not found"));

        validateUserAccessToMyMedicine(userId, history.getMyMedicine());

        purchaseHistoryRepository.deleteById(id);
        log.info("Purchase history deleted: {} by user: {}", id, userId);
    }

    // Internal methods (no authorization needed)
    @Transactional(readOnly = true)
    public Long getTotalQuantityPurchased(UUID myMedicineId) {
        log.info("Getting total quantity purchased for MyMedicine: {}", myMedicineId);
        return purchaseHistoryRepository.getTotalQuantityPurchasedByMyMedicine(myMedicineId);
    }

    @Transactional(readOnly = true)
    public long getPurchaseHistoryCount(UUID myMedicineId) {
        log.info("Getting purchase history count for MyMedicine: {}", myMedicineId);
        return purchaseHistoryRepository.countByMyMedicineId(myMedicineId);
    }

    // 🔒 AUTHORIZATION VALIDATION METHOD
    private void validateUserAccessToMyMedicine(UUID userId, MyMedicine myMedicine) throws AccessDeniedException {
        boolean hasAccess = groupMemberRepository.existsByUser_IdAndGroup_Id(userId, myMedicine.getPharmacyBox().getGroup().getId());
        if (!hasAccess) {
            throw new AccessDeniedException("User does not have access to this medicine");
        }
    }

    private PurchaseHistoryResponse toResponse(MedicinePurchaseHistory history) {
        return new PurchaseHistoryResponse(
                history.getId(),
                history.getQuantityPurchased(),
                history.getExpiryDate(),
                history.getCreatedAt(),
                history.getMyMedicine().getId(),
                history.getMyMedicine().getName()
        );
    }
}