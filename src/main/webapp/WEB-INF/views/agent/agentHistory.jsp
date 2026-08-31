<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>업무 이력 조회</title>
    <!-- FontAwesome 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 커스텀 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentHistory.css">
</head>
<body>

    <div class="mobile-container">
        <!-- 상단 헤더 -->
        <header class="mobile-header">
            <button type="button" class="btn-back" onclick="history.back()">
                <i class="fa-solid fa-chevron-left"></i>
            </button>
            <h1 class="header-title">업무 이력 조회</h1>
            <div class="header-dummy"></div>
        </header>

        <!-- 메인 콘텐츠 -->
        <main class="mobile-content">
            <!-- 검색 필터 영역 -->
            <div class="filter-card">
                <div class="filter-row">
                    <label class="filter-label">기간 선택</label>
                    <div class="date-input-wrapper">
                        <input type="text" value="2026.05.01 ~ 2026.05.20" class="filter-input" readonly>
                        <i class="fa-regular fa-calendar calendar-icon"></i>
                    </div>
                </div>

                <div class="filter-row">
                    <label class="filter-label">구역 선택</label>
                    <select class="filter-select">
                        <option value="ALL">전체</option>
                        <option value="A">A구역</option>
                        <option value="B">B구역</option>
                        <option value="C">C구역</option>
                    </select>
                </div>

                <div class="filter-row">
                    <label class="filter-label">업무 유형</label>
                    <select class="filter-select">
                        <option value="ALL">전체</option>
                        <option value="EMERGENCY">긴급</option>
                        <option value="REPORT">상황</option>
                        <option value="PATROL">순찰</option>
                    </select>
                </div>

                <div class="filter-row">
                    <label class="filter-label">검색어</label>
                    <input type="text" class="filter-input" placeholder="업무 내용을 입력하세요.">
                </div>

                <button type="button" class="btn-search">검색</button>
            </div>

            <!-- 이력 목록 헤더 -->
            <div class="list-count-header">
                총 <span class="count">15</span>건
            </div>

            <!-- 이력 리스트 -->
            <div class="history-list">
                <!-- 아이템 1: 긴급 -->
                <div class="history-card">
                    <div class="card-main">
                        <div class="title-row">
                            <span class="badge badge-emergency">긴급</span>
                            <span class="history-title">인명 사고 대응</span>
                        </div>
                        <div class="info-meta">
                            <span>A구역</span>
                            <span>2026-05-20 14:35</span>
                        </div>
                    </div>
                    <span class="badge-status">완료</span>
                </div>

                <!-- 아이템 2: 상황 -->
                <div class="history-card">
                    <div class="card-main">
                        <div class="title-row">
                            <span class="badge badge-report">상황</span>
                            <span class="history-title">인파 밀집 보고</span>
                        </div>
                        <div class="info-meta">
                            <span>A구역</span>
                            <span>2026-05-20 13:10</span>
                        </div>
                    </div>
                    <span class="badge-status">완료</span>
                </div>

                <!-- 아이템 3: 순찰 -->
                <div class="history-card">
                    <div class="card-main">
                        <div class="title-row">
                            <span class="badge badge-patrol">순찰</span>
                            <span class="history-title">B구역 순찰</span>
                        </div>
                        <div class="info-meta">
                            <span>B구역</span>
                            <span>2026-05-20 11:20</span>
                        </div>
                    </div>
                    <span class="badge-status">완료</span>
                </div>
            </div>
        </main>

        <!-- 하단 탭 바 (네비게이션) -->
        <nav class="bottom-nav">
            <a href="${pageContext.request.contextPath}/agent/main" class="nav-item">
                <i class="fa-solid fa-house"></i>
                <span>홈</span>
            </a>
            <a href="${pageContext.request.contextPath}/agent/history" class="nav-item active">
                <i class="fa-solid fa-clipboard-list"></i>
                <span>업무</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fa-solid fa-user"></i>
                <span>정보</span>
            </a>
        </nav>
    </div>

</body>
</html>