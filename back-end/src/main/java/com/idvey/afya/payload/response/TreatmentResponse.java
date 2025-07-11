package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class TreatmentResponse {

	private UUID id;

	private String name;

	private Date startDate;

	private Date endDate;

	private List<String> diseaseNames;

}