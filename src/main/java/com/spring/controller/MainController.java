package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    // 1. 처음 접속 시 메인 껍데기(main.jsp) 호출
    @GetMapping("/")
    public String index() {
        return "main"; // WEB-INF/views/main.jsp 실행
    }

    // 2. 비동기(AJAX)로 지도 조각만 가져올 때
    @GetMapping("/festival/map")
    public String getMapFragment() {
        return "fragments/festival_map"; // WEB-INF/views/fragments/festival_map.jsp 반환
    }
}