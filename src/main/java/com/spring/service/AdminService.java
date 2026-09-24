package com.spring.service;

import java.util.List;
import com.spring.dto.UserDTO;

public interface AdminService {
	// 기존 메서드
	int getTotalAgentCount();
	int getOnDutyAgentCount();
	int getBreakAgentCount();
	int getOffDutyAgentCount();
	List<UserDTO> getAllAgentList();

	// 🎯 [신규 추가] KPI 상단 요약 데이터 조회 메서드
	int getUncheckedRiskCount();
	int getUnreadEmergencyCount();  // 미확인 긴급보고 건수
	int getFlyingDroneCount();      // 비행중 드론 대수
}