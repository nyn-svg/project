<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 상단 헤더 + 우측 사이드바 포함 조각 -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- 메인 컨텐츠 영역 (오로라 글래스모피즘 카드 적용) -->
<div class="aurora-card" style="flex: 1; margin-bottom: 24px; display: flex; align-items: center; justify-content: center;">
    <div style="text-align: center;">
        <h2 style="color: #38bdf8; font-size: 24px; font-weight: 700; margin-bottom: 8px;">
            🗺️ GIS 관제 지도 영토
        </h2>
        <p style="color: #94a3b8; font-size: 14px;">
            오로라 배경 빛이 투명하게 비치는 관제 시스템 메인 화면입니다.
        </p>
    </div>
</div>

<!-- 푸터 조각 -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />