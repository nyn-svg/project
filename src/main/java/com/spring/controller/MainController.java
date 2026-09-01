package com.spring.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MainController {

    // 1. 메인 첫 진입 ("/")
    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("contentPage", "/WEB-INF/views/mainContent.jsp");
        return "main";
    }

 // 2. 드론 관제 화면 (/drone/stream)
    @GetMapping("/drone/stream")
    public String droneStream(
            @RequestParam(value = "id", required = false, defaultValue = "A") String droneId,
            @RequestParam(value = "name", required = false) String droneName, // ★ 추가
            HttpServletRequest request,
            Model model) {

        // droneName이 들어오지 않은 경우 droneId를 기본값으로 사용
        if (droneName == null || droneName.trim().isEmpty()) {
            droneName = droneId;
        }

        model.addAttribute("droneId", droneId);
        model.addAttribute("droneName", droneName); // ★ JSP로 droneName 전달

        String viewPath = "/WEB-INF/views/drone/stream.jsp";

        // AJAX 비동기 요청 시 JSP 조각만 응답
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            return "drone/stream";
        }

        // 새로고침/직접접속 시 전체 껍데기 + 요청한 페이지 경로 전달
        model.addAttribute("contentPage", viewPath);
        return "main";
    }
    /**
     * 감지 이력 현황 페이지 이동
     */
    @GetMapping("/detection")
    public String detectionStatusPage(Model model) {
        
        // 메인 레이아웃(main.jsp)의 <jsp:include page="${contentPage}" /> 에 주입될 경로
        model.addAttribute("contentPage", "/WEB-INF/views/detection/detection-status.jsp");
        
        // 상단 헤더 메뉴 active 처리를 위한 구분값 (필요 시 활용)
        model.addAttribute("currentMenu", "detection");

        // 메인 레이아웃 JSP 파일명을 리턴 (예: main, index, layout 등 프로젝트 설정명에 맞게 지정)
        return "main"; 
    }
    
 // 실시간 감지 임시 페이지 이동 매핑
    @GetMapping("/realtime")
    public String realtimePage(Model model) {
    	model.addAttribute("contentPage", "/WEB-INF/views/realtime.jsp");
    	model.addAttribute("currentMenu", "realtime");
        return "main"; 
    }
    
 // 조치록 메인/목록 페이지 이동 
    @GetMapping("/actionLog")
    public String actionLogPage(Model model) {
        // 메인 컨텐츠 영역에 들어갈 조치록 JSP 경로 설정
        model.addAttribute("contentPage", "/WEB-INF/views/control/actionLog.jsp");
        model.addAttribute("currentMenu", "actionLog");
        return "main"; 
    }
    
}