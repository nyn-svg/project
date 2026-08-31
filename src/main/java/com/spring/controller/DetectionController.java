package com.spring.controller; // 프로젝트의 실제 패키지 경로로 수정해주세요.

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DetectionController {

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
}