<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 관리자 전용 상단 헤더 -->
<header class="app-header admin-header">
    <a href="${pageContext.request.contextPath}/admin/main" class="header-logo header-link">
        <div class="logo-icon"><i class="fa-solid fa-display"></i></div>
		<span>2TEAM <span class="admin-badge">ADMIN</span></span>
    </a>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/admin/main" class="nav-link header-link">홈</a>
        <a href="${pageContext.request.contextPath}/admin/safetyCheck" class="nav-link header-link">안전점검</a>
        <a href="${pageContext.request.contextPath}/admin/areaManagement" class="nav-link header-link">행사장 관리</a>
        <a href="${pageContext.request.contextPath}/admin/userManagement" class="nav-link header-link">사용자 관리</a>
    	<a href="${pageContext.request.contextPath}/admin/checklist" class="nav-link header-link">점검 관리</a>
    	<a href="${pageContext.request.contextPath}/admin/fieldAction" class="nav-link header-link">위험 감지 관리</a>
    </nav>
    
</header>