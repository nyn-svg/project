package com.spring.dto;

import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChecklistHistoryDTO {
    
    // 요약 목록용 필드
    private String userId;           // 제출자 ID
    private String targetType;       // AGENT(안전요원) / CONTROL(관제사)
    private Date checkDate;          // 제출 일시
    private String checkDateStr;     // YYYY-MM-DD HH24:MI:SS 문자열 포맷
    private Integer totalCount;      // 총 문항 수
    private Integer normalCount;     // 정상 건수
    private Integer cautionCount;    // 주의 건수
    private Integer dangerCount;     // 위험 건수
    
    // 상세 모달용 필드 (문항별 결과)
    private Long resultId;           // 결과 PK
    private Long itemId;             // 문항 PK
    private String category;         // 카테고리
    private String itemTitle;        // 항목명
    private String question;         // 질문 내용
    private String checkStatus;      // 정상 / 주의 / 위험 / 해당없음
    private String remark;           // 비고
}