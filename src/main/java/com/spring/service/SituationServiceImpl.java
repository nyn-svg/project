

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
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.annotation.AdminLog;
import com.spring.dto.SituationDTO;
import com.spring.mapper.SituationMapper;

@Service
public class SituationServiceImpl implements SituationService {

    @Autowired
    private SituationMapper situationMapper;

    @Autowired
    private SseService sseService;
    
    @Autowired
    private AutoReportService autoReportService;

    @Override
    public SituationDTO getSituationBySituNo(String situNo) {
        return situationMapper.findBySituNo(situNo);
    }

    @Override
    public List<SituationDTO> getTotalSituationList() {
        return situationMapper.findAllSituations();
    }

    @Override
    public List<SituationDTO> getSituationList() {
        return situationMapper.findSituations();
    }

    @Override
    public List<SituationDTO> getStartSituationList() {
        return situationMapper.findStartSituations();
    }

    @Override
    public List<SituationDTO> getEndSituationList() {
        return situationMapper.findEndSituations();
    }

    @Override
    @Transactional
    public boolean registerSituation(SituationDTO situation) {
        // 1. DB에 저장
        int result = situationMapper.insertSituation(situation);
        
        // 2. DB 저장 성공 시
        if (result > 0) {
            final String type = situation.getSituType();
            final String level = situation.getDngrLevel();

            // 💡 [핵심 해결] DB 트랜잭션 커밋이 '완전히 끝난 직후'에만 실행
            if (TransactionSynchronizationManager.isSynchronizationActive()) {
                TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                    @Override
                    public void afterCommit() {
                        if ("긴급보고".equals(type)) {
                            // 긴급보고 → 이벤트명: "situation-report"
                            sseService.sendEvent("situation-report", situation);
                        } else { 
                            // 자동감지, 수동감지 → 이벤트명: "situation-alert"
                            sseService.sendEvent("situation-alert", situation);
                            
                            // 위험단계가 '심각'인 경우 10초 타이머 예약
                            if ("심각".equals(level)) {
                                autoReportService.scheduleAutoReport(situation);
                            }
                        }
                    }
                });
            } else {
                // 트랜잭션 동기화가 비활성화 상태일 경우 예외 대비 동기 처리
                if ("긴급보고".equals(type)) {
                    sseService.sendEvent("situation-report", situation);
                } else {
                    sseService.sendEvent("situation-alert", situation);
                    
                    // 위험단계가 '심각'인 경우 10초 타이머 예약
                    if ("심각".equals(level)) {
                        autoReportService.scheduleAutoReport(situation);
                    }
                }
            }
        }
        
        return result > 0;
    }
    @AdminLog(value = "상황 대응 개시", type = "ACTION")
    @Override
    public boolean setStart(String situNo) {
        return situationMapper.startSituation(situNo) > 0;
    }

    @AdminLog(value = "상황 대응 종료", type = "INFO")
    @Override
    public boolean setEnd(SituationDTO situation) {
    	int result = situationMapper.endSituation(situation);
    	
    	if (result > 0) {
        	sseService.sendEvent("situation-end", "END_STATUS");
        }
    	
    	return result > 0;
	}

    @AdminLog(value = "상황 정보 수정", type = "INFO")
    @Override
    public boolean modifySituation(SituationDTO situation) {
        int result = situationMapper.updateSituation(situation);
        
        if (result > 0) {
            if (TransactionSynchronizationManager.isSynchronizationActive()) {
                TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                    @Override
                    public void afterCommit() {
                        sseService.sendEvent("situation-update", situation);
                    }
                });
            } else {
                sseService.sendEvent("situation-update", situation);
            }
        }
        
        return result > 0;
    }
    
    @AdminLog(value = "상황 삭제", type = "WARN")
    @Transactional
	public boolean removeSituation(String situNo) {
		int result = situationMapper.deleteSituation(situNo);
		
		if (result > 0) {
            if (TransactionSynchronizationManager.isSynchronizationActive()) {
                TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                    @Override
                    public void afterCommit() {
                        // 💡 DB 커밋이 완전히 끝난 후 브라우저로 SSE 발송!
                        sseService.sendEvent("situation-delete", "DEL_" + situNo);
                    }
                });
            } else {
                sseService.sendEvent("situation-delete", "DEL_" + situNo);
            }
        }
				
		return result > 0;
	}
    
    @AdminLog(value = "상황 삭제", type = "WARN")
    @Transactional
    public boolean handleMisdetection(String droneId) {
        // 1. 해당 드론(또는 전체)에서 가장 최근에 등록된 '자동감지' 1건의 PK 조회
        String situNo = situationMapper.findLatestAutoDetectionNo(droneId);
        
        if (situNo == null) {
            return false; // 지울 자동감지 이력이 없음
        }

        // 2. 기존 삭제 DAO 메서드 재활용
        int result = situationMapper.deleteSituation(situNo);

        // 3. 삭제 성공 시 SSE 알림으로 실시간 목록 갱신
        if (result > 0) {
            if (TransactionSynchronizationManager.isSynchronizationActive()) {
                TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                    @Override
                    public void afterCommit() {
                        // 💡 DB 커밋이 완전히 끝난 후 브라우저로 SSE 발송!
                    	sseService.sendEvent("situation-delete", "DEL_" + situNo);
                    }
                });
            } else {
            	sseService.sendEvent("situation-delete", "DEL_" + situNo);
            }
        }

        return result > 0;
    }

    @Override
    public int getTotalSituationCount() {
        return situationMapper.getTotalSituationCount();
    }

    @Override
    public int getSituationCount() {
        return situationMapper.getSituationCount();
    }

    @Override
    public int getStartSituationCount() {
        return situationMapper.getStartSituationCount();
    }

    @Override
    public int getEndSituationCount() {
        return situationMapper.getEndSituationCount();
    }
    
    @Override
    public List<SituationDTO> getFieldActionList(String statusType) {
        return situationMapper.getFieldActionList(statusType); 
    }

    @AdminLog(value = "현장 조치 처리", type = "ACTION")
    @Override
    @Transactional // 1. 트랜잭션 어노테이션 추가
    public boolean processFieldAction(String actionId, String status, String adminComment, String adminId) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("actionId", actionId);
        paramMap.put("status", status);
        paramMap.put("adminComment", adminComment);
        paramMap.put("adminId", adminId);

        return situationMapper.processFieldAction(paramMap) > 0;
    }
    
    @Override
    public List<SituationDTO> getTaskListPaged(Map<String, Object> paramMap) {
        return situationMapper.getTaskListPaged(paramMap);
    }

    @Override
    public int getTaskListCount(Map<String, Object> paramMap) {
        return situationMapper.getTaskListCount(paramMap);
    }
    
    /**
     * 축제 종료 후 SITUATIONS 전체 감지/조치 이력 기반 AI 사후 종합 보고서 생성
     */
    public String generatePostFestivalReport() {
        // 🔑 Gemini API 키 입력
        String apiKey = "-";

        if (apiKey == null || apiKey.trim().isEmpty() || apiKey.equals("YOUR_GEMINI_API_KEY")) {
            return "[API 키 미설정]\nSituationService.java 파일에 Gemini API Key를 입력해 주세요.";
        }

        // 1. DB에서 전체 감지/조치 이력 조회
        List<SituationDTO> list = situationMapper.findAllSituations();

        if (list == null || list.isEmpty()) {
            return "조회된 축제 현장 위험 감지 및 조치 이력 데이터가 없습니다.";
        }

        try {
            // 2. 프롬프트 구성 (SITUATIONS 데이터를 통계 및 상세 데이터로 요약)
            StringBuilder prompt = new StringBuilder();
            prompt.append("당신은 행정안전부 [지역축제 안전관리 가이드라인] 및 [재난 및 안전관리 기본법]을 숙지한 축제·행사 관제 종합 평가 전문가입니다.\n");
            prompt.append("축제 기간 동안 실시간 관제 시스템 및 현장 안전요원에 의해 수집된 [위험 감지 및 현장 조치 이력(SITUATIONS)] 데이터를 분석하여 공식 [축제 안전관제 사후 종합 평가 보고서]를 작성해 주세요.\n\n");

            prompt.append("### [1. 관제 이력 수집 데이터 총 요약]\n");
            prompt.append("- 총 발생/감지 건수: ").append(list.size()).append("건\n\n");

            prompt.append("### [2. 세부 위험 감지 및 조치 상세 이력 목록]\n");
            for (SituationDTO situ : list) {
                prompt.append("- [이력No: ").append(situ.getSituNo()).append("] ")
                      .append("위험유형: ").append(situ.getDngrType() != null ? situ.getDngrType() : "미지정").append(" | ")
                      .append("감지유형: ").append(situ.getSituType() != null ? situ.getSituType() : "일반").append(" | ")
                      .append("위험단계: ").append(situ.getDngrLevel() != null ? situ.getDngrLevel() : "보통").append(" | ")
                      .append("조치상태: ").append(situ.getSituStatus() != null ? situ.getSituStatus() : "미결").append(" | ")
                      .append("감지내용: ").append(situ.getSituContent() != null ? situ.getSituContent() : "내용없음").append(" | ")
                      .append("조치내용: ").append(situ.getWorkContent() != null ? situ.getWorkContent() : "조치내역 없음")
                      .append("\n");
            }

            prompt.append("\n### [작성 양식 및 지침]\n");
            prompt.append("1. **축제 관제 및 현장 조치 종합 총평**: 관제 시스템 운영 성과, 전반적인 위험 발생 양상 및 대응 총평\n");
            prompt.append("2. **위험 유형별 & 감지 수단별 정밀 분석**: 인파 밀집, 시설물, 화재, 응급환자 등 주요 위험 요소 발생 원인 및 AI CCTV/드론/요원 순찰의 감지 기여도 분석\n");
            prompt.append("3. **현장 요원 대응 및 관리자 승인 체계 적합성 평가**: 현장 조치 내용의 신속성, 승인/반려 조치 결과의 적절성 평가\n");
            prompt.append("4. **차기 축제 안전관리 개선 및 재발 방지 제언**: 이번 축제 이력을 바탕으로 다음 행사 시 강화해야 할 관제 구역, 인력 배치 및 안전 가이드라인 제시\n");

            // 3. Gemini REST API 요청 JSON 구성
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

            // 4. API 엔드포인트 호출
            String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent";

            URL url = new URL(endpoint);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("x-goog-api-key", apiKey.trim());
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonRequestBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

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
            return "AI 사후 종합 보고서 생성 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
}