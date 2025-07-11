package com.idvey.afya.payload.request;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.Set;
import java.util.UUID;

@Getter
@Setter
public class TreatmentRequest {

	private String name;

	private Date startDate;

	private Date endDate;

	private Set<UUID> diseaseIds;

}