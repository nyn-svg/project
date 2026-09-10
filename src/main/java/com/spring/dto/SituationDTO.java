package com.spring.dto;

import java.util.Date;
import lombok.Data;

@Data
public class SituationDTO {
    private String situNo;      // 이력번호 (PK)
    private String situType;	// 감지유형 (자동감지, 수동감지, 상황보고, 긴급보고)
    private String dngrType;    // 위험유형
    private String dngrLevel;   // 위험단계 (관심, 주의, 경계, 심각, 판단불가)
    private String situStatus;  // 조치상태 (대기, 확인, 조치, 완료, 미해결, 취소)
    private String situContent; // 발생내용
    private Double situLat;     // 위도
    private Double situLon;     // 경도
    private Date situDate;      // 작성일시
    private String workContent; // 조치내용
    private Date startDate;     // 시작일시
    private Date endDate;		// 종료일시
    private String zoneName;    // 구역명
    private String userId;      // 작성자 아이디
    private String situImage;   // 첨부 사진 파일명
    
    // 투입인원?
}