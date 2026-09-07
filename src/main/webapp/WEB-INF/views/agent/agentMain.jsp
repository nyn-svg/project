<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>안전요원 홈</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentMain.css">
</head>
<body>

<div class="mobile-container">
    <!--  HEADER -->
    <header class="mobile-header">
        <div class="header-left">
            <div class="user-profile">
                <div class="profile-icon">
                    <i class="fa-solid fa-user"></i>
                </div>
                <div class="user-text">
                    <span class="welcome-text"> 안녕하세요 </span>
                    <strong class="user-name"> ${user.userName} 안전요원님 </strong>
                </div>
            </div>
        </div>


        <button type="button" class="notification-bell" id="notificationBtn">
            <i class="fa-regular fa-bell"></i>
            <span class="bell-count">0</span>
        </button>
    </header>


    <!-- MAIN CONTENT 이 영역만 스크롤됨 -->
    <main class="mobile-content">
        <!-- 현재 근무 상태 -->
        <section class="status-card">
            <div class="status-card-top">
                <span class="section-label"> 현재 상태 </span>
                <span class="status-badge">
                    <span class="status-dot"></span>
                    ${user.workStatus}
                </span>
            </div>
            
            <div class="status-main">
                <h2>${user.workArea}</h2>
                <p>
                    <i class="fa-regular fa-clock"></i>
                    ${user.workTime}
                </p>
            </div>

            <button type="button" class="status-change-btn" id="statusChangeBtn">
                <span> 근무 상태 변경 </span>
                <i class="fa-solid fa-chevron-right"></i>
            </button>
        </section>

        <!-- 주요 알림 -->
        <section class="notice-section">
            <div class="section-header">
                <h2> 주요 알림 </h2>
                <button type="button" class="more-btn" id="noticeMoreBtn">
                    전체보기
                    <i class="fa-solid fa-chevron-right"></i>
                </button>
            </div>
            
            <div class="notice-list">
                <!-- 위험 알림 -->
                <button type="button" class="notice-item danger" data-type="danger">
                    <div class="notice-icon">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>

                    <div class="notice-info">
                        <div class="notice-title"> 위험 알림 </div>
                        <div class="notice-text"> 현재 담당 구역에 위험 상황이 감지되었습니다. </div>
                    </div>

                    <span class="notice-time"> - </span>
                </button>

                <!-- 안전 요청 -->
                <button type="button" class="notice-item warning" data-type="request">
                    <div class="notice-icon">
                        <i class="fa-solid fa-person-circle-exclamation"></i>
                    </div>

                    <div class="notice-info">
                        <div class="notice-title"> 안전 요청 </div>
                        <div class="notice-text"> 관제실에서 안전요원 지원을 요청했습니다. </div>
                    </div>

                    <span class="notice-time"> - </span>
                </button>

                <!-- 공지사항 -->
                <button type="button" class="notice-item info" data-type="notice">
                    <div class="notice-icon">
                        <i class="fa-solid fa-circle-info"></i>
                    </div>
                    
                    <div class="notice-info">
                        <div class="notice-title"> 공지사항 </div>
                        <div class="notice-text"> 행사장 안전 관련 공지사항을 확인해주세요. </div>
                    </div>

                    <span class="notice-time"> - </span>
                </button>
            </div>
        </section>


        <!-- 바로가기 -->
        <section class="quick-section">
            <div class="section-header">
                <h2> 바로가기 </h2>
            </div>

            <div class="quick-grid">
                <!-- 위험 알림 -->
                <button type="button" class="quick-card quick-danger">
                    <div class="quick-icon danger-icon">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>
                    
                    <div class="quick-text">
                        <strong> 위험 알림 </strong>
                        <span> 위험 상황 확인 </span>
                    </div>
                    <i class="fa-solid fa-chevron-right quick-arrow"></i>
                </button>

                <!-- 안전 순찰 -->
                <button type="button" class="quick-card quick-patrol">
                    <div class="quick-icon patrol-icon">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>

                    <div class="quick-text">
                        <strong> 안전순찰 </strong>
                        <span> 담당 구역 순찰 </span>
                    </div>

                    <i class="fa-solid fa-chevron-right quick-arrow"></i>
                </button>

                <!-- 나의 구역 -->
                <button type="button" class="quick-card quick-area">
                    <div class="quick-icon area-icon">
                        <i class="fa-solid fa-location-dot"></i>
                    </div>

                    <div class="quick-text">
                        <strong> 나의 구역 </strong>
                        <span> 담당 구역 확인 </span>
                    </div>

                    <i class="fa-solid fa-chevron-right quick-arrow"></i>
                </button>


                <!-- 조치보고 -->
                <button type="button" class="quick-card quick-report">
                    <div class="quick-icon report-icon">
                        <i class="fa-solid fa-file-pen"></i>
                    </div>
                    
                    <div class="quick-text">
                        <strong> 조치보고 </strong>
                        <span> 안전조치 보고 </span>
                    </div>

                    <i class="fa-solid fa-chevron-right quick-arrow"></i>
                </button>
            </div>
        </section>



        <!-- 로그아웃 -->
        <section class="logout-section">
            <button type="button" class="logout-btn" id="logoutBtn">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span> 로그아웃 </span>
            </button>
        </section>
    </main>


    <!-- 하단 메뉴바 -->

    <nav class="bottom-nav">
        <button type="button" class="nav-item nav-patrol" id="navPatrol">
            <i class="fa-solid fa-shield-halved"></i>
            <span> 안전순찰 </span>
        </button>


        <button type="button" class="nav-item active nav-home" id="navHome">
            <i class="fa-solid fa-house"></i>
            <span> 홈 </span>
        </button>

        <button type="button" class="nav-item nav-report" id="navReport">
            <i class="fa-solid fa-file-pen"></i>
            <span> 조치보고 </span>
        </button>
    </nav>
</div>

<!-- ==================================================
     JS
================================================== -->

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/agent/agentMain.js"></script>

</body>
</html>