package com.spring.controller;

import java.io.File;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.dto.SituationDTO;
import com.spring.service.SituationService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class SituationController {

    @Autowired
    private SituationService situationService;
    
    // 공유 감지조치이력 목록
 	private static final List<SituationDTO> situationList = Collections.synchronizedList(new ArrayList<>());
    
    // 전체 감지조치이력 목록 조회
    @GetMapping("/total/api/list")
    @ResponseBody
    public List<SituationDTO> getTotalSituationList() {
		// 리스트가 비어있을 때만 (최초 1회만) DB에서 조회해서 채움
		if (situationList.isEmpty()) {
			// 여러 요청이 동시에 들어와도 안전하게 딱 한 번만 채우도록 동기화 잠금
			synchronized (situationList) {
				// 더블 체크
				if (situationList.isEmpty()) {
					List<SituationDTO> list = situationService.getTotalSituationList();
					situationList.addAll(list);
				}
			}
		}
		
		return situationList;
	}
    
    // 상세 보기 팝업 창 호출
    @GetMapping("/detection/detail")
    public String getDetectionDetail(@RequestParam("no") String situNo, Model model) {
        
        // DB에서 SITU_NO 값으로 단건 조회
        SituationDTO situation = situationService.getSituationBySituNo(situNo);
        
        // JSP로 객체 전달
        model.addAttribute("situation", situation);
        
        // WEB-INF/views/detection/detail.jsp 로 이동
        return "detection/detail"; 
    }
    
	/*
	 * // 감지조치이력 목록 조회 (검색조건 포함)
	 * 
	 * @GetMapping("/detect/list")
	 * 
	 * @ResponseBody public List<SituationDTO> getSituationList() {
	 * 
	 * }
	 * 
	 * // (수동) 위험 감지 이력 등록
	 * 
	 * @PostMapping("/detect/regist")
	 * 
	 * @ResponseBody public Map<String, Object> registSituation() {
	 * 
	 * }
	 * 
	 * // (자동) 위험 감지 이력 AJAX 비동기 등록 API (파일 업로드 지원)
	 * 
	 * @PostMapping("/detect/api/insert")
	 * 
	 * @ResponseBody public Map<String, Object> insertSituation() {
	 * 
	 * }
	 */
    
    // 상황 보고(긴급 보고) AJAX 비동기 등록 API (파일 업로드 지원)
    @PostMapping("/agent/api/report")
    @ResponseBody
    public ResponseEntity<String> registerReport(SituationDTO situation,
    											 @RequestParam(value = "photo", required = false) MultipartFile photo,
      											 HttpServletRequest request,
      											 Principal principal) {
    	
        try {
            // 1. 사용자 아이디 설정
            if (principal != null) {
                situation.setFinder(principal.getName());
            } else {
                // 리다이렉트?
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
    
	/*
	 * // 감지 이력 수정 또는 조치 이력 입력
	 * 
	 * @PostMapping("/detect/modify")
	 * 
	 * @ResponseBody public Map<String, Object> modifySituation() {
	 * 
	 * }
	 */
}