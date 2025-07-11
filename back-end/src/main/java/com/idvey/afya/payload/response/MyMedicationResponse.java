package com.idvey.afya.payload.response;

import lombok.*;

import java.time.LocalDate;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MyMedicationResponse {

	private UUID id;

	private String medicationName;

	private String quantity;

	private LocalDate expirationDate;

}
