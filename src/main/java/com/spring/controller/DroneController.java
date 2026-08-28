package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/drone")
public class DroneController {

    /*
     * /drone/stream 요청은 MainController에서 전체 레이아웃 / 비동기 조각으로 분기 처리하므로 
     * 충돌 방지를 위해 이 곳의 매핑을 제거/주석 처리합니다.
     * 
    @GetMapping("/stream")
    public String streamPage(@RequestParam(value = "id", required = false, defaultValue = "A") String droneId, Model model) {
        model.addAttribute("droneId", droneId);
        return "drone/stream"; 
    }
    */
}