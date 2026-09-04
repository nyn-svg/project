package com.spring.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
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
    private static DroneService droneService; // 드론 관리 서비스 DI
    
    /**
     * 관제사 
     */
    private static final List<Map<String, Object>> droneList = Collections.synchronizedList(new ArrayList<>());
    
    // 활성화 드론만 불러오는 service 추가하고 변경하기
    static {
        if (droneList.isEmpty()) {
        	Map<String, Object> drones = new HashMap<>();
        	
        	List<DroneDTO> list = droneService.getDroneList();
        	for(DroneDTO drone : list) {
        		drones.put("id", drone.getDroneId());
        		drones.put("url", drone.getUrl());
        		drones.put("zone", drone.getZoneName());
        		drones.put("status", drone.getDroneStatus());
        		drones.put("active", drone.getActiveStatus());
        	}
            droneList.add(drones); 
        }
    }

    @GetMapping("/api/list")
    @ResponseBody
    public List<Map<String, Object>> getDroneList() {
        return droneList;
    }

    @PostMapping("/api/add")
    @ResponseBody
    public Map<String, Object> addDrone(@RequestBody Map<String, Object> param) {
    	String newId = "";
    	int nextNumber = droneList.size() + 1;
    	if(nextNumber < 10) {
    		newId = "DRONE-0" + nextNumber;
    	} else {
    		newId = "DRONE-" + nextNumber;
    	}
    	
    	DroneDTO setDrone = new DroneDTO();
        setDrone.setDroneId(newId);
        setDrone.setUrl((String)param.get("url"));
        setDrone.setZoneName((String)param.get("zone"));
        
        droneService.registerDrone(setDrone);
        
        DroneDTO getDrone = droneService.getDroneById(newId);
        Map<String, Object> newDrone = new HashMap<>();
        newDrone.put("id", getDrone.getDroneId());
        newDrone.put("url", getDrone.getUrl());
        newDrone.put("zone", getDrone.getZoneName());
        newDrone.put("status", getDrone.getDroneStatus());
        newDrone.put("active", getDrone.getActiveStatus());
        droneList.add(newDrone);

        // 드론 변동 알림을 SSE 전용 서비스로 전송
        sseService.sendEvent("drone_change", "updated");

        return Map.of("result", "SUCCESS");
    }

    @PostMapping("/api/update")
    @ResponseBody
    public Map<String, Object> updateDrone(@RequestBody Map<String, Object> param) {
    	String droneId = (String) param.get("id");
    	
    	DroneDTO setDrone = new DroneDTO();
        setDrone.setDroneId(droneId);
        setDrone.setUrl((String)param.get("url"));
        setDrone.setZoneName((String)param.get("zone"));
        setDrone.setDroneStatus((String)param.get("status"));
        setDrone.setActiveStatus((String)param.get("active"));
        
        droneService.modifyDrone(setDrone);
        
        DroneDTO getDrone = droneService.getDroneById(droneId);
        
        if(getDrone != null) {
	        for (Map<String, Object> drone : droneList) {
	            if (getDrone.getDroneId().equals(drone.get("id"))) {
	                drone.put("url", getDrone.getUrl());
	                drone.put("zone", getDrone.getZoneName());
	                drone.put("status", getDrone.getDroneStatus());
	                drone.put("active", getDrone.getActiveStatus());
	                break;
	            }
	        }

	        // 드론 변동 알림 전송
	        sseService.sendEvent("drone_change", "updated");
	
	        return Map.of("result", "SUCCESS");
        }
        
        // 💡 getDrone이 null인 경우 (ID 누락 혹은 없는 드론 수정 시)
        return Map.of("result", "FAIL", "message", "드론 정보를 찾을 수 없습니다.");
    }

    @PostMapping("/api/delete")
    @ResponseBody
    public Map<String, Object> deleteDrone(@RequestBody Map<String, Object> param) {
    	String droneId = (String) param.get("id");
    	
    	DroneDTO setDrone = droneService.getDroneById(droneId);
    	if (setDrone != null) {
	        setDrone.setActiveStatus("비활성화");
	        
	        droneService.modifyDrone(setDrone);
	    	
	        droneList.clear(); // 기존 메모리 싹 비우고
	        // DB에서 '활성화' 상태인 드론들만 새로 싹 긁어와서 채워 넣습니다.
	        List<Map<String, Object>> activeDrones = droneService.getActiveDroneList(); 
	        droneList.addAll(activeDrones);
	
	        // 드론 변동 알림 전송
	        sseService.sendEvent("drone_change", "updated");
	
	        return Map.of("result", "SUCCESS");
    	}
    	
    	return Map.of("result", "SUCCESS", "message", "이미 처리된 드론입니다.");
    }
    
    /**
     * 관리자
     */
}