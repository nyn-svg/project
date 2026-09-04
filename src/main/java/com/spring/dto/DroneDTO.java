package com.spring.dto;

import lombok.Data;

@Data
public class DroneDTO {
	private String droneId;			// 드론아이디
	private String url;				// 스트리밍주소
	private String droneStatus;		// 비행상태
	private String activeStatus;	// 활성상태
	private String zoneName;		// 구역명
}
