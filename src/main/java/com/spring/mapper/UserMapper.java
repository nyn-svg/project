package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.dto.UserDTO;

public interface UserMapper {
    
    // 아이디로 사용자 정보 조회
    UserDTO findByUserId(String userId);
    
    // 아이디로 해당 사용자의 권한 목록 조회
    List<String> findRolesByUserId(String userId);
    
    // 1. 전체 목록 조회
    List<UserDTO> findAllUsers();

    // 2. 신규 사용자(안전요원) 등록
    int insertUser(UserDTO user);

    // 3. 사용자(안전요원) 정보 수정
    int updateUser(UserDTO user);
    
    // 4. 신규 사용자 기본 권한 등록 
    int insertUserRole(@Param("userId") String userId, @Param("roleName") String roleName);
    
}