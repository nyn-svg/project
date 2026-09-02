package com.spring.security;

import java.io.IOException;
import java.util.Set;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
    	
    	// 기존 저장된 요청(로그인 페이지로 튕기기 전 URL) 삭제
    	RequestCache requestCache = new HttpSessionRequestCache();
    	requestCache.removeRequest(request, response);
        
        // 로그인한 사용자의 권한 목록을 가져옵니다.
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        // 권한에 따라 이동할 URL을 다르게 지정해 줍니다.
        if (roles.contains("ROLE_ADMIN")) {
            // 관리자 -> /admin/main
            response.sendRedirect(request.getContextPath() + "/admin/main");
        } else if (roles.contains("ROLE_CONTROL")) {
            // 관제사 -> / (관제사 메인)
            response.sendRedirect(request.getContextPath() + "/");
        } else if (roles.contains("ROLE_AGENT")) {
            // 안전요원 -> /agent/main
            response.sendRedirect(request.getContextPath() + "/agent/main");
        } else {
            // 기타 기본값 -> /guide/main
            response.sendRedirect(request.getContextPath() + "/guide/main");
        }
    }
}