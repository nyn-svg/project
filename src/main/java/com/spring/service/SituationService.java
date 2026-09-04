package com.spring.service;

import com.spring.dto.SituationDTO;

public interface SituationService {
    
    // 상황 보고 등록
    boolean registerSituation(SituationDTO situation);
    
}