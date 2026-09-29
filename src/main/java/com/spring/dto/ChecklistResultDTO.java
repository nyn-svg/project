package com.spring.dto;

import lombok.Data;

@Data
public class ChecklistResultDTO {
    private Long resultId;
    private Long itemId;
    private String targetType;   // AGENT, CONTROL
    private String category;     // 안전 장비, 구역 점검, 장비 점검 등
    private String itemTitle;    // 항목 제목
    private String question;     // 세부 점검 내용
    private String userId;       // 점검자 ID (agent01, control 등)
    private String checkStatus;  // 정상, 주의, 경고 등
    private String remark;       // 비고/특이사항
    private String checkDate;    // 점검일자
}