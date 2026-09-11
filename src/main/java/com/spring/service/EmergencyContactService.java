package com.spring.service;

import java.util.List;
import com.spring.dto.EmergencyContactDTO;

public interface EmergencyContactService {

    // 1. 전체 비상연락망 목록 조회
    List<EmergencyContactDTO> getContactList();

    // 2. 비상연락처 신규 등록
    boolean addContact(EmergencyContactDTO dto);

    // 3. 비상연락처 수정
    boolean modifyContact(EmergencyContactDTO dto);

    // 4. 비상연락처 삭제
    boolean removeContact(Long contactId);
}