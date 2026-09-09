package com.spring.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.dto.AreaSaveRequestDTO;
import com.spring.mapper.AreaMapper;
import com.spring.service.SseService;

import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/admin/area")
public class AdminAreaController {

    @Autowired
    private AreaMapper areaMapper;
    @Autowired
    private SseService sseService;

    @PostMapping(value = "/save", produces = "application/json;charset=UTF-8", consumes = "application/json;charset=UTF-8")
    public ResponseEntity<Map<String, Object>> saveAreaConfig(@RequestBody AreaSaveRequestDTO requestDTO) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 1. DTO 객체를 JSON 문자열로 변환
            ObjectMapper objectMapper = new ObjectMapper();
            String configJson = objectMapper.writeValueAsString(requestDTO);

            // 2. 기존 도면 데이터가 존재하는지 먼저 조회
            String mapName = "메인도면";
            String existingConfig = areaMapper.selectAreaConfig(mapName);

            int result = 0;

            // 3. 존재 여부에 따라 UPDATE 또는 INSERT 분기 수행
            if (existingConfig != null) {
                result = areaMapper.updateAreaConfig(mapName, configJson);
            } else {
                result = areaMapper.insertAreaConfig(mapName, configJson);
            }

            if (result > 0) {

                // 💡 [핵심 수정] SSE 알림 전송 중 소켓 에러가 터져도 DB 저장 응답에 영향을 주지 않도록 격리
                try {
                    sseService.sendEvent("MAP_UPDATED", requestDTO);
                } catch (Exception sseEx) {
                    // 끊긴 클라이언트 연결로 인한 에러 로그 출력 방지 및 격리 처리
                    System.err.println("SSE 브로드캐스트 전송 제외 (클라이언트 연결 끊김): " + sseEx.getMessage());
                }

                response.put("success", true);
                response.put("message", "행사장 배치 데이터가 오라클 DB에 성공적으로 저장되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "DB 저장 처리 중 실패했습니다.");
                return ResponseEntity.ok(response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "저장 중 오류 발생: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    
    @GetMapping("/get")
    public ResponseEntity<Map<String, Object>> getAreaConfig() {
        Map<String, Object> response = new HashMap<>();

        try {
            // DB에서 '메인도면' 이름으로 저장된 JSON 문자열 조회
            String configJson = areaMapper.selectAreaConfig("메인도면");

            if (configJson != null && !configJson.isEmpty()) {
                response.put("success", true);
                response.put("configJson", configJson);
            } else {
                response.put("success", false);
                response.put("message", "저장된 배치 데이터가 없습니다.");
            }
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "불러오기 중 오류 발생: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    @PostMapping("/uploadMap")
    public ResponseEntity<Map<String, Object>> uploadMapImage(
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request) {

        Map<String, Object> response = new HashMap<>();

        if (file.isEmpty()) {
            response.put("success", false);
            response.put("message", "업로드할 파일이 없습니다.");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            // 1. 실제 파일 저장 디렉토리 경로 확보 (/resources/upload/map)
            String uploadPath = request.getServletContext().getRealPath("/resources/upload/map/");
            File dir = new File(uploadPath);

            if (!dir.exists()) {
                dir.mkdirs(); // 디렉토리가 없으면 생성
            } else {
                // 2. 기존 폴더 내부 파일 삭제 (2번 방식: 기존 이미지 덮어쓰기/삭제)
                File[] existingFiles = dir.listFiles();
                if (existingFiles != null) {
                    for (File f : existingFiles) {
                        if (f.isFile()) {
                            f.delete();
                        }
                    }
                }
            }

            // 3. 파일명 생성 (캐싱 방지를 위한 덮어쓰기용 고정 파일명 또는 타임스탬프)
            String originalFilename = file.getOriginalFilename();
            String ext = originalFilename.substring(originalFilename.lastIndexOf("."));
            String savedFileName = "main_map_" + System.currentTimeMillis() + ext;

            File targetFile = new File(uploadPath, savedFileName);
            file.transferTo(targetFile);

            // 4. 웹에서 접근 가능한 URL 경로 생성
            String fileUrl = request.getContextPath() + "/resources/upload/map/" + savedFileName;

            response.put("success", true);
            response.put("fileUrl", fileUrl);
            response.put("message", "도면 이미지가 성공적으로 업로드되었습니다.");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "파일 업로드 실패: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    @GetMapping(value = "/sse", produces = "text/event-stream")
    public SseEmitter subscribeSse() {
        return sseService.subscribe();
    }
    
    
}