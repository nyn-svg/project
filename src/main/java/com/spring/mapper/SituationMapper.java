package com.spring.mapper;

import java.util.List;

import com.spring.dto.SituationDTO;

public interface SituationMapper {
    
    // 이력 번호로 감지조치이력 조회
	SituationDTO findBySituNo(String situNo);
	
	// 전체 감지조치이력 목록 조회
	List<SituationDTO> findAllSituations();
	
	// 감지 이력 목록 조회
	List<SituationDTO> findSituations();
	
	// 조치 이력 목록 조회
	List<SituationDTO> findStartSituations();
	
	// 종료 이력 목록 조회
	List<SituationDTO> findEndSituations();
	
	// 감지 이력 등록
    int insertSituation(SituationDTO situation);
    
    // 감지(조치) 확인일시 기록
    int checkSituation(String situNo);
    
    // 조치 시작일시 기록
    int startWorkSituation(String situNo);
    
    // 조치 종료일시 기록
    int endWorkSituation(String situNo);
    
    // 감지 이력 수정 또는 조치 내용 입력
    int updateSituation(SituationDTO situation);
    
    // 전체 감지조치이력 수
    int getTotalSituationCount();
    
    // 감지 이력 수
    int getSituationCount();
    
    // 조치 이력 수
    int getStartSituationCount();
    
    // 종료 이력 수
    int getEndSituationCount();
}