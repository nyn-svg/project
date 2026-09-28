package com.spring.service;

import java.util.List;
import com.spring.annotation.AdminLog; // 🎯 import 추가
import com.spring.dto.UserDTO;

public interface UserService {

    List<UserDTO> getAgentList();

    // 🎯 1. 신규 요원 등록
    @AdminLog(value = "요원 신규 등록", type = "ACTION")
    boolean registerAgent(UserDTO user);

    // 🎯 2. 요원 정보 수정
    @AdminLog(value = "요원 정보 수정", type = "INFO")
    boolean modifyAgent(UserDTO user);

    // 🎯 3. 요원 담당 구역 변경
    @AdminLog(value = "요원 담당 구역 변경", type = "INFO")
    boolean updateWorkArea(String userId, String workArea);
}