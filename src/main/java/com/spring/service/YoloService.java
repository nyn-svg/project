package com.spring.service;

import java.io.File;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
public class YoloService {

    // 파이썬 AI 서버의 연산 API 주소
    private static final String PYTHON_SERVER_URL = "http://192.168.1.222:5000/api/detect";

    /**
     * 이미지 파일을 파이썬 YOLO 서버로 보내 밀집도 및 동물 감지 결과를 받아옵니다.
     * @param imageFile 분석할 이미지 파일
     * @param droneId 드론 구분값 ("drone1" 또는 "drone2")
     * @return 파이썬 서버에서 응답한 JSON 문자열
     */
    public String detectImage(File imageFile, String droneId) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            // HTTP 헤더 설정 (Multipart-FormData 방식)
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            // 파라미터 구성 (파일 및 드론 ID)
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("file", new FileSystemResource(imageFile));
            body.add("drone_id", droneId != null ? droneId : "drone1");

            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

            // 파이썬 서버로 POST 요청 전송
            ResponseEntity<String> response = restTemplate.postForEntity(PYTHON_SERVER_URL, requestEntity, String.class);

            return response.getBody();

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"status\":\"error\", \"message\":\"파이썬 AI 서버 통신 실패: " + e.getMessage() + "\"}";
        }
    }
}