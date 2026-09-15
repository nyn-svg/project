package com.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

    @Override
    public boolean changeAgentStatus(String userId, String workStatus) {
        return agentMapper.updateAgentStatus(userId, workStatus) > 0;
    }
    
    @Override
    public UserDTO findByUserId(String userId) {
        try {
            com.spring.dto.UserDTO dto = new com.spring.dto.UserDTO();
            dto.setUserId(userId);
            
            // 로그인한 요원의 상세 정보(AgentDTO)에서 구역명을 가져와 UserDTO에 안전하게 채워줍니다.
            com.spring.dto.AgentDTO agentInfo = agentMapper.findAgentById(userId);
            if(agentInfo != null) {
                dto.setWorkArea(agentInfo.getWorkArea());
            } else {
                dto.setWorkArea("A"); // 방어용 기본값
            }
            return dto;
        } catch(Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
