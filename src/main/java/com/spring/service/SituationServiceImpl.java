package com.spring.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        
        // 2. DB 저장 성공 시 접속 중인 모든 화면으로 실시간 SSE 이벤트 발송
        if (result > 0) {
        	String type = situation.getSituType();
        	if(type == "긴급보고") {
        		// 이벤트명: "situation-report", 데이터: 저장된 SituationDTO 객체
        		sseService.sendEvent("situation-report", situation);
        		
        	} else { // 자동감지, 수동감지
        		// 이벤트명: "situation-alert", 데이터: 저장된 SituationDTO 객체
        		sseService.sendEvent("situation-alert", situation);
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
		// 1. DB에 저장되어 있는 이력 수정/갱신
        int result = situationMapper.updateSituation(situation);
        
        // 2. DB 저장 성공 시 접속 중인 모든 화면으로 실시간 SSE 이벤트 발송
        if (result > 0) {
        	sseService.sendEvent("situation-update", situation);
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
	    // statusType ('PENDING' 또는 'HISTORY') 조건에 맞춰 Mapper/DAO 호출
	    return situationMapper.getFieldActionList(statusType); 
	}

	@Override
	public boolean processFieldAction(String actionId, String status, String adminComment, String adminId) {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("actionId", actionId);
	    paramMap.put("status", status); // 'APPROVE' 또는 'REJECT'
	    paramMap.put("adminComment", adminComment);
	    paramMap.put("adminId", adminId);

	    // DB 처리 성공 건수가 1 이상이면 true 반환
	    int result = situationMapper.processFieldAction(paramMap);
	    return result > 0;
	}
}