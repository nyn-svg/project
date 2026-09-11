package com.spring.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.spring.dto.EmergencyContactDTO;
import com.spring.service.EmergencyContactService;

@RestController
@RequestMapping("/api/emergency")
public class EmergencyContactController {

    @Autowired
    private EmergencyContactService emergencyContactService;

    // 1. 비상연락망 목록 조회 API
    @GetMapping("/list")
    public List<EmergencyContactDTO> getContactList() {
        return emergencyContactService.getContactList();
    }

    // 2. 비상연락처 등록 API
    @PostMapping("/add")
    public boolean addContact(@RequestBody EmergencyContactDTO dto) {
        return emergencyContactService.addContact(dto);
    }

    // 3. 비상연락처 수정 API
    @PostMapping("/modify")
    public boolean modifyContact(@RequestBody EmergencyContactDTO dto) {
        return emergencyContactService.modifyContact(dto);
    }

    // 4. 비상연락처 삭제 API
    @PostMapping("/remove")
    public boolean removeContact(@RequestParam("contactId") Long contactId) {
        return emergencyContactService.removeContact(contactId);
    }
}