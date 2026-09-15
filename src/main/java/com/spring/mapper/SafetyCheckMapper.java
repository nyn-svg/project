package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.spring.dto.SafetyCheckDetailDTO;
import com.spring.dto.SafetyCheckMasterDTO;

@Mapper
public interface SafetyCheckMapper {

    // 1. 마스터 정보(상단 헤더) 저장
    void insertMaster(SafetyCheckMasterDTO masterDTO);

    // 2. 상세 항목(체크리스트 각 줄) 저장
    void insertDetail(SafetyCheckDetailDTO detailDTO);
    
    /**
     * 가장 최근 저장된 마스터 1건 조회
     */
    SafetyCheckMasterDTO selectLatestMaster();

    /**
     * 특정 checkId에 해당하는 상세 항목 목록 조회
     */
    List<SafetyCheckDetailDTO> selectDetailsByCheckId(Long checkId);
}