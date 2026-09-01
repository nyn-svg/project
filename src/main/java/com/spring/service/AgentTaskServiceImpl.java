package com.spring.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dto.AgentTaskDTO;
import com.spring.mapper.AgentTaskMapper;

@Service
public class AgentTaskServiceImpl implements AgentTaskService {

    @Autowired
    private AgentTaskMapper agentTaskMapper;

    @Override
    public boolean registerTask(AgentTaskDTO dto) {
        if (dto.getAgentId() == null || dto.getAgentId().trim().isEmpty()) {
            dto.setAgentId("AGENT01");
        }
        
        if (dto.getTaskTitle() == null || dto.getTaskTitle().trim().isEmpty()) {
            dto.setTaskTitle("제목 없음");
        }

        // 내용이 비어있으면 기본값 세팅 추가
        if (dto.getTaskContent() == null || dto.getTaskContent().trim().isEmpty()) {
            dto.setTaskContent("내용 없음");
        }

        if (dto.getActionStatus() == null || dto.getActionStatus().trim().isEmpty()) {
            dto.setActionStatus("PENDING");
        }

        return agentTaskMapper.insertTask(dto) > 0;
    }

    @Override
    public boolean modifyTask(AgentTaskDTO dto) {
        return agentTaskMapper.updateTask(dto) > 0;
    }
    
    @Override
    public List<AgentTaskDTO> getTaskList() {
        return agentTaskMapper.getTaskList();
    }
    
    @Override
    public List<AgentTaskDTO> getTaskListPaged(Map<String, Object> paramMap) {
        return agentTaskMapper.getTaskListPaged(paramMap);
    }	
    
    @Override
    public int getTaskListCount(Map<String, Object> paramMap) {
        return agentTaskMapper.getTaskListCount(paramMap);
    }
}