package com.spring.mapper;

import java.util.List;
import java.util.Map;

import com.spring.dto.SituationDTO;

public interface SituationMapper {
	
	// 통합 목록 조회 (탭 구분, 검색, 페이징)
    List<SituationDTO> selectSituationList(Map<String, Object> paramMap);
    
    // 페이징 계산용 총 개수 조회
    int selectSituationCount(Map<String, Object> paramMap);
    
    // 이력번호로 감지조치이력 조회
	SituationDTO findBySituNo(String situNo);
	
	// 전체 감지조치이력 목록 조회
	List<SituationDTO> findAllSituations();
	
	// 감지이력 목록 조회
	List<SituationDTO> findSituations();
	
	// 조치이력 목록 조회
	List<SituationDTO> findStartSituations();
	
	// 종료이력 목록 조회
	List<SituationDTO> findEndSituations();
	
	// 감지 이력 등록
    int insertSituation(SituationDTO situation);
    
    // 조치 시작일시 기록
    int startSituation(String situNo);
    
    // 조치 종료일시 기록
    int endSituation(SituationDTO situation);
    
    // 감지 이력 수정 또는 조치 내용 입력
    int updateSituation(SituationDTO situation);
    
    // 감지조치이력 삭제
    int deleteSituation(String situNo);
    
    // 오감지 처리 (가장 최근 자동감지 1건 조회)
    String findLatestAutoDetectionNo(String droneId);
    
    // 전체 감지조치이력 수
    int getTotalSituationCount();
    
    // 감지이력 수
    int getSituationCount();
    
    // 조치이력 수
    int getStartSituationCount();
    
    // 종료이력 수
    int getEndSituationCount();

    // 1. 현장 조치 목록 조회 (XML의 id="getFieldActionList"와 매핑)
    List<SituationDTO> getFieldActionList(String statusType);

    // 2. 현장 조치 승인/반려 처리 (XML의 id="processFieldAction"과 매핑)
    int processFieldAction(Map<String, Object> paramMap);
    
    // [안전요원 모바일 조치보고 리스트 - 무한 스크롤 페이징 기능 추가]
    List<SituationDTO> getTaskListPaged(Map<String, Object> paramMap);
    int getTaskListCount(Map<String, Object> paramMap);
    
    Map<String, Object> getDangerDashboardSummary();
    
    Map<String, Object> getInstructionDashboardSummary();
    
    Map<String, Object> getReportDashboardSummary();
}