package com.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.annotation.AdminLog; // 🎯 1. import 추가
import com.spring.dto.AgentDTO;
import com.spring.dto.UserDTO;
import com.spring.mapper.AgentMapper;

@Service
public class AgentServiceImpl implements AgentService {

    @Autowired
    private AgentMapper agentMapper;

    @Override
    public AgentDTO getAgentInfo(String userId) {
        return agentMapper.findAgentById(userId);
    }

    // 🎯 2. DB 수정이 일어나는 메서드 위에 어노테이션 추가
    @AdminLog(value = "요원 근무 상태 변경", type = "ACTION")
    @Override
    public boolean changeAgentStatus(String userId, String workStatus) {
        return agentMapper.updateAgentStatus(userId, workStatus) > 0;
    }
    
    @Override
    public UserDTO findByUserId(String userId) {
        try {
            com.spring.dto.UserDTO dto = new com.spring.dto.UserDTO();
            dto.setUserId(userId);
            
            com.spring.dto.AgentDTO agentInfo = agentMapper.findAgentById(userId);
            if(agentInfo != null) {
                dto.setWorkArea(agentInfo.getWorkArea());
            } else {
                dto.setWorkArea("A");
            }
            return dto;
        } catch(Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}