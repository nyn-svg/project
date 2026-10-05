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
    
    <!-- 자동등록 on/off 토글 -->
    <div class="header-auto-regist">
        <span class="toggle-label">자동 등록</span>
        <label class="header-switch">
            <input type="checkbox" id="auto-register-toggle">
            <span class="header-slider"></span>
        </label>
    </div>
    
    <!-- 기상 위젯 추가 (weatherWidget.jsp, 절대 경로 지정) -->
    <div class="header-weather-area">
        <jsp:include page="/WEB-INF/views/common/weatherWidget.jsp" />
    </div>
    
    <script>
        $(document).ready(function() {
            const $autoToggle = $('#auto-register-toggle');

            // 1. 서버/로컬 스토리지 상태 동기화
            $.ajax({
                url: ctx + '/api/settings/auto-register',
                type: 'GET',
                success: function(status) {
                    $autoToggle.prop('checked', status);
                }
            });

            // 2. 단일 토글 이벤트 처리
            $autoToggle.on('change', function() {
                const isChecked = $(this).is(':checked');
                $.ajax({
                    url: ctx + '/api/settings/auto-register',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ enabled: isChecked }),
                    success: function(res) {
                        console.log('자동등록 서버 설정 변경 완료:', res.autoRegist);
                    }
                });
            });
        });
    </script>
</header>