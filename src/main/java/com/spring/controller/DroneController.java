package com.spring.controller;

import com.spring.service.SseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/drone")
public class DroneController {

    @Autowired
    private SseService sseService; // SSE 서비스 주입

    private static final List<Map<String, Object>> droneList = Collections.synchronizedList(new ArrayList<>());

    static {
        if (droneList.isEmpty()) {
            Map<String, Object> dA = new HashMap<>(); dA.put("id", "A"); dA.put("name", "드론 A"); dA.put("status", "LIVE");
            droneList.add(dA); 
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
        String name = (String) param.get("name");
        String newId = (char)('A' + droneList.size()) + "_" + (System.currentTimeMillis() % 1000);

        Map<String, Object> newDrone = new HashMap<>();
        newDrone.put("id", newId);
        newDrone.put("name", name);
        newDrone.put("status", "LIVE");
        droneList.add(newDrone);

        // 드론 변동 알림을 SSE 전용 서비스로 전송
        sseService.sendEvent("drone_change", "updated");

        return Map.of("result", "SUCCESS");
    }

    @PostMapping("/api/update")
    @ResponseBody
    public Map<String, Object> updateDrone(@RequestBody Map<String, Object> param) {
        String id = (String) param.get("id");
        String name = (String) param.get("name");

        for (Map<String, Object> drone : droneList) {
            if (drone.get("id").equals(id)) {
                drone.put("name", name);
                break;
            }
        }

        // 드론 변동 알림 전송
        sseService.sendEvent("drone_change", "updated");

        return Map.of("result", "SUCCESS");
    }

    @PostMapping("/api/delete")
    @ResponseBody
    public Map<String, Object> deleteDrone(@RequestBody Map<String, Object> param) {
        String id = (String) param.get("id");
        droneList.removeIf(drone -> drone.get("id").equals(id));

        // 드론 변동 알림 전송
        sseService.sendEvent("drone_change", "updated");

        return Map.of("result", "SUCCESS");
    }
}