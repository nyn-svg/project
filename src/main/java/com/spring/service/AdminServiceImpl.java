package com.spring.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.spring.dto.UserDTO;
import com.spring.mapper.AdminMapper; // 본인 프로젝트 Mapper 경로

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;

    @Override
    public int getTotalAgentCount() {
        return adminMapper.getTotalAgentCount();
    }

    @Override
    public int getOnDutyAgentCount() {
        return adminMapper.getOnDutyAgentCount();
    }

    @Override
    public int getBreakAgentCount() {
        return adminMapper.getBreakAgentCount();
    }

    @Override
    public int getOffDutyAgentCount() {
        return adminMapper.getOffDutyAgentCount();
    }

    @Override
    public List<UserDTO> getAllAgentList() {
        return adminMapper.getAllAgentList();
    }
}