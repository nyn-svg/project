<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        // 1. 우측 메뉴 버튼 클릭 시 탭 전환 및 드로어 열기
        $('.quick-nav-item').on('click', function() {
            const targetId = $(this).data('target');
            
            // 메뉴 활성화 상태 변경
            $('.quick-nav-item').removeClass('active');
            $(this).addClass('active');
            
            // 해당 탭 내용 변경
            $('.drawer-content').removeClass('active');
            $('#' + targetId).addClass('active');
            
            // 서브 드로어 패널 열기
            $('#sub-drawer').removeClass('collapsed');
            $('.quick-sidebar').addClass('is-open');
        });

        // 2. << 토글 버튼 클릭 시 서브 드로어 열기/닫기
        $('#toggle-drawer-btn').on('click', function() {
            const $drawer = $('#sub-drawer');
            $drawer.toggleClass('collapsed');
            $('.quick-sidebar').toggleClass('is-open');
        });
    });
    </script>
</body>
</html>