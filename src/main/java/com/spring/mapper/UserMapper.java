package com.spring.mapper;

import java.util.List;
import com.spring.dto.UserDTO;

public interface UserMapper {
    
    // 아이디로 사용자 정보 조회
    UserDTO findByUserId(String userId);
    
    // 아이디로 해당 사용자의 권한 목록 조회
    List<String> findRolesByUserId(String userId);
}