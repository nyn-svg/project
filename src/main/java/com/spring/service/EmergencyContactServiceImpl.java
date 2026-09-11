package com.spring.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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

    @Override
    public boolean addContact(EmergencyContactDTO dto) {
        return emergencyContactMapper.insertContact(dto) > 0;
    }

    @Override
    public boolean modifyContact(EmergencyContactDTO dto) {
        return emergencyContactMapper.updateContact(dto) > 0;
    }

    @Override
    public boolean removeContact(Long contactId) {
        return emergencyContactMapper.deleteContact(contactId) > 0;
    }
}