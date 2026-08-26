<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 1. 우측 60px 고정 퀵바 (아이콘 전용) -->
<aside class="quick-sidebar">
    <div class="quick-top">
        <button id="toggle-drawer-btn" class="quick-btn toggle-btn" title="사이드바 열기/닫기">
            ❮❮
        </button>
    </div>

    <nav class="quick-nav">
        <button class="quick-nav-item active" data-target="panel-festival">
            <span class="nav-icon">📊</span>
            <span class="nav-label">드론 관제</span>
        </button>
        <button class="quick-nav-item" data-target="panel-map">
            <span class="nav-icon">🗺️</span>
            <span class="nav-label">통합 관제</span>
        </button>
        <button class="quick-nav-item" data-target="panel-agent">
            <span class="nav-icon">🚨</span>
            <span class="nav-label">요원 현황</span>
        </button>
        <button class="quick-nav-item" data-target="panel-system">
            <span class="nav-icon">⚙️</span>
            <span class="nav-label">시스템</span>
        </button>
    </nav>
</aside>

<!-- 2. 왼쪽으로 열리는 260px 서브 드로어 패널 -->
<div id="sub-drawer" class="sub-drawer collapsed">
    <!-- 축제 현황 패널 -->
    <div id="panel-festival" class="drawer-content active">
        <div class="drawer-header">드론 관제</div>
        <div class="drawer-body">
            <p>실시간 드론 데이터 및 요약 정보가 표시됩니다. ( 임시 )</p>
        </div>
    </div>

    <!-- 통합 관제 지도 패널 -->
    <div id="panel-map" class="drawer-content">
        <div class="drawer-header">통합 관제 지도</div>
        <div class="drawer-body">
            <p>관제 지도 레이어 컨트롤 및 필터 옵션입니다. ( 임시 )</p>
        </div>
    </div>

    <!-- 현장 요원 지시 패널 -->
    <div id="panel-agent" class="drawer-content">
        <div class="drawer-header">안전 요원 근무 현황</div>
        <div class="drawer-body">
            <p>현장 요원 출동 현황 및 긴급 메시지 발송 기능입니다. ( 임시 )</p>
        </div>
    </div>

    <!-- 시스템 관리 패널 -->
    <div id="panel-system" class="drawer-content">
        <div class="drawer-header">시스템 관리</div>
        <div class="drawer-body">
            <p>시스템 설정 및 권한 관리 패널입니다. ( 임시 )</p>
        </div>
    </div>
</div>