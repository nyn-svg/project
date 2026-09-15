package com.spring.service;

import com.spring.dto.AgentDTO;
import com.spring.dto.UserDTO;

public interface AgentService {
    AgentDTO getAgentInfo(String userId);
    boolean changeAgentStatus(String userId, String workStatus);
    
    UserDTO findByUserId(String userId);
}