<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 상단 헤더 -->
<header class="app-header">
    <a href="${pageContext.request.contextPath}/" class="header-logo header-link">
        <div class="logo-icon">🛡️</div>
        <span>2TEAM</span>
    </a>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/" class="nav-link header-link">홈</a>
        <a href="${pageContext.request.contextPath}/detection" class="nav-link header-link">감지 이력</a>
		<a href="${pageContext.request.contextPath}/realtime" class="nav-link header-link">실시간 감지</a>
    	<a href="${pageContext.request.contextPath}/actionLog" class="nav-link header-link">조치록</a>
    </nav>
    
    <!-- 로그아웃 버튼 -->
    <button type="button" class="btn-logout" onclick="location.href='${pageContext.request.contextPath}/logout'">
    	로그아웃
    </button>
</header>