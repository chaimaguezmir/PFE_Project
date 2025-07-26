package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class PrescriptionDetailResponse {

	private UUID id;

	private String name;

	private LocalDate startDate;

	private LocalDate endDate;

	private LocalDateTime createdAt;

	private LocalDateTime updatedAt;

	private List<DiseaseResponse> diseases;

	private List<TreatmentResponse> treatments;

}