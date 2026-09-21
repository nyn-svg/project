<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>보고 등록 완료</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentReportComplete.css">
</head>
<body>

    <div class="mobile-container">
        <!-- 상단 헤더 -->
        <header class="mobile-header">
            <h1 class="header-title">보고 등록 완료</h1>
            <div class="header-dummy"></div>
        </header>

        <!-- 메인 콘텐츠 -->
        <main class="mobile-content">
            <div class="complete-status">
                <div class="check-icon-circle">
                    <i class="fa-solid fa-check"></i>
                </div>
                <h2 class="complete-title">보고가 등록되었습니다.</h2>
                <p class="complete-sub">행사장 안전 관제 시스템에 보고 완료되었습니다.</p>
            </div>

            <!-- 요약 정보 테이블 카드 -->
            <div class="info-card">
                <h3 class="card-title">등록 완료 상세 정보</h3>
                <div class="info-row">
                    <span class="info-label">보고 번호 (이력번호)</span>
                    <!-- 🚨 진짜 DB 번호가 찍히는 영역 -->
                    <span class="info-value" id="resSituNo" style="color: #ef4444; font-weight: 800;">조회중...</span>
                </div>
                <div class="info-row">
                    <span class="info-label">위험 유형</span>
                    <span class="info-value" id="resDngrType">-</span>
                </div>
                <div class="info-row">
                    <span class="info-label">위험 단계</span>
                    <span class="info-value" id="resDngrLevel">-</span>
                </div>
                <div class="info-row">
                    <span class="info-label">발생 구역</span>
                    <span class="info-value" id="resZoneName">-</span>
                </div>
                <div class="info-row">
                    <span class="info-label">감지 일시</span>
                    <span class="info-value" id="resFormattedTime">-</span>
                </div>
            </div>

            <!-- 하단 이동 버튼 그룹 (점검완료 템플릿과 디자인 통일 완료) -->
            <div class="action-btn-group">
                <button type="button" class="btn-home" onclick="location.href='${pageContext.request.contextPath}/agent/main'">홈으로 이동</button>
            </div>
        </main>
    </div>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/agent/agentReportComplete.js"></script>

</body>
</html>