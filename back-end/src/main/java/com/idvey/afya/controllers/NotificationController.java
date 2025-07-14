package com.idvey.afya.controllers;

import com.idvey.afya.payload.request.NotificationRequest;
import com.idvey.afya.payload.response.NotificationResponse;
import com.idvey.afya.security.service.NotificationService;
import com.idvey.afya.security.service.UserDetailsImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

//    @PostMapping("/{prescriptionId}")
//    public ResponseEntity<NotificationResponse> add(@AuthenticationPrincipal UserDetailsImpl user,
//                                                    @PathVariable UUID prescriptionId,
//                                                    @RequestBody NotificationRequest request) {
//        return ResponseEntity.ok(notificationService.add(user.getId(), prescriptionId, request));
//    }

    @GetMapping("/{prescriptionId}")
    public ResponseEntity<List<NotificationResponse>> get(@PathVariable UUID prescriptionId) {
        return ResponseEntity.ok(notificationService.getByPrescription(prescriptionId));
    }

//    @DeleteMapping("/{id}")
//    public ResponseEntity<Void> delete(@AuthenticationPrincipal UserDetailsImpl user,
//                                       @PathVariable UUID id) {
//        notificationService.delete(id, user.getId());
//        return ResponseEntity.noContent().build();
//    }
}
