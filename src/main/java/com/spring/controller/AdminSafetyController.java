package com.spring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.service.SafetyCheckService;

@Controller
@RequestMapping("/admin")
public class AdminSafetyController {

    @Autowired
    private SafetyCheckService safetyCheckService;

    /**
     * 안전점검 페이지 이동
     */
    @GetMapping("/safetyCheck")
    public String safetyCheckPage() {
        return "admin/safetyCheck";
    }

    /**
     * 안전점검 결과 DB 저장 (AJAX POST)
     */
    @PostMapping("/safetyCheck/save")
    @ResponseBody
    public String saveSafetyCheck(@RequestBody SafetyCheckMasterDTO masterDTO) {
        try {
            safetyCheckService.saveSafetyCheck(masterDTO);
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return "FAIL";
        }
    }
}