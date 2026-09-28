package com.spring.service;

import com.spring.annotation.AdminLog;
import com.spring.dto.AgentDTO;
import com.spring.dto.UserDTO;

public interface AgentService {
    AgentDTO getAgentInfo(String userId);
    @AdminLog(value = "요원 근무 상태 변경", type = "ACTION")
    boolean changeAgentStatus(String userId, String workStatus);
    
    UserDTO findByUserId(String userId);
}