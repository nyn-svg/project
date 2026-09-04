package com.spring.dto;

import java.util.Date;
import lombok.Data;

@Data
public class SituationDTO {
    private String situNo;      // 이력번호 (PK)
    private String dngrType;    // 위험유형
    private String situStatus;  // 처리상태
    private String situContent; // 내용
    private Double situLat;     // 위도
    private Double situLon;     // 경도
    private Date situDate;      // 작성일시
    private String zoneName;    // 구역명
    private String userId;      // 작성자 아이디
    private String situImage;   // 첨부 사진 파일명 (추가됨)
}