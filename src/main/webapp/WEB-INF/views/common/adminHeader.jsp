<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 관리자 전용 상단 헤더 -->
<header class="app-header admin-header">
    <a href="${pageContext.request.contextPath}/admin/main" class="header-logo header-link">
        <div class="logo-icon">🛡️</div>
        <span>2TEAM <span class="admin-badge">ADMIN</span></span>
    </a>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/admin/main" class="nav-link header-link">홈</a>
        <a href="${pageContext.request.contextPath}/admin/safetyCheck" class="nav-link header-link">안전점검</a>
        <a href="${pageContext.request.contextPath}/admin/areaManagement" class="nav-link header-link">관제구역 관리</a>
        <a href="${pageContext.request.contextPath}/admin/userManagement" class="nav-link header-link">사용자 관리</a>
    </nav>
    
    <!-- 로그아웃 버튼 -->
    <button type="button" class="btn-logout" onclick="location.href='${pageContext.request.contextPath}/logout'">
    	로그아웃
    </button>
</header>