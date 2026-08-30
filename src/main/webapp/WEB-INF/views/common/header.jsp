<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 상단 헤더 -->
<header class="app-header">
    <a href="${pageContext.request.contextPath}/" class="header-logo header-link">
        <div class="logo-icon">🛡️</div>
        <span>2TEAM</span>
    </a>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/" class="nav-link header-link">홈</a>
        <a href="${pageContext.request.contextPath}/detection" class="nav-link header-link">감지 조회</a>
        <a href="${pageContext.request.contextPath}/history" class="nav-link header-link">위험 이력</a>
    </nav>
</header>