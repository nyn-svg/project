package com.spring.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class SituationDTO {
    private String situNo;      // 이력번호 (PK)
    private String situType;	// 감지유형 (자동감지, 수동감지, 긴급보고)
    private String dngrType;    // 위험유형 (인파위험, 야생동물, 인명사고, 시설고장/파손, 시설점검, 연계필요, 기타)
    private String dngrLevel;   // 위험단계 (관심, 주의, 경계, 심각, 판단불가)
    private String situStatus;  // 조치상태 (감지, 조치, 완료, 미해결, 취소)
    private String situContent; // 감지내용
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date situDate;      // 감지일시 (감지 - 이력 최초 생성)
    private String situImage;   // 감지첨부파일명 (1장)
    
    private String workContent; // 조치내용
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startDate;     // 시작일시 (조치 - 안전요원이 수락한 일시)
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endDate;		// 종료일시 (완료 - 완료, 미해결, 취소 상태로 변경된 일시, 이후로 수정 불가능)
    private String workImage;   // 조치첨부파일명 (1장)
    
    private String zoneName;    // 구역명 (다른 테이블과 참조 금지)
    private String droneId;		// 드론아이디 (자동 등록 시, 발견인 란에 드론아이디가 표시, FK DRONES 테이블 참조)
    private String finder;		// 발견인 (수동감지-관제사 / 긴급보고-안전요원, FK USERS 테이블 참조)
    private String worker;      // 조치인 (FK USERS 테이블 참조)

}