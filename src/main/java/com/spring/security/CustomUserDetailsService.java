package com.spring.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import com.spring.dto.UserDTO;
import com.spring.mapper.UserMapper;

@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    	
    	System.out.println("=== [로그인 시도 아이디] : " + username);
    	
        // 1. DB에서 사용자 정보 조회
        UserDTO user = userMapper.findByUserId(username);
        
        if (user == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }
        
        System.out.println("=== [DB에서 조회된 비밀번호] : " + user.getUserPw());
        
     // [원인 확인용 추가 코드]
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String newHash = encoder.encode("1234");
        System.out.println("=== [새로 생성된 1234 해시값] : " + newHash);
        System.out.println("=== [생성 직후 검증 결과] : " + encoder.matches("1234", newHash));
        

        // 2. DB에서 해당 사용자의 권한 목록 조회 (ROLE_ADMIN, ROLE_CONTROL, ROLE_AGENT)
        List<String> roles = userMapper.findRolesByUserId(username);
        List<GrantedAuthority> authorities = new ArrayList<>();
        
        if (roles != null) {
            for (String role : roles) {
                authorities.add(new SimpleGrantedAuthority(role));
            }
        }

        // 3. Spring Security에서 사용하는 User 객체로 변환하여 반환
        return new User(
            user.getUserId(),
            user.getUserPw(),
            user.getEnabled() == 1, // 계정 활성화 여부 (1이면 true, 0이면 false)
            true, // 계정 만료 여부 (true: 만료안됨)
            true, // 비밀번호 만료 여부 (true: 만료안됨)
            true, // 계정 잠금 여부 (true: 잠기지않음)
            authorities
        );
    }
}