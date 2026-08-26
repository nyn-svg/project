<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartCrowd GIS 관제 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/layout.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

    <!-- 1. 상단 헤더 -->
    <header class="app-header">
        <div class="header-logo" onclick="location.href='/'">
            <div class="logo-icon">🛡️</div>
            <span>SmartCrowd GIS</span>
        </div>

        <div class="header-right">
            <div style="font-size: 12px; background-color: rgba(34, 197, 94, 0.1); color: #22c55e; border: 1px solid rgba(34, 197, 94, 0.2); padding: 4px 12px; border-radius: 9999px; font-weight: 600;">
                ● 시스템 정상 가동 중
            </div>
            <button class="btn-login" onclick="alert('로그인 모달 연동 예정')">관제 로그인</button>
            
            <!-- 💡 사이드바가 접혔을 때만 나타나는 열기 버튼 -->
            <button id="open-sidebar-btn" class="sidebar-toggle-btn" style="display: none;" title="사이드바 열기">
                ❮
            </button>
        </div>
    </header>

    <!-- 2. 우측 사이드바 -->
    <aside id="sidebar" class="app-sidebar">
        <div>
            <!-- 사이드바 상단 헤더 (제목 + 접기 버튼) -->
            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; padding: 0 4px;">
                <span style="font-size: 11px; font-weight: 700; color: #475569; letter-spacing: 0.5px;">NAVIGATION</span>
                <!-- 💡 사이드바 안쪽의 닫기 버튼 -->
                <button id="close-sidebar-btn" class="sidebar-toggle-btn" title="사이드바 접기">
                    ❯
                </button>
            </div>

            <nav class="sidebar-nav">
                <a href="#" class="nav-item active">
                    <span>📊</span> 축제 현황
                </a>
                <a href="#" class="nav-item">
                    <span>🗺️</span> 통합 관제 지도
                </a>
                <a href="#" class="nav-item">
                    <span>🚨</span> 현장 요원 지시
                </a>
                <a href="#" class="nav-item">
                    <span>⚙️</span> 시스템 관리
                </a>
            </nav>
        </div>

        <div style="font-size: 11px; color: #475569; text-align: center;">
            v1.0.0-RELEASE
        </div>
    </aside>

    <!-- 3. 메인 컨테이너 시작 -->
    <main id="main-container" class="main-container">

    <!-- 💡 사이드바 토글 동작 자바스크립트 -->
    <script>
    $(document).ready(function() {
        // 사이드바 접기 (사이드바만 우측으로 이동, 메인 영역 영향 없음)
        $('#close-sidebar-btn').on('click', function() {
            $('#sidebar').addClass('collapsed');
            $('#open-sidebar-btn').fadeIn(200);
        });

        // 사이드바 열기 (사이드바만 메인 영역 위로 슬라이드인)
        $('#open-sidebar-btn').on('click', function() {
            $('#sidebar').removeClass('collapsed');
            $('#open-sidebar-btn').fadeOut(100);
        });
    });
    </script>