package com.spring.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.annotation.AdminLog; // 🎯 import 추가
import com.spring.dto.EmergencyContactDTO;
import com.spring.mapper.EmergencyContactMapper;

@Service
public class EmergencyContactServiceImpl implements EmergencyContactService {

    @Autowired
    private EmergencyContactMapper emergencyContactMapper;

    @Override
    public List<EmergencyContactDTO> getContactList() {
        return emergencyContactMapper.selectContactList();
    }

    // 🎯 1. 비상연락망 등록
    @AdminLog(value = "비상연락망 등록", type = "ACTION")
    @Override
    public boolean addContact(EmergencyContactDTO dto) {
        return emergencyContactMapper.insertContact(dto) > 0;
    }

    // 🎯 2. 비상연락망 수정
    @AdminLog(value = "비상연락망 수정", type = "INFO")
    @Override
    public boolean modifyContact(EmergencyContactDTO dto) {
        return emergencyContactMapper.updateContact(dto) > 0;
    }

    // 🎯 3. 비상연락망 삭제
    @AdminLog(value = "비상연락망 삭제", type = "WARN")
    @Override
    public boolean removeContact(Long contactId) {
        return emergencyContactMapper.deleteContact(contactId) > 0;
    }
}