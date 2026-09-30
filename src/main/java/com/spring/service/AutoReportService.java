package com.spring.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.controller.ControlController;
import com.spring.controller.SituationController;
import com.spring.dto.SituationDTO;

@Service
public class AutoReportService implements DisposableBean {

    @Autowired
    private SituationService situationService;

    @Autowired
    private SseService sseService;

    // 5개 스레드를 가지는 스케줄러 생성 (동시 감지 방지)
    private final ScheduledExecutorService autoReportScheduler = Executors.newScheduledThreadPool(5);

    // 10초 후 조치상태 검사 및 자동신고 실행 예약
    public void scheduleAutoReport(SituationDTO originalSitu) {
    	// 10초 대기 타이머를 걸기 전에 '신고 대상 유형'인지 먼저 검증
    	String type = originalSitu.getDngrType();
        boolean isFireTarget = "인명사고".equals(type) || "야생동물".equals(type); // 소방서 연계 대상 (인명사고, 야생동물)
        boolean isPoliceTarget = "인파위험".equals(type) || "연계필요".equals(type); // 경찰서 연계 대상 (인파위험, 연계필요)

        if (!isFireTarget && !isPoliceTarget) {
            return; // 소방서 및 경찰서 신고 대상이 아니면 타이머 등록 없이 바로 종료
        }
    	
        autoReportScheduler.schedule(() -> {
            try {
                // 10초 후 DB에서 최신 조치 상태 재조회
                SituationDTO currentSitu = situationService.getSituationBySituNo(originalSitu.getSituNo());

                // 여전히 '감지' 상태인 경우 자동신고 로직 수행
                if (currentSitu != null && "감지".equals(currentSitu.getSituStatus())) {
                    SituationDTO reportSitu = new SituationDTO();
                    reportSitu.setSituType("긴급보고");
                    reportSitu.setDngrType(currentSitu.getDngrType());
                    reportSitu.setDngrLevel(currentSitu.getDngrLevel());
                    reportSitu.setSituStatus("감지");
                    reportSitu.setSituImage(currentSitu.getSituImage());
                    reportSitu.setZoneName(currentSitu.getZoneName());
                    reportSitu.setDroneId(currentSitu.getDroneId());
                    reportSitu.setFinder(currentSitu.getFinder());

                    String addedMsg = "";
                    String reportTitle = "[ 관할 기관 신고 완료 ]";

                    // 메시지 및 타이틀 구성
                    if (isFireTarget) {
                        addedMsg = "조치되지 않은 '심각' 단계 감지 이력이 있어 관할 소방서 및 119 구조대에 감지 내용을 전달했습니다.\n유선전화로 최종 신고 여부를 확인해 주시기 바랍니다.";
                        reportTitle = "[ 소방서 신고 완료 ] ";
                    } else if (isPoliceTarget) {
                        addedMsg = "조치되지 않은 '심각' 단계 감지 이력이 있어 관할 파출소로 감지 내용을 전달했습니다.\n유선전화로 최종 신고 여부를 확인해 주시기 바랍니다.";
                        reportTitle = "[ 경찰서 신고 완료 ] ";
                    }

                    reportSitu.setSituContent(currentSitu.getSituContent() + "\n\n" + reportTitle + "\n" + addedMsg + "\n\n참고 이력 번호 (NO): " + currentSitu.getSituNo());
                    
                    addedMsg += ("\n\n참고 이력 번호 (NO): " + currentSitu.getSituNo());

                    // 1. DB에 긴급보고 등록
                    if (situationService.registerSituation(reportSitu)) {
                        // 2. 메모리 공유 리스트에 저장 (stream.jsp 자동신고 카드용)
                        Map<String, Object> autoReportLog = new HashMap<>();
                        autoReportLog.put("id", currentSitu.getSituNo());
                        autoReportLog.put("title", reportTitle);
                        autoReportLog.put("date", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                        autoReportLog.put("msg", addedMsg);

                        ControlController.getAutoReportList().add(0, autoReportLog);

                        // 3. SSE 알림 전송
                        SituationController.clearSituationCache();
                        sseService.sendEvent("EMERGENCY_SUBMITTED", reportSitu.getSituNo());
                        sseService.sendEvent("AUTO_REPORT_CREATED", autoReportLog);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 30, TimeUnit.SECONDS);
    }
    
    // 서버 종료 시 Spring이 자동으로 호출해 주는 destroy() 메서드 (스레드 풀 종결)
    @Override
    public void destroy() throws Exception {
        if (autoReportScheduler != null && !autoReportScheduler.isShutdown()) {
            autoReportScheduler.shutdown();
        }
    }
}