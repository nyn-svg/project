package com.spring.controller; // 본인 패키지명에 맞게 유지

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MapController {

    // 브라우저에서 /map 으로 접속하면 map.jsp를 보여줌
    @RequestMapping("/map")
    public String showMapPage() {
        return "map"; 
    }
}