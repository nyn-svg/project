package com.spring.service;

import java.util.List;
import java.util.Map;

import com.spring.dto.AgentTaskDTO;
import com.spring.dto.UserDTO;
public interface AgentTaskService {
    
    // 업무 등록
    boolean registerTask(AgentTaskDTO dto);
    
    // 업무 수정
    boolean modifyTask(AgentTaskDTO dto);
    
 // 이력 목록 조회
    List<AgentTaskDTO> getTaskList();
    
    public List<AgentTaskDTO> getTaskListPaged(Map<String, Object> paramMap);
    
    int getTaskListCount(Map<String, Object> paramMap);
    
    AgentTaskDTO getTaskById(Long taskId); // 또는 int taskId
    
    UserDTO findByUserId(String userId);
    
    void updateWorkStatus(String userId, String workStatus);
}