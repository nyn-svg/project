package com.spring.controller;

import java.io.File;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
    
    // 전체 공유용 감지조치이력 목록
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
    
    // (수동) 위험 감지 이력 등록
    @GetMapping("/detection/regist")
    public String getDetectionRegist() {
    	return "detection/regist";
    }
    @PostMapping("/detection/regist")
    public String postDetectionRegist(SituationDTO situation, @RequestParam(value = "photo", required = false) MultipartFile photo, HttpServletRequest request, Principal principal) {
    	try {
    		if (principal != null) {
                situation.setFinder(principal.getName());
            } else {
                // 세션이 만료되었거나 로그인 정보가 없는 경우에도 실패 화면으로 처리
                return "status/regist_fail"; 
            }
    		
            // 1. 파일 업로드 처리 (사진이 첨부된 경우만 진행)
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
            
            situation.setSituType("수동감지");
            // 3. DB 저장 Service 호출
            boolean isSuccess = situationService.registerSituation(situation);

            if (isSuccess) {
                // 성공 처리
                return "redirect:/regist_success";
            } else {
            	// 실패 처리 (비즈니스 로직 실패)
            	return "status/regist_fail";
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 에러 처리 (파일 업로드 중 오류, DB 접속 오류 등)
            return "status/regist_fail";
        }
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
     * // (자동) 위험 감지 이력 AJAX 비동기 등록 API (파일 업로드 지원)
     * 
     * @PostMapping("/detect/api/insert")
     * 
     * @ResponseBody public Map<String, Object> insertSituation() {
     * 
     * }
     */
    
 // 💡 SituationController.java 파일 내의 registerReport 메서드를 아래 코드로 완전히 교체하세요.

    @PostMapping("/agent/api/report")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> registerReport(
            SituationDTO situation,
            @RequestParam(value = "photo", required = false) MultipartFile photo,
            HttpServletRequest request,
            Principal principal) {
        
        Map<String, Object> result = new HashMap<>();
        try {
            // 1. 로그인 사용자 아이디 설정 (발견인 : FINDER)
            if (principal != null) {
                situation.setFinder(principal.getName());
            } else {
                // 시큐리티 컨텍스트 세션이 없거나 비로그인 테스트 중일 때 방어용 기본값 설정
                situation.setFinder("agent01"); 
            }

            // 2. 비즈니스 약속 고정 항목 데이터 강제 주입
            situation.setSituType("긴급보고");  // 감지유형 고정
            situation.setSituStatus("감지");    // 초기 조치상태 고정
            // ※ 감지일시(SITU_DATE)는 MyBatis XML단에서 SYSDATE로 들어가므로 Java단 설정 불필요 (수정불가)

            // 3. 파일 업로드 처리 (사진이 첨부된 경우만 진행)
            if (photo != null && !photo.isEmpty()) {
                String uploadPath = request.getServletContext().getRealPath("/resources/upload/situation");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String originalFilename = photo.getOriginalFilename();
                String ext = originalFilename.substring(originalFilename.lastIndexOf("."));
                String savedFilename = UUID.randomUUID().toString() + ext; // 중복방지 깔끔한 파일명

                File destFile = new File(uploadPath, savedFilename);
                photo.transferTo(destFile);

                situation.setSituImage(savedFilename); // DTO에 첨부파일명 매핑
            }

            // 4. DB 저장 Service 호출
            // (★ 중요: registerSituation 내부에서 mapper.insertSituation이 실행되면 
            //  MyBatis의 <selectKey>에 의해 situation 객체의 situNo 필드에 진짜 DB 이력번호가 채워집니다!)
            boolean isSuccess = situationService.registerSituation(situation);

            if (isSuccess) {
                result.put("success", true);
                result.put("situNo", situation.getSituNo()); // 🚨 생성된 진짜 이력번호를 결과에 담아 전송!
                return ResponseEntity.ok(result);
            } else {
                result.put("success", false);
                result.put("message", "DB 데이터 삽입 실패");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "서버 오류: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
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

    // =========================================================================
    // [현장 조치 승인 및 관리 기능 - fieldAction.jsp 연동 API]
    // =========================================================================

    // 현장 조치 목록 비동기 조회 (statusType: PENDING / HISTORY)
    @GetMapping("/admin/fieldAction/api/list")
    @ResponseBody
    public List<SituationDTO> getFieldActionList(@RequestParam(value = "statusType", defaultValue = "PENDING") String statusType) {
        return situationService.getFieldActionList(statusType);
    }

    // 모달용 단건 상세정보 비동기 조회
    @GetMapping("/admin/fieldAction/api/detail")
    @ResponseBody
    public SituationDTO getFieldActionDetail(@RequestParam("actionId") String actionId) {
        return situationService.getSituationBySituNo(actionId);
    }

    // 현장 조치 승인 / 반려 처리
    @PostMapping("/admin/fieldAction/process")
    @ResponseBody
    public Map<String, Object> processFieldAction(@RequestParam("actionId") String actionId,
                                                  @RequestParam("status") String status,
                                                  @RequestParam(value = "adminComment", required = false) String adminComment,
                                                  Principal principal) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 로그인한 관리자 계정 ID 세팅
            String adminId = (principal != null) ? principal.getName() : "ADMIN";
            
            // 승인/반려 비즈니스 로직 수행
            boolean isSuccess = situationService.processFieldAction(actionId, status, adminComment, adminId);

            if (isSuccess) {
                response.put("status", "success");
                response.put("message", "성공적으로 처리되었습니다.");
            } else {
                response.put("status", "fail");
                response.put("message", "처리에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "서버 처리 중 오류 발생: " + e.getMessage());
        }
        return response;
    }
}