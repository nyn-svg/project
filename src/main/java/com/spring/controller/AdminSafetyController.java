package com.spring.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.service.SafetyCheckService;

import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminSafetyController {

    @Autowired
    private SafetyCheckService safetyCheckService;

    // 🎯 [3단계 추가] root-context.xml에 등록한 JavaMailSender 주입
    @Autowired(required = false)
    private JavaMailSender mailSender;

    /**
     * 안전점검 페이지 이동
     */
    @GetMapping("/safetyCheck")
    public String safetyCheckPage(HttpSession session, Model model) {
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
            SafetyCheckMasterDTO latestCheck = safetyCheckService.getLatestSafetyCheck();

            if (latestCheck == null) {
                return ResponseEntity.ok("작성된 안전점검 내역이 없습니다. 먼저 점검표를 작성하고 저장해 주세요.");
            }

            String reportResult = safetyCheckService.callLlmApiForReport(latestCheck);

            return ResponseEntity.ok(reportResult);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("보고서 생성 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * AI 보고서 이메일 발송 처리 (AJAX POST)
     */
    @PostMapping("/safetyCheck/sendEmail")
    @ResponseBody
    public ResponseEntity<String> sendReportEmail(@RequestBody Map<String, String> payload) {
        try {
            String toEmail = payload.get("email");
            String reportContent = payload.get("content");

            if (toEmail == null || toEmail.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("수신자 이메일 주소가 없습니다.");
            }

            if (mailSender == null) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                     .body("메일 발송 서비스가 설정되지 않았습니다. (root-context.xml 확인 필요)");
            }

            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");


            helper.setFrom("ktwoline123@gmail.com", "드론 AI 관제시스템");
            
            helper.setTo(toEmail);
            helper.setSubject("[드론 AI 관제시스템] AI 안전점검 법적 보고서");
            helper.setText(reportContent, false);

            // 이메일 발송
            mailSender.send(message);

            return ResponseEntity.ok("SUCCESS");

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("메일 전송 중 오류 발생: " + e.getMessage());
        }
    }
}