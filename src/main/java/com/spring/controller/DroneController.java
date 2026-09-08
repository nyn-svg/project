package com.spring.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.DroneDTO;
import com.spring.service.DroneService;
import com.spring.service.SseService;

@Controller
@RequestMapping("/drone")
public class DroneController {

	@Autowired
	private SseService sseService; // SSE 서비스 주입

	@Autowired
	private DroneService droneService; // 드론 관리 서비스 DI

	/**
	 * 관제사
	 */
	
	// 공유 드론 리스트
	private static final List<DroneDTO> droneList = Collections.synchronizedList(new ArrayList<>());
	
	@GetMapping("/api/list")
	@ResponseBody
	// 외부에서 드론 리스트를 꺼내 쓸 때 사용하는 getter 메서드
	public List<DroneDTO> getDroneList() {
		// 리스트가 비어있을 때만 (최초 1회만) DB에서 조회해서 채움
		if (droneList.isEmpty()) {
			// 여러 요청이 동시에 들어와도 안전하게 딱 한 번만 채우도록 동기화 잠금
			synchronized (droneList) {
				// 더블 체크
				if (droneList.isEmpty()) {
					List<DroneDTO> list = droneService.getActiveDroneList(); // 활성화 된 드론만 조회
					droneList.addAll(list);
				}
			}
		}
		
		return droneList;
	}
	
	@PostMapping("/api/add")
	@ResponseBody
	public Map<String, Object> addDrone(@RequestBody DroneDTO drone) {
		droneService.registerDrone(drone);
		String newId = drone.getDroneId(); // DB가 만들어준 ID 꺼내기
		
		DroneDTO getDrone = droneService.getDroneById(newId);
		if (getDrone != null) {
			synchronized (droneList) {
				droneList.add(getDrone);
			}
			
			// 드론 변동 알림을 SSE 전용 서비스로 전송
			sseService.sendEvent("drone_change", "updated");
			return Map.of("result", "SUCCESS");
		}
		return Map.of("result", "FAIL", "message", "등록에 실패했습니다. 다시 시도해주세요.");
	}

	@PostMapping("/api/update")
	@ResponseBody
	public Map<String, Object> updateDrone(@RequestBody DroneDTO drone) {
		String droneId = drone.getDroneId();
		DroneDTO getDrone = droneService.getDroneById(droneId); // 이전 정보
		
		if (getDrone != null) {
			droneService.modifyDrone(drone);
			getDrone = droneService.getDroneById(droneId); // 수정된 정보
			
			int i = 0;
			synchronized (droneList) {
				for (DroneDTO droneOne : droneList) {
					if (droneOne.getDroneId().equals(getDrone.getDroneId())) {
						droneList.set(i, getDrone);
						break;
					}
					i += 1;
				}
			}
			
			// 드론 변동 알림 전송
			sseService.sendEvent("drone_change", "updated");
			return Map.of("result", "SUCCESS");
		}
		// 💡 getDrone이 null인 경우 (존재하지 않는 드론 수정 시)
		return Map.of("result", "FAIL", "message", "해당 드론 정보를 찾을 수 없습니다.");
	}

	@PostMapping("/api/delete")
	@ResponseBody
	public Map<String, Object> deleteDrone(@RequestBody DroneDTO drone) {
		String droneId = drone.getDroneId();
		DroneDTO getDrone = droneService.getDroneById(droneId);
		
		if (getDrone != null) {
			getDrone.setActiveStatus("비활성화");
			droneService.modifyDrone(getDrone);
			
			synchronized (droneList) {
				droneList.clear(); // 기존 메모리 싹 비우고
				
				List<DroneDTO> list = droneService.getActiveDroneList(); // 활성화 된 드론만 조회
				droneList.addAll(list);
			}
			
			// 드론 변동 알림 전송
			sseService.sendEvent("drone_change", "updated");
			return Map.of("result", "SUCCESS");
		}

		return Map.of("result", "FAIL", "message", "존재하지 않는 드론입니다.");
	}
	
	/** 관리자 **/
}