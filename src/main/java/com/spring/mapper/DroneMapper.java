package com.spring.mapper;

import java.util.List;

import com.spring.dto.DroneDTO;

public interface DroneMapper {
	
	// 드론아이디로 드론 정보 조회
	DroneDTO findByDroneId(String droneId);
	
	// 전체 드론 목록 조회
	List<DroneDTO> findAllDrones();
	
	// 새 드론 등록
	int insertDrone(DroneDTO drone);
	
	// 드론 정보 수정
	int updateDrone(DroneDTO drone);
	
	// 전체 드론 수
	int getTotalDroneCount();
}
