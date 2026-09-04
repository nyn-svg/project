package com.spring.mapper;

import com.spring.dto.SituationDTO;

public interface SituationMapper {
    
    // 신규 상황 보고 등록
    int insertSituation(SituationDTO situation);
    
}