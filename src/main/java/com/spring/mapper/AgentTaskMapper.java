package com.spring.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.spring.dto.AgentTaskDTO;
import com.spring.dto.UserDTO;

@Mapper
public interface AgentTaskMapper {
    
    // 업무 등록
    int insertTask(AgentTaskDTO dto);
    
    // 업무 수정
    int updateTask(AgentTaskDTO dto);
    
 // 이력 목록 조회 메서드 추가
    List<AgentTaskDTO> getTaskList();
    
    List<AgentTaskDTO> getTaskListPaged(Map<String, Object> paramMap);
    
    int getTaskListCount(Map<String, Object> paramMap);
    
    AgentTaskDTO getTaskById(Long taskId);
    
    UserDTO findByUserId(String userId);
    
    void updateWorkStatus(@Param("userId") String userId, @Param("workStatus") String workStatus);
}