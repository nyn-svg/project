package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.spring.dto.ChecklistHistoryDTO;
import com.spring.dto.ChecklistItemDTO;
import com.spring.dto.SafetyCheckDetailDTO;

@Mapper
public interface ChecklistMapper {

    // 1. 대상별(AGENT / CONTROL) 문항 전체 목록 조회
    List<ChecklistItemDTO> selectItemsByTarget(String targetType);

    // 2. 신규 체크리스트 문항 등록
    int insertChecklistItem(ChecklistItemDTO dto);

    // 3. 체크리스트 문항 수정
    int updateChecklistItem(ChecklistItemDTO dto);

    // 4. 체크리스트 문항 삭제
    int deleteChecklistItem(Long itemId);
    
    // 5. 사이드바용 제출 이력 요약 목록 조회
    List<ChecklistHistoryDTO> selectChecklistHistoryList();

    // 6. 모달용 상세 제출 결과 조회 (USER_ID + CHECK_DATE_STR 기준)
    List<ChecklistHistoryDTO> selectChecklistHistoryDetail(@Param("userId") String userId, @Param("checkDateStr") String checkDateStr);
    
    // 7. 사전 점검 제출 결과 DB 저장
    int insertSafetyCheckDetail(@Param("inspector") String inspector, @Param("detail") SafetyCheckDetailDTO detail);
}