package com.spring.service;

import java.util.List;
import com.spring.annotation.AdminLog; // 🎯 import 추가
import com.spring.dto.EmergencyContactDTO;

public interface EmergencyContactService {

    List<EmergencyContactDTO> getContactList();

    // 🎯 비상연락망 신규 등록
    @AdminLog(value = "비상연락망 등록", type = "ACTION")
    boolean addContact(EmergencyContactDTO dto);

    // 🎯 비상연락망 정보 수정
    @AdminLog(value = "비상연락망 수정", type = "INFO")
    boolean modifyContact(EmergencyContactDTO dto);

    // 🎯 비상연락망 정보 삭제
    @AdminLog(value = "비상연락망 삭제", type = "WARN")
    boolean removeContact(Long contactId);
}