package com.idvey.afya.security.service;

import com.idvey.afya.models.Notification;
import com.idvey.afya.models.NotificationStatus;
import com.idvey.afya.models.Prescription;
import com.idvey.afya.payload.request.NotificationRequest;
import com.idvey.afya.payload.response.NotificationResponse;
import com.idvey.afya.repository.NotificationRepository;
import com.idvey.afya.repository.PrescriptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final PrescriptionRepository prescriptionRepository;

//    public NotificationResponse add(UUID userId, UUID prescriptionId, NotificationRequest request) {
//        Prescription prescription = prescriptionRepository.findById(prescriptionId)
//                .orElseThrow(() -> new NoSuchElementException("Prescription not found"));
//
//        // Vérifier l'accès
//        UUID groupUserId = prescription.getMyMedication().getPharmacyBox().getGroup()
//                .getMembers().stream()
//                .filter(m -> m.getUser().getId().equals(userId))
//                .map(m -> m.getUser().getId())
//                .findFirst().orElseThrow(() -> new SecurityException("Access denied"));
//
//        Notification notif = Notification.builder()
//                .label(request.getLabel())
//                .time(request.getTime())
//                .status(request.getStatus() != null ? request.getStatus() : NotificationStatus.PENDING)
//                .prescription(prescription)
//                .build();
//
//        return toResponse(notificationRepository.save(notif));
//    }

    public List<NotificationResponse> getByPrescription(UUID prescriptionId) {
        return notificationRepository.findByPrescription_Id(prescriptionId)
                .stream().map(this::toResponse).toList();
    }

//    public void delete(UUID id, UUID userId) {
//        Notification n = notificationRepository.findById(id)
//                .orElseThrow(() -> new NoSuchElementException("Notification not found"));
//
//        UUID ownerId = n.getPrescription().getMyMedication().getPharmacyBox().getGroup()
//                .getMembers().stream()
//                .filter(m -> m.getUser().getId().equals(userId))
//                .map(m -> m.getUser().getId())
//                .findFirst().orElseThrow(() -> new SecurityException("Access denied"));
//
//        notificationRepository.deleteById(id);
//    }

    private NotificationResponse toResponse(Notification n) {
        return new NotificationResponse(n.getId(), n.getLabel(), n.getTime(), n.getStatus());
    }
}