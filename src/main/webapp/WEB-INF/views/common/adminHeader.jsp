<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 관리자 전용 상단 헤더 -->
<header class="app-header admin-header">
    <a href="${pageContext.request.contextPath}/admin/main" class="header-logo header-link">
        <div class="logo-icon"><i class="fa-solid fa-display"></i></div>
		<span>2TEAM <span class="admin-badge">ADMIN</span></span>
    </a>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/admin/main" class="nav-link header-link">홈</a>
        <a href="${pageContext.request.contextPath}/admin/areaManagement" class="nav-link header-link">행사장 관리</a>
        <a href="${pageContext.request.contextPath}/admin/userManagement" class="nav-link header-link">사용자 관리</a>
    	<a href="${pageContext.request.contextPath}/admin/checklist" class="nav-link header-link">점검 관리</a>
    	<a href="${pageContext.request.contextPath}/admin/fieldAction" class="nav-link header-link">위험 감지 관리</a>
    </nav>
    
</header>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 헤더의 메뉴 링크(.header-link)들을 모두 찾음
    const navLinks = document.querySelectorAll('.header-link');
    
    // 메뉴 중 하나라도 클릭하면 실행
    navLinks.forEach(function(link) {
        link.addEventListener('click', function() {
            // 홈 화면 SSE 연결이 켜져있다면 먼저 강제로 끎
            if (typeof window.closeTerminalSse === 'function') {
                window.closeTerminalSse();
            }
        });
    });
});
</script>


<!-- Chart.js 라이브러리 (비동기 이동 시에도 항상 전역 유지) -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>