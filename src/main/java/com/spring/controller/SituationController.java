package com.spring.controller;

import java.io.File;
import java.security.Principal;
import java.util.UUID;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.dto.SituationDTO;
import com.spring.service.SituationService;

@Controller
@RequestMapping("/agent")
public class SituationController {

    @Autowired
    private SituationService situationService;

    // 상황 보고 AJAX 비동기 등록 API (파일 업로드 지원)
    @PostMapping("/api/report")
    @ResponseBody
    public ResponseEntity<String> registerReport(
            SituationDTO situation,
            @RequestParam(value = "photo", required = false) MultipartFile photo,
            HttpServletRequest request,
            Principal principal) {
        
        try {
            // 1. 사용자 아이디 설정
            if (principal != null) {
                situation.setUserId(principal.getName());
            } else {
                situation.setUserId("agent01"); // 테스트용
            }

            // 2. 파일 업로드 처리 (사진이 첨부된 경우만 진행)
            if (photo != null && !photo.isEmpty()) {
                // 웹 프로젝트 내의 업로드 폴더 실제 경로 구하기 (/resources/upload/situation)
                String uploadPath = request.getServletContext().getRealPath("/resources/upload/situation");
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs(); // 폴더가 없으면 생성
                }

                // 파일명 중복 방지를 위한 UUID 파일명 생성
                String originalFilename = photo.getOriginalFilename();
                String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;

                // 서버 디렉토리에 파일 저장
                File destFile = new File(uploadPath, savedFilename);
                photo.transferTo(destFile);

                // DTO에 저장된 파일명 세팅
                situation.setSituImage(savedFilename);
            }

            // 3. DB 저장 Service 호출
            boolean isSuccess = situationService.registerSituation(situation);

            if (isSuccess) {
                return ResponseEntity.ok("SUCCESS");
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("FAIL");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("ERROR");
        }
    }
}