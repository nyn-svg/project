<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보</title>
    <!-- FontAwesome 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- 1. 공통 모바일 구조 CSS (agentMain.css 경로 설정) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentMain.css">
    <!-- 2. 내 정보 전용 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentInfo.css">
</head>
<body>

    <!-- agentMain과 동일한 규격의 모바일 컨테이너 -->
    <div class="mobile-container">
    
        <!-- 상단 서브 헤더 -->
        <header class="sub-header">
            <a href="javascript:history.back()" class="btn-back">
                <i class="fa-solid fa-chevron-left"></i>
            </a>
            <span class="header-title">내 정보</span>
        </header>

        <!-- 메인 콘텐츠 영역 -->
        <main class="mobile-content">
        
            <!-- 프로필 카드 -->
            <div class="info-profile-card">
                <div class="info-profile-avatar">
                    <i class="fa-solid fa-user"></i>
                </div>
                <div class="info-profile-detail">
                    <div class="info-profile-name">
                        ${not empty user.userName ? user.userName : '이안전'} 요원
                    </div>
                    <div>
                        <span class="badge-work">
                            ${not empty user.workStatus ? user.workStatus : '근무중'}
                        </span>
                    </div>
                </div>
            </div>

            <!-- 상세 정보 카드 -->
            <div class="info-detail-card">
                <!-- 상세 정보 카드 내 근무 상태 행 클릭 시 이동 -->
				<div class="info-row" style="cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/agent/status/edit'">
				    <span class="info-label">근무 상태</span>
				    <span class="info-value">
				        ${not empty user.workStatus ? user.workStatus : '근무중'} <i class="fa-solid fa-chevron-right" style="font-size: 12px; color: #94a3b8; margin-left: 4px;"></i>
				    </span>
				</div>
                <div class="info-row">
                    <span class="info-label">근무 담당 구역</span>
                    <span class="info-value">
                        ${not empty user.workArea ? user.workArea : '미지정'}
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">근무 시간</span>
                    <span class="info-value">
                        ${not empty user.workTime ? user.workTime : '09:00 ~ 18:00'}
                    </span>
                </div>
            </div>

            <!-- 로그아웃 버튼 -->
            <button type="button" class="btn-logout" onclick="location.href='${pageContext.request.contextPath}/logout'">
                <i class="fa-solid fa-right-from-bracket"></i> 로그아웃
            </button>
            
        </main>

        <!-- 하단 네비게이션 바 ('정보' 탭에만 active 추가) -->
        <nav class="bottom-nav">
            <a href="${pageContext.request.contextPath}/agent/main" class="nav-item">
                <i class="fa-solid fa-house"></i>
                <span>홈</span>
            </a>
            <a href="${pageContext.request.contextPath}/agent/history" class="nav-item">
                <i class="fa-solid fa-clipboard-list"></i>
                <span>업무</span>
            </a>
            <a href="${pageContext.request.contextPath}/agent/info" class="nav-item active">
                <i class="fa-solid fa-user"></i>
                <span>정보</span>
            </a>
        </nav>

    </div>

</body>
</html>