package com.spring.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.spring.dto.UserDTO;

@Mapper
public interface AdminMapper {
    // 기존 메서드
    int getTotalAgentCount();
    int getOnDutyAgentCount();
    int getBreakAgentCount();
    int getOffDutyAgentCount();
    List<UserDTO> getAllAgentList();

    int getUncheckedRiskCount();     // 미확인 위험 이력
    int getUnreadEmergencyCount(); // 미확인 긴급보고
    int getFlyingDroneCount();     // 비행중 드론
}