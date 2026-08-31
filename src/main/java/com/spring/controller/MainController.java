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

    /* 
     * 3. 추후 새로 만드는 페이지들도 동일한 패턴으로 추가하면 됩니다.
     * 예시: 통합 관제 지도 (/map/view)
     *
    @GetMapping("/map/view")
    public String mapView(HttpServletRequest request, Model model) {
        String viewPath = "/WEB-INF/views/map/view.jsp";

        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            return "map/view";
        }

        model.addAttribute("contentPage", viewPath);
        return "main";
    }
    */
 // 실시간 감지 임시 페이지 이동 매핑
    @GetMapping("/realtime")
    public String realtimePage() {
        return "realtime"; // realtime.jsp 파일명 (폴더 구조에 따라 "detection/realtime" 등으로 수정)
    }
    
}