package com.spring.dto;

import java.util.Date;
import lombok.Data;

@Data
public class SituationDTO {
    private String situNo;      // 이력번호 (PK)
    // 발견인 (드론 or 관제사)
    private String situType;	// 감지유형 (자동감지, 수동감지, 긴급보고)
    private String dngrType;    // 위험유형
    private String dngrLevel;   // 위험단계 (관심, 주의, 경계, 심각, 판단불가)
    private String situStatus;  // 조치상태 (대기, 조치, 완료, 미해결, 취소)
    private String situContent; // 발생내용
    private Double situLat;     // 위도 (사용x)
    private Double situLon;     // 경도 (사용x)
    private Date situDate;      // 작성일시 (감지 - 이력 최초 생성)
    private String situImage;   // 첨부 사진 파일명 (1장)
    
    private String workContent; // 조치내용
    private Date checkDate;		// 확인일시 (사용x)
    private Date startDate;     // 시작일시 (조치 - 안전요원이 수락한 일시)
    private Date endDate;		// 종료일시 (완료 - 완료, 미해결, 취소 상태로 변경된 일시, 이후로 수정 불가능)
    // private String workImage;   // 첨부 사진 파일명 (1장)
    private String zoneName;    // 구역명
    private String userId;      // 조치인
}