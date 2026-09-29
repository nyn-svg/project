package com.spring.dto;

import java.util.List;
import lombok.Data;

@Data
public class SafetyCheckMasterDTO {
    private Long checkId;
    private String checkDate;   // 점검일자 (YYYY-MM-DD)
    private String checkRound;  // 점검차수 (1, 2, 3...)
    private String inspector;   // 점검자
    private String regDate;     // 등록일시
    
    // 상세 점검 항목 목록 (1:N 연동)
    private List<SafetyCheckDetailDTO> detailList;		// 1. 관리자 점검 항목 리스트
    private List<ChecklistResultDTO> agentCheckList;   // 2. 안전요원(AGENT) 점검 리스트
    private List<ChecklistResultDTO> controlCheckList; // 3. 관제사(CONTROL) 점검 리스트
}