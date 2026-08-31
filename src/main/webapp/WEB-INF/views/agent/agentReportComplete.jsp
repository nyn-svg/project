<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>보고 등록 완료</title>
    <!-- FontAwesome 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 커스텀 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentReportComplete.css">
</head>
<body>

    <div class="mobile-container">
        <!-- 상단 헤더 -->
        <header class="mobile-header">
            <button type="button" class="btn-back" onclick="location.href='${pageContext.request.contextPath}/agent/main'">
                <i class="fa-solid fa-chevron-left"></i>
            </button>
            <h1 class="header-title">보고 등록 완료</h1>
            <div class="header-dummy"></div>
        </header>

        <!-- 메인 콘텐츠 -->
        <main class="mobile-content">
            <!-- 완료 체크 아이콘 및 안내 문구 -->
            <div class="complete-status">
                <div class="check-icon-circle">
                    <i class="fa-solid fa-check"></i>
                </div>
                <h2 class="complete-title">보고가 등록되었습니다.</h2>
                <p class="complete-sub">상황실로 전송되었습니다.</p>
            </div>

            <!-- 보고 정보 요약 카드 -->
            <div class="info-card">
                <h3 class="card-title">보고 정보</h3>
                <div class="info-row">
                    <span class="info-label">보고 유형</span>
                    <span class="info-value">인파 밀집</span>
                </div>
                <div class="info-row">
                    <span class="info-label">발생 구역</span>
                    <span class="info-value">A구역</span>
                </div>
                <div class="info-row">
                    <span class="info-label">등록 시간</span>
                    <span class="info-value">2026-05-20 14:35</span>
                </div>
                <div class="info-row">
                    <span class="info-label">보고 번호</span>
                    <span class="info-value">RPT-20260520-0015</span>
                </div>
            </div>

            <!-- 하단 이동 버튼 그룹 -->
            <div class="action-btn-group">
                <button type="button" class="btn-history" onclick="location.href='${pageContext.request.contextPath}/agent/history'">업무 이력 조회</button>
                <button type="button" class="btn-home" onclick="location.href='${pageContext.request.contextPath}/agent/main'">홈으로 이동</button>
            </div>
        </main>
    </div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 1. URL 파라미터 읽기
    var urlParams = new URLSearchParams(window.location.search);
    var type = urlParams.get('type') || '인파 밀집';
    var area = urlParams.get('area') || 'A구역';

    // 2. 현재 시간 생성 (YYYY-MM-DD HH:mm)
    var now = new Date();
    var year = now.getFullYear();
    var month = String(now.getMonth() + 1).padStart(2, '0');
    var day = String(now.getDate()).padStart(2, '0');
    var hours = String(now.getHours()).padStart(2, '0');
    var minutes = String(now.getMinutes()).padStart(2, '0');
    var formattedTime = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;

    // 3. 랜덤 보고 번호 생성 (예: RPT-20260520-1234)
    var randomNum = Math.floor(1000 + Math.random() * 9000);
    var reportNo = 'RPT-' + year + month + day + '-' + randomNum;

    // 4. 화면 요소에 값 채워넣기
    var infoValues = document.querySelectorAll('.info-card .info-value');
    if (infoValues.length >= 4) {
        infoValues[0].innerText = type;        // 보고 유형
        infoValues[1].innerText = area;        // 발생 구역
        infoValues[2].innerText = formattedTime; // 등록 시간
        infoValues[3].innerText = reportNo;      // 보고 번호
    }
});
</script>

</body>
</html>