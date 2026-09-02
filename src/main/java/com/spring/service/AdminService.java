package com.spring.service;

import java.util.List;

import com.spring.dto.UserDTO;

public interface AdminService {
	int getTotalAgentCount();
	int getOnDutyAgentCount();
	int getBreakAgentCount();
	int getOffDutyAgentCount();
	List<UserDTO> getAllAgentList();
}
