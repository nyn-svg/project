package com.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dto.SafetyCheckDetailDTO;
import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.mapper.SafetyCheckMapper;

@Service
public class SafetyCheckService {

    @Autowired
    private SafetyCheckMapper safetyCheckMapper;

    /**
     * 안전점검 결과 저장 (마스터 + 상세 항목 트랜잭션 저장)
     */
    @Transactional
    public void saveSafetyCheck(SafetyCheckMasterDTO masterDTO) {
        // 1. 마스터 데이터 저장 (시퀀스 채번되어 masterDTO.checkId에 저장됨)
        safetyCheckMapper.insertMaster(masterDTO);

        // 2. 상세 항목 데이터 반복 저장
        if (masterDTO.getDetailList() != null) {
            for (SafetyCheckDetailDTO detail : masterDTO.getDetailList()) {
                // 마스터에서 생성된 checkId를 상세 항목의 FK로 세팅
                detail.setCheckId(masterDTO.getCheckId());
                safetyCheckMapper.insertDetail(detail);
            }
        }
    }
}