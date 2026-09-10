package com.spring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.dto.DroneDTO;
import com.spring.service.DroneService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ControlController {
	
	@Autowired
	private DroneService droneService;

    // 1. 메인 첫 진입
    @GetMapping("/control/main")
    public String index(Model model) {
        model.addAttribute("contentPage", "/WEB-INF/views/control/controlMainContent.jsp");
        return "control/controlMain";
    }
    
    // 실시간 감지 페이지 이동
    @GetMapping("/control/realtime")
    public String realtimePage(Model model) {
    	
    	model.addAttribute("contentPage", "/WEB-INF/views/control/realtime.jsp");
    	model.addAttribute("currentMenu", "realtime");
        return "control/controlMain"; 
    }

    // 2. 드론 관제 화면
    @GetMapping("/control/stream")
    public String droneStream(@RequestParam(value = "id", required = false) String droneId,
    						  @RequestParam(value = "zone", required = false) String zoneName, HttpServletRequest request, Model model) {

        model.addAttribute("droneId", droneId);
        model.addAttribute("zoneName", zoneName);
        
        DroneDTO drone = droneService.getDroneById(droneId);
    	model.addAttribute("drone", drone);

        String viewPath = "/WEB-INF/views/control/stream.jsp";

        // AJAX 비동기 요청 시 JSP 조각만 응답
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            return "control/stream";
        }

        // 새로고침/직접접속 시 전체 껍데기 + 요청한 페이지 경로 전달
        model.addAttribute("contentPage", viewPath);
        return "control/controlMain";
    }
    
    // 감지 이력 현황 페이지 이동
    @GetMapping("/detection")
    public String detectionStatusPage(Model model) {
        
        // 메인 레이아웃(main.jsp)의 <jsp:include page="${contentPage}" /> 에 주입될 경로
        model.addAttribute("contentPage", "/WEB-INF/views/detection/detection-status.jsp");
        
        // 상단 헤더 메뉴 active 처리를 위한 구분값 (필요 시 활용)
        model.addAttribute("currentMenu", "detection");

        // 메인 레이아웃 JSP 파일명을 리턴 (예: main, index, layout 등 프로젝트 설정명에 맞게 지정)
        return "control/controlMain"; 
    }
    
    // 조치록 메인/목록 페이지 이동 
    @GetMapping("/actionLog")
    public String actionLogPage(Model model) {
        // 메인 컨텐츠 영역에 들어갈 조치록 JSP 경로 설정
        model.addAttribute("contentPage", "/WEB-INF/views/report/actionLog.jsp");
        model.addAttribute("currentMenu", "actionLog");
        return "control/controlMain"; 
    }
    
}