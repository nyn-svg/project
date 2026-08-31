<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartCrowd GIS 관제 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/drone-sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/drone-stream.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <!-- 감지 이력 현황 전용 CSS -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/detection-status.css">	
    <!-- Font Awesome 최신 버전 CDN 링크 추가 -->
	<script src="https://kit.fontawesome.com/232b0508f2.js" crossorigin="anonymous"></script>

    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

    <!-- 1. 좌측 메인 영역 (헤더 + 본문컨텐츠 + 푸터) -->
    <div class="app-left-area">
        
        <!-- 상단 헤더 조각 -->
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <!-- 메인 컨테이너 (각 페이지의 본문 내용이 조립되는 구역) -->
        <main id="main-container" class="main-container">
            <jsp:include page="${contentPage}" />
        </main>

        <!-- 하단 푸터 조각 -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    </div>

    <!-- 2. 우측 사이드바 (독립 컬럼 구역) -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <!-- 공통 스크립트 -->
    <script>
    $(document).ready(function() {
        // 1. 페이지 로드 시 저장된 사이드바 상태 복원
        var savedTarget = sessionStorage.getItem('activeNavTarget');
        var isDrawerOpen = sessionStorage.getItem('isDrawerOpen');

        if (isDrawerOpen === 'true' && savedTarget) {
            // 이전 버튼 active 처리
            $('.quick-nav-item').removeClass('active');
            var $activeBtn = $('.quick-nav-item[data-target="' + savedTarget + '"]');
            $activeBtn.addClass('active');

            // 이전 탭 내용 활성화
            $('.drawer-content').removeClass('active');
            $('#' + savedTarget).addClass('active');

            // 사이드바 열기
            $('#sub-drawer').removeClass('collapsed');
            $('.quick-sidebar').addClass('is-open');
        }

        // 2. 우측 메뉴 버튼 클릭 이벤트
        $('.quick-nav-item').on('click', function() {
            const $this = $(this);
            const targetId = $this.data('target');

            // 이미 활성화된 탭을 다시 누른 경우 -> 닫기
            if ($this.hasClass('active')) {
                $this.removeClass('active');
                $('#sub-drawer').addClass('collapsed');
                $('.quick-sidebar').removeClass('is-open');
                $('.drawer-content').removeClass('active');

                // ★ 상태 저장: 닫힘
                sessionStorage.setItem('isDrawerOpen', 'false');
                sessionStorage.removeItem('activeNavTarget');
                return;
            }

            // 새 메뉴 선택 -> 열기
            $('.quick-nav-item').removeClass('active');
            $this.addClass('active');
            
            $('.drawer-content').removeClass('active');
            $('#' + targetId).addClass('active');
            
            $('#sub-drawer').removeClass('collapsed');
            $('.quick-sidebar').addClass('is-open');

            // ★ 상태 저장: 열림 및 선택된 탭 ID 기록
            sessionStorage.setItem('isDrawerOpen', 'true');
            sessionStorage.setItem('activeNavTarget', targetId);
        });

     // 3. << / >> 토글 버튼 클릭 이벤트
        $('#toggle-drawer-btn').on('click', function() {
            const $drawer = $('#sub-drawer');
            const $sidebar = $('.quick-sidebar');
            
            $drawer.toggleClass('collapsed');
            $sidebar.toggleClass('is-open');

            var isOpen = $sidebar.hasClass('is-open');

            // ★ 닫혔을 경우 (>> 눌러서 닫을 때) 선택된 메뉴 및 불빛 비활성화
            if (!isOpen) {
                $('.quick-nav-item').removeClass('active');
                $('.drawer-content').removeClass('active');
                
                sessionStorage.setItem('isDrawerOpen', 'false');
                sessionStorage.removeItem('activeNavTarget');
            } else {
                sessionStorage.setItem('isDrawerOpen', 'true');
            }
        });
    });
</script>

    <!-- 💡 비동기 화면 전환 스크립트 추가 -->
    <script src="${pageContext.request.contextPath}/resources/js/app-router.js"></script>
</body>
</html>