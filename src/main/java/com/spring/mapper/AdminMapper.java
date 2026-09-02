package com.spring.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.spring.dto.UserDTO;

@Mapper
public interface AdminMapper {
    int getTotalAgentCount();
    int getOnDutyAgentCount();
    int getBreakAgentCount();
    int getOffDutyAgentCount();
    List<UserDTO> getAllAgentList();
}