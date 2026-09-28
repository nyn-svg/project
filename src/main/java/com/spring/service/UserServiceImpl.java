package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.annotation.AdminLog; // 🎯 import 추가
import com.spring.dto.UserDTO;
import com.spring.mapper.UserMapper;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public List<UserDTO> getAgentList() {
        return userMapper.findAllUsers();
    }

    // 🎯 1. 신규 요원 등록
    @AdminLog(value = "요원 신규 등록", type = "ACTION")
    @Override
    @Transactional
    public boolean registerAgent(UserDTO user) {
        user.setUserPw(passwordEncoder.encode(user.getUserPw()));
        
        int userResult = userMapper.insertUser(user);
        
        String roleName = user.getRoleName();
        if (roleName == null || roleName.trim().isEmpty()) {
            roleName = "ROLE_AGENT";
        }
        
        int roleResult = userMapper.insertUserRole(user.getUserId(), roleName);
        
        return userResult > 0 && roleResult > 0;
    }

    // 🎯 2. 요원 정보 수정
    @AdminLog(value = "요원 정보 수정", type = "INFO")
    @Override
    public boolean modifyAgent(UserDTO user) {
        if (user.getUserPw() != null && !user.getUserPw().isEmpty()) {
            user.setUserPw(passwordEncoder.encode(user.getUserPw()));
        }
        return userMapper.updateUser(user) > 0;
    }
    
    // 🎯 3. 담당 구역 변경
    @AdminLog(value = "요원 담당 구역 변경", type = "INFO")
    @Override
    public boolean updateWorkArea(String userId, String workArea) {
        UserDTO user = new UserDTO();
        user.setUserId(userId);
        user.setWorkArea(workArea);
        return userMapper.updateUser(user) > 0;
    }
}