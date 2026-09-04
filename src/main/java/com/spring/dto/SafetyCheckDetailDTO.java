package com.spring.dto;

import lombok.Data;

@Data
public class SafetyCheckDetailDTO {
    private Long detailId;
    private Long checkId;
    private String itemNo;     // 항목 번호 (item_1, item_2...)
    private String statusCode; // NORMAL, WARN, DANGER, NONE
    private String remark;     // 비고
}