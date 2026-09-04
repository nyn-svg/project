package com.spring.service;

import java.util.List;
import java.util.Map;

import com.spring.dto.DroneDTO;

public interface DroneService {
	
	// 드론아이디로 드론 정보 조회
	DroneDTO getDroneById(String droneId);
		
	// 전체 드론 목록 조회
	List<DroneDTO> getDroneList();
		
	// 새 드론 등록
	boolean registerDrone(DroneDTO drone);
		
	// 드론 정보 수정
	boolean modifyDrone(DroneDTO drone);
	
	// 전체 드론 수
	int getTotalDroneCount();
}
