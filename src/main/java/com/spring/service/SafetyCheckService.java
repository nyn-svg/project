package com.spring.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.dto.SafetyCheckDetailDTO;
import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.mapper.SafetyCheckMapper;

@Service
public class SafetyCheckService {

    @Autowired
    private SafetyCheckMapper safetyCheckMapper;

    /**
     * 안전점검 결과 저장 (마스터 + 상세 항목 트랜잭션 저장)
     */
    @Transactional
    public void saveSafetyCheck(SafetyCheckMasterDTO masterDTO) {
        // 1. 마스터 데이터 저장 (시퀀스 채번되어 masterDTO.checkId에 저장됨)
        safetyCheckMapper.insertMaster(masterDTO);

        // 2. 상세 항목 데이터 반복 저장
        if (masterDTO.getDetailList() != null) {
            for (SafetyCheckDetailDTO detail : masterDTO.getDetailList()) {
                // 마스터에서 생성된 checkId를 상세 항목의 FK로 세팅
                detail.setCheckId(masterDTO.getCheckId());
                safetyCheckMapper.insertDetail(detail);
            }
        }
    }
    
    /**
     * 가장 최근에 작성된 안전점검 데이터(마스터 + 상세 항목) 조회
     */
    public SafetyCheckMasterDTO getLatestSafetyCheck() {
        // 1. 가장 최근 마스터 정보 1건 조회
        SafetyCheckMasterDTO master = safetyCheckMapper.selectLatestMaster();
        
        // 2. 마스터 데이터가 존재하면 해당 checkId의 상세 20개 항목 목록 바인딩
        if (master != null) {
            master.setDetailList(safetyCheckMapper.selectDetailsByCheckId(master.getCheckId()));
        }
        
        return master;
    }
    
    /**
     * Google Gemini API를 호출하여 실제 안전점검 법적 보고서 생성
     */
    public String callLlmApiForReport(SafetyCheckMasterDTO master) {
        // 🔑 발급받으신 Gemini API 키 (AQ. 형식 헤더 전송 방식 적용)
        String apiKey = ""; 

        if (apiKey == null || apiKey.trim().isEmpty() || apiKey.equals("YOUR_GEMINI_API_KEY")) {
            return "[API 키 미설정]\nSafetyCheckService.java 파일에 Gemini API Key를 입력해 주세요.";
        }

        try {
        	// 1. 프롬프트 구성 (행정안전부 지역축제 안전관리 지침 맞춤형)
            StringBuilder prompt = new StringBuilder();
            prompt.append("당신은 행정안전부 [지역축제 안전관리 매뉴얼] 및 [재난 및 안전관리 기본법] 기준에 숙달된 축제·행사 안전관리 전문가입니다.\n");
            prompt.append("축제장 관리자가 작성한 안전점검 항목 데이터를 바탕으로 공식 [지역축제장 안전점검 법적 결과 보고서]를 작성해 주세요.\n\n");
            
            prompt.append("### [축제 점검 개요]\n");
            prompt.append("- 점검일자: ").append(master.getCheckDate()).append("\n");
            prompt.append("- 점검회차: ").append(master.getCheckRound()).append("회차\n");
            prompt.append("- 점검자: ").append(master.getInspector()).append("\n\n");
            
            prompt.append("### [점검 세부 데이터]\n");
            if (master.getDetailList() != null) {
                for (SafetyCheckDetailDTO detail : master.getDetailList()) {
                    prompt.append("- 항목: ").append(detail.getItemNo())
                          .append(" | 상태: ").append(detail.getStatusCode())
                          .append(" | 비고: ").append(detail.getRemark() != null && !detail.getRemark().isEmpty() ? detail.getRemark() : "특이사항 없음")
                          .append("\n");
                }
            }

            prompt.append("\n### [작성 양식 및 지침]\n");
            prompt.append("1. **축제장 종합 안전 평가**: 행사장의 전반적인 안전 상태 및 관람객 안전 확보 수준 총평\n");
            prompt.append("2. **행안부 지침 기준 주요 위험/경고 항목 분석**: WARN(경계), DANGER(심각) 항목에 대해 인파 관람, 가설 무대/부스 구조물, 전기·가스·소방 위험성 관점에서의 원인 분석\n");
            prompt.append("3. **법적 및 행정지침 준수성 평가**: 「재난 및 안전관리 기본법」 및 행정안전부 축제 안전관리 가이드라인 기준 충족 여부 판단\n");
            prompt.append("4. **현장 시정조치 및 안전관리자 이행 가이드**: 행사 운영 전 즉시 조치해야 할 사항과 현장 요원 대응 지침\n");

            // 2. Gemini API 요청 JSON 구성
            ObjectMapper objectMapper = new ObjectMapper();
            
            Map<String, Object> textPart = new HashMap<>();
            textPart.put("text", prompt.toString());

            List<Map<String, Object>> partsList = new ArrayList<>();
            partsList.add(textPart);

            Map<String, Object> contentMap = new HashMap<>();
            contentMap.put("parts", partsList);

            List<Map<String, Object>> contentsList = new ArrayList<>();
            contentsList.add(contentMap);

            Map<String, Object> requestBodyMap = new HashMap<>();
            requestBodyMap.put("contents", contentsList);

            String jsonRequestBody = objectMapper.writeValueAsString(requestBodyMap);

         // 3. Gemini REST API URL (구글 안내 최신 모델 적용)
            String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent";

            URL url = new URL(endpoint);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            // AQ. 키 인증 헤더
            conn.setRequestProperty("x-goog-api-key", apiKey.trim());
            conn.setDoOutput(true);

            // 4. 데이터 전송
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonRequestBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // 5. 응답 수신
            int responseCode = conn.getResponseCode();
            BufferedReader br;
            if (responseCode == 200) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            } else {
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
            }

            StringBuilder response = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }

            if (responseCode != 200) {
                return "Gemini API 호출 실패 (코드 " + responseCode + "): " + response.toString();
            }

            // 6. Gemini JSON 응답에서 텍스트 추출 (candidates[0].content.parts[0].text)
            JsonNode rootNode = objectMapper.readTree(response.toString());
            JsonNode textNode = rootNode.path("candidates")
                                        .get(0)
                                        .path("content")
                                        .path("parts")
                                        .get(0)
                                        .path("text");

            if (textNode.isMissingNode() || textNode.isNull()) {
                return "Gemini API 응답에서 작성된 문장을 찾을 수 없습니다.";
            }

            return textNode.asText();

        } catch (Exception e) {
            e.printStackTrace();
            return "Gemini API 연동 처리 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
}