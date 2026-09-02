package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class GuideController {

    /**
     * 행사장 안전관리 가이드 매뉴얼 (메인 페이지)
     * URL: http://localhost:8081/ (또는 /guide/main)
     */
    @GetMapping("/guide/main")
    public String guideMain() {
        // WEB-INF/views/guideMain.jsp (또는 설정된 ViewResolver 경로)
        return "guideMain";
    }
}