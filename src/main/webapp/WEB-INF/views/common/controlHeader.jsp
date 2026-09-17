<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 상단 헤더 -->
<header class="app-header">
    <a href="${pageContext.request.contextPath}/" class="header-logo header-link">
        <div class="logo-icon"><i class="fa-solid fa-display"></i></div>
        <span>2TEAM</span>
    </a>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/control/main" class="nav-link header-link">홈</a>
        <a href="${pageContext.request.contextPath}/control/realtime" class="nav-link header-link">실시간 관제</a>
        <a href="${pageContext.request.contextPath}/detection" class="nav-link header-link">위험 감지 관리</a>
    	<a href="${pageContext.request.contextPath}/actionLog" class="nav-link header-link">전자문서</a>
    </nav>
    
</header>