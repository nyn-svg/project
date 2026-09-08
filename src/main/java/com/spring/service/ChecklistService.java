package com.spring.service;

import java.util.List;

import com.spring.dto.ChecklistHistoryDTO;
import com.spring.dto.ChecklistItemDTO;

public interface ChecklistService {

    // 1. 대상별(AGENT / CONTROL) 문항 전체 목록 조회
    List<ChecklistItemDTO> getItemsByTarget(String targetType);

    // 2. 신규 체크리스트 문항 등록
    boolean registerChecklistItem(ChecklistItemDTO dto);

    // 3. 체크리스트 문항 수정
    boolean modifyChecklistItem(ChecklistItemDTO dto);

    // 4. 체크리스트 문항 삭제
    boolean removeChecklistItem(Long itemId);
    
 // 5. 사이드바용 제출 이력 요약 목록 조회
    List<ChecklistHistoryDTO> getChecklistHistoryList();

    // 6. 모달용 상세 제출 결과 조회
    List<ChecklistHistoryDTO> getChecklistHistoryDetail(String userId, String checkDateStr);
}