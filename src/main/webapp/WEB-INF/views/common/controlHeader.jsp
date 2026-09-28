<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 상단 헤더 -->
<header class="app-header">
    <a href="${pageContext.request.contextPath}/" class="header-logo header-link">
        <div class="logo-icon"><i class="fa-solid fa-display"></i></div>
        <span>2TEAM</span>
    </a>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/control/realtime" class="nav-link header-link">실시간 관제</a>
        <a href="${pageContext.request.contextPath}/detection" class="nav-link header-link">위험 감지 관리</a>
    </nav>
    
    <!-- 기상 위젯 추가 (weatherWidget.jsp, 절대 경로 지정) -->
    <div class="header-weather-area">
        <jsp:include page="/WEB-INF/views/common/weatherWidget.jsp" />
    </div>
</header>