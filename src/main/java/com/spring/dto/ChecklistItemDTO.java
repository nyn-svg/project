package com.spring.dto;

import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChecklistItemDTO {
    
    private Long itemId;         // ITEM_ID (문항 고유 ID)
    private String targetType;   // TARGET_TYPE (AGENT: 안전요원, CONTROL: 관제사)
    private String category;     // CATEGORY (분야 예: 1. 인파 밀집 및 수송 관리)
    private String itemTitle;    // ITEM_TITLE (항목명 예: 비상 대피로 확보)
    private String question;     // QUESTION (질문 내용)
    private Integer sortOrder;   // SORT_ORDER (정렬 순서)
    private String isUse;        // IS_USE (사용 여부 Y/N)
    private Date regDate;        // REG_DATE (등록일)
}