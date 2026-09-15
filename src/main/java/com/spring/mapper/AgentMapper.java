package com.spring.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.spring.dto.AgentDTO;

@Mapper
public interface AgentMapper {
    AgentDTO findAgentById(String userId);
    int updateAgentStatus(@Param("userId") String userId, @Param("workStatus") String workStatus);
}
