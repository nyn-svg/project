package com.spring.service;

import java.util.List;

import com.spring.dto.SituationDTO;

public interface SituationService {

	// 이력번호로 감지조치이력 조회
	SituationDTO getSituationBySituNo(String situNo);

	// 전체 감지조치이력 목록 조회
	List<SituationDTO> getTotalSituationList();

	// 감지이력 목록 조회
	List<SituationDTO> getSituationList();

	// 조치이력 목록 조회
	List<SituationDTO> getStartSituationList();

	// 종료이력 목록 조회
	List<SituationDTO> getEndSituationList();

	// 감지 이력 등록
	boolean registerSituation(SituationDTO situation);
	
	// 조치 시작일시 기록
	boolean setStart(String situNo);
	
	// 조치 종료일시 기록
	boolean setEnd(String situNo);
	
	// 감지 이력 수정 또는 조치 내용 입력
	boolean modifySituation(SituationDTO situation);

	// 전체 감지조치이력 수
	int getTotalSituationCount();

	// 감지이력 수
	int getSituationCount();

	// 조치이력 수
	int getStartSituationCount();

	// 종료이력 수
	int getEndSituationCount();
	
	// 현장 조치 목록 조회 (미결/완료이력 구분)
	List<SituationDTO> getFieldActionList(String statusType);

	// 현장 조치 승인/반려 처리
	boolean processFieldAction(String actionId, String status, String adminComment, String adminId);

}