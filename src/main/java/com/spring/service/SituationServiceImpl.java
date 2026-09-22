package com.spring.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import com.spring.dto.SituationDTO;
import com.spring.mapper.SituationMapper;

@Service
public class SituationServiceImpl implements SituationService {

    @Autowired
    private SituationMapper situationMapper;

    @Autowired
    private SseService sseService;

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
        // 1. DB에 상황 보고 저장
        int result = situationMapper.insertSituation(situation);
        
        // 2. DB 저장 성공 시
        if (result > 0) {
            final String type = situation.getSituType();

            // 💡 [핵심 해결] DB 트랜잭션 커밋이 '완전히 끝난 직후'에만 SSE 발송 실행
            if (TransactionSynchronizationManager.isSynchronizationActive()) {
                TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                    @Override
                    public void afterCommit() {
                        // 💡 [핵심 해결] Java 문자열 비교는 .equals() 사용
                        if ("긴급보고".equals(type)) {
                            // 이벤트명: "situation-report"
                            sseService.sendEvent("situation-report", situation);
                        } else { 
                            // 자동감지, 수동감지 -> 이벤트명: "situation-alert"
                            sseService.sendEvent("situation-alert", situation);
                        }
                    }
                });
            } else {
                // 트랜잭션 동기화가 비활성화 상태일 경우 예외 대비 동기 처리
                if ("긴급보고".equals(type)) {
                    sseService.sendEvent("situation-report", situation);
                } else {
                    sseService.sendEvent("situation-alert", situation);
                }
            }
        }
        
        return result > 0;
    }

    @Override
    public boolean setStart(String situNo) {
        return situationMapper.startSituation(situNo) > 0;
    }

    @Override
    public boolean setEnd(String situNo) {
        return situationMapper.endSituation(situNo) > 0;
    }

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

    @Override
    public boolean processFieldAction(String actionId, String status, String adminComment, String adminId) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("actionId", actionId);
        paramMap.put("status", status);
        paramMap.put("adminComment", adminComment);
        paramMap.put("adminId", adminId);

        int result = situationMapper.processFieldAction(paramMap);
        return result > 0;
    }
    
    @Override
    public List<SituationDTO> getTaskListPaged(Map<String, Object> paramMap) {
        return situationMapper.getTaskListPaged(paramMap);
    }

    @Override
    public int getTaskListCount(Map<String, Object> paramMap) {
        return situationMapper.getTaskListCount(paramMap);
    }
}