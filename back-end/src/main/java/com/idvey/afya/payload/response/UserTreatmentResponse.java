package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class UserTreatmentResponse {

	private TreatmentResponse treatment;

	private UserBasicInfoResponse userInfo;

}
