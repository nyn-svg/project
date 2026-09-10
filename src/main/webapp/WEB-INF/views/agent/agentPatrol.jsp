<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>안전 순찰</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentPatrol.css">
</head>
<body>

    <div class="mobile-container">
        <!-- 헤더 -->
        <header class="mobile-header">
            <a href="javascript:history.back()" class="back-btn">
                <i class="fa-solid fa-chevron-left"></i>
            </a>
            <h1>안전 순찰</h1>
            <div class="header-right-empty"></div>
        </header>

        <main class="mobile-content">
            <div class="patrol-menu-list">
                
                <!-- 사전 점검 -->
                <button type="button" class="patrol-menu-card card-blue" id="btnPreCheck">
                    <div class="card-icon-box">
                        <i class="fa-solid fa-clipboard-list"></i>
                    </div>
                    <div class="card-text-group">
                        <div class="card-title">사전 점검</div>
                    </div>
                    <i class="fa-solid fa-chevron-right card-arrow"></i>
                </button>

                <!-- 긴급 처리보고 -->
                <button type="button" class="patrol-menu-card card-red" id="btnEmergencyReport">
                    <div class="card-icon-box">
                        <i class="fa-solid fa-bell"></i>
                    </div>
                    <div class="card-text-group">
                        <div class="card-title-red">긴급 처리보고</div>
                    </div>
                    <i class="fa-solid fa-chevron-right card-arrow"></i>
                </button>

                <!-- 유관기관 신고 -->
                <div class="patrol-menu-card card-green-wrap">
                    <button type="button" class="card-green-main" id="btnOrgReport">
                        <div class="card-icon-box">
                            <i class="fa-solid fa-phone"></i>
                        </div>
                        <div class="card-text-group">
                            <div class="card-title-green">유관기관 신고</div>
                        </div>
                        <i class="fa-solid fa-chevron-right card-arrow"></i>
                    </button>
                    
                    <!-- 하단 단축 다이얼 배지 그룹 -->
                    <div class="dial-badge-group">
                        <a href="tel:119" class="dial-badge badge-fire">
                            <i class="fa-solid fa-fire"></i> 119
                        </a>
                        <a href="tel:112" class="dial-badge badge-police">
                            <i class="fa-solid fa-shield-halved"></i> 112
                        </a>
                        <button type="button" class="dial-badge badge-etc" id="btnDialEtc">
                            기타
                        </button>
                    </div>
                </div>

            </div>
        </main>

        <!-- 고정 하단 메뉴바 -->
        <nav class="bottom-nav">
            <button type="button" class="nav-item active nav-patrol" id="navPatrol">
                <i class="fa-solid fa-shield-halved"></i>
                <span> 안전순찰 </span>
            </button>

            <button type="button" class="nav-item nav-home" id="navHome">
                <i class="fa-solid fa-house"></i>
                <span> 홈 </span>
            </button>

            <button type="button" class="nav-item nav-report" id="navReport">
                <i class="fa-solid fa-file-pen"></i>
                <span> 조치보고 </span>
            </button>
        </nav>
    </div>
    
<!-- JS 외부 스크립트 순서 정밀 로드 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/agent/agentPatrol.js"></script>

</body>
</html>