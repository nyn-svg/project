package com.spring.mapper;

import org.apache.ibatis.annotations.Mapper;
import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.dto.SafetyCheckDetailDTO;

@Mapper
public interface SafetyCheckMapper {

    // 1. 마스터 정보(상단 헤더) 저장
    void insertMaster(SafetyCheckMasterDTO masterDTO);

    // 2. 상세 항목(체크리스트 각 줄) 저장
    void insertDetail(SafetyCheckDetailDTO detailDTO);
}