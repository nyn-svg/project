package com.spring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.SafetyCheckDetailDTO;
import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.service.SafetyCheckService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminSafetyController {

    @Autowired
    private SafetyCheckService safetyCheckService;

    /**
     * 안전점검 페이지 이동
     */
    @GetMapping("/safetyCheck")
    public String safetyCheckPage(HttpSession session, Model model) {
        // 본문 JSP 경로 지정
        model.addAttribute("contentPage", "/WEB-INF/views/admin/safetyCheck.jsp");
        
        return "layout/mainLayout";
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
    
    
    /**
     * AI 법적 보고서 생성 요청 처리
     */
    @PostMapping(value = "/safetyCheck/generateReport", produces = "text/plain; charset=UTF-8")
    @ResponseBody
    public ResponseEntity<String> generateReport() {
        try {
            // 1. 가장 최근 저장된 안전점검 데이터(마스터 + 상세 20개 항목) 조회
            SafetyCheckMasterDTO latestCheck = safetyCheckService.getLatestSafetyCheck();

            if (latestCheck == null) {
                return ResponseEntity.ok("작성된 안전점검 내역이 없습니다. 먼저 점검표를 작성하고 저장해 주세요.");
            }

            // 2. LLM 서비스 호출하여 보고서 생성 (API 키가 없으면 샘플 양식 반환)
            String reportResult = safetyCheckService.callLlmApiForReport(latestCheck);

            return ResponseEntity.ok(reportResult);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("보고서 생성 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}