package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

    // 1. 로그인 페이지 이동
    @GetMapping("/login")
    public String loginPage() {
        return "login"; // /WEB-INF/views/login.jsp
    }

}