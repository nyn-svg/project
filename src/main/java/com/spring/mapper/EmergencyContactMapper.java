package com.spring.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.spring.dto.EmergencyContactDTO;

@Mapper
public interface EmergencyContactMapper {

    // 1. 전체 비상연락망 목록 조회
    List<EmergencyContactDTO> selectContactList();

    // 2. 비상연락처 신규 등록
    int insertContact(EmergencyContactDTO dto);

    // 3. 비상연락처 수정
    int updateContact(EmergencyContactDTO dto);

    // 4. 비상연락처 삭제
    int deleteContact(Long contactId);
}