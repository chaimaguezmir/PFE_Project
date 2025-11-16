package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class UserPrescriptionResponse {

	private PrescriptionResponse prescription;

	private UserBasicInfoResponse userInfo;

}
