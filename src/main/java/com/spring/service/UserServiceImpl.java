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
    @Transactional
    public boolean registerAgent(UserDTO user) {
        // 비밀번호 암호화
        user.setUserPw(passwordEncoder.encode(user.getUserPw()));
        
        // 1) USERS 테이블에 유저 정보 저장
        int userResult = userMapper.insertUser(user);
        
        // 💡 만약 화면에서 전달받은 roleName이 없거나 비어있을 경우를 대비해 기본값 설정
        String roleName = user.getRoleName();
        if (roleName == null || roleName.trim().isEmpty()) {
            roleName = "ROLE_AGENT";
        }
        
        // 2) USER_ROLES 테이블에 동적 권한(ROLE_AGENT 또는 ROLE_CONTROL) 추가
        // 💡 파라미터 2개(userId, roleName)를 넘겨주도록 수정하여 에러 해결!
        int roleResult = userMapper.insertUserRole(user.getUserId(), roleName);
        
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
    
    @Override
    public boolean updateWorkArea(String userId, String workArea) {
        UserDTO user = new UserDTO();
        user.setUserId(userId);
        user.setWorkArea(workArea);
        return userMapper.updateUser(user) > 0;
    }
}