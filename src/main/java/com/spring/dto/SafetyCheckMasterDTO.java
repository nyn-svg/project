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
    private List<SafetyCheckDetailDTO> detailList;
}