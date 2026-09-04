package com.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dto.SituationDTO;
import com.spring.mapper.SituationMapper;

@Service
public class SituationServiceImpl implements SituationService {

    @Autowired
    private SituationMapper situationMapper;

    @Autowired
    private SseService sseService; // 공유해주신 SseService 주입

    @Override
    @Transactional
    public boolean registerSituation(SituationDTO situation) {
        // 1. DB에 상황 보고 저장
        int result = situationMapper.insertSituation(situation);
        
        // 2. DB 저장 성공 시 접속 중인 모든 관제사 화면으로 실시간 SSE 이벤트 발송
        if (result > 0) {
            // 이벤트명: "situation-report", 데이터: 저장된 SituationDTO 객체
            sseService.sendEvent("situation-report", situation);
        }
        
        return result > 0;
    }
}