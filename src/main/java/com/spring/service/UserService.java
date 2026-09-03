package com.spring.service;

import java.util.List;
import com.spring.dto.UserDTO;

public interface UserService {
    
    // 전체 목록 조회
    List<UserDTO> getAgentList();
    
    // 신규 안전요원 등록
    boolean registerAgent(UserDTO user);
    
    // 안전요원 정보 수정
    boolean modifyAgent(UserDTO user);
}