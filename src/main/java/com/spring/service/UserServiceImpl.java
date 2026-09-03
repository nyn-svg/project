package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // 👈 1. 추가

import com.spring.dto.UserDTO;
import com.spring.mapper.UserMapper;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    // Spring Security 암호화 객체 주입
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public List<UserDTO> getAgentList() {
        return userMapper.findAllUsers();
    }

    @Override
    @Transactional // 👈 2. 두 작업 중 하나라도 실패하면 자동 Rollback
    public boolean registerAgent(UserDTO user) {
        // 비밀번호 암호화
        user.setUserPw(passwordEncoder.encode(user.getUserPw()));
        
        // 1) USERS 테이블에 유저 정보 저장
        int userResult = userMapper.insertUser(user);
        
        // 2) USER_ROLES 테이블에 ROLE_AGENT 권한 추가 (👈 3. 추가)
        int roleResult = userMapper.insertUserRole(user.getUserId());
        
        // 둘 다 성공(>0) 해야 true 반환
        return userResult > 0 && roleResult > 0;
    }

    @Override
    public boolean modifyAgent(UserDTO user) {
        // 비밀번호를 수정한 경우에만 암호화 적용
        if (user.getUserPw() != null && !user.getUserPw().isEmpty()) {
            user.setUserPw(passwordEncoder.encode(user.getUserPw()));
        }
        return userMapper.updateUser(user) > 0;
    }
}