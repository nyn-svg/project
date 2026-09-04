<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Pretendard 고급 웹폰트 CDN 로드 -->
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />

<!-- 1. 우측 60px 고정 퀵바 (관리자 전용 아이콘) -->
<aside class="quick-sidebar">
    <div class="quick-top">
        <button id="toggle-drawer-btn" class="quick-btn toggle-btn" title="사이드바 열기/닫기">
            ❮❮
        </button>
    </div>

    <nav class="quick-nav">
        <!-- 1) 대시보드 요약 -->
        <button class="quick-nav-item active" data-target="panel-admin-dashboard">
            <span class="nav-icon"><i class="fa-solid fa-mask-ventilator"></i></span>
            <span class="nav-label">드론</span>
        </button>
        <!-- 2) 안전요원 관리 -->
        <button class="quick-nav-item" data-target="panel-admin-agents">
            <span class="nav-icon"><i class="fa-solid fa-users-gear"></i></span>
            <span class="nav-label">요원</span>
        </button>
        <!-- 3) 관제 이력/보고서 -->
        <button class="quick-nav-item" data-target="panel-admin-reports">
            <span class="nav-icon"><i class="fa-solid fa-file-invoice"></i></span>
            <span class="nav-label">이력</span>
        </button>
        <!-- 4) 시스템 설정 -->
        <button class="quick-nav-item" data-target="panel-admin-system">
            <span class="nav-icon"><i class="fa-solid fa-sliders"></i></span>
            <span class="nav-label">설정</span>
        </button>
    </nav>
</aside>

<!-- 2. 왼쪽으로 열리는 260px 서브 드로어 패널 -->
<div id="sub-drawer" class="sub-drawer">
    
    <!-- 1) 대시보드 요약 패널 -->
    <div id="panel-admin-dashboard" class="drawer-content active">
        <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
            <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">드론</span>
        </div>
        <div class="drawer-body">
            <div style="padding: 10px 0; color: #a0aec0; font-size: 13px;">
                <p>실시간 모니터링 요약 정보, 클릭시 드론 영상 확인 가능</p>
            </div>
        </div>
    </div>

    <!-- 2) 안전요원 관리 패널 -->
    <div id="panel-admin-agents" class="drawer-content">
        <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
            <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">안전요원 관리</span>
        </div>
        <div class="drawer-body">
            <div style="padding: 10px 0; color: #a0aec0; font-size: 13px;">
                <p>현장 요원 근무 상태 조회 및 구역 배치 관리를 수행합니다.</p>
            </div>
        </div>
    </div>

    <!-- 3) 관제 이력/보고서 패널 -->
    <div id="panel-admin-reports" class="drawer-content">
        <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
            <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">(?)</span>
        </div>
        <div class="drawer-body">
            <div style="padding: 10px 0; color: #a0aec0; font-size: 13px;">
                <p>()</p>
            </div>
        </div>
    </div>

    <!-- 4) 시스템 설정 패널 -->
    <div id="panel-admin-system" class="drawer-content">
        <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
            <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">시스템 설정</span>
        </div>
        <div class="drawer-body">
            <div style="padding: 10px 0; color: #a0aec0; font-size: 13px;">
                <p></p>
            </div>
        </div>
    </div>

</div>

<!-- ContextPath 전달 -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/resources/js/drone-sidebar.js"></script>