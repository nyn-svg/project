package com.spring.service;

import java.util.List;

import com.spring.dto.SituationDTO;

public interface SituationService {

	// 이력 번호로 감지조치이력 조회
	SituationDTO getSituationBySituNo(String situNo);

	// 전체 감지조치이력 목록 조회
	List<SituationDTO> getTotalSituationList();

	// 감지 이력 목록 조회
	List<SituationDTO> getSituationList();

	// 조치 이력 목록 조회
	List<SituationDTO> getStartSituationList();

	// 종료 이력 목록 조회
	List<SituationDTO> getEndSituationList();

	// 감지 이력 등록
	boolean registerSituation(SituationDTO situation);

	// 감지 이력 수정 또는 조치 내용 입력
	boolean modifySituation(SituationDTO situation);

	// 전체 감지조치이력 수
	int getTotalSituationCount();

	// 감지 이력 수
	int getSituationCount();

	// 조치 이력 수
	int getStartSituationCount();

	// 종료 이력 수
	int getEndSituationCount();

}