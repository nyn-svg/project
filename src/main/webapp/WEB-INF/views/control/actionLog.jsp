<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- CSS 로드 (프로젝트 정적 리소스 경로 규칙 준수) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/control/actionLog.css">

<div class="action-log-container">
    
    <!-- 1. 상단 통계 카드 영역 -->
    <div class="summary-card">
        <div class="summary-item">
            <span class="summary-label">자동생성 조치록 건수:</span>
            <span class="summary-value" id="autoLogCount">0 건</span>
        </div>
        <div class="summary-item">
            <span class="summary-label">작성완료 조치록 건수:</span>
            <span class="summary-value" id="completeLogCount">0 건</span>
        </div>
    </div>

    <!-- 2. 하단 목록 영역 -->
    <div class="list-section">
        <div class="section-title">조치록 목록</div>
        
        <table class="action-log-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>감지 유형</th>
                    <th>발생 위치</th>
                    <th>생성 일시</th>
                    <th>작성 상태</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody id="actionLogList">
                <!-- 비동기(AJAX) 데이터가 렌더링될 영역 -->
                <tr>
                    <td colspan="6" class="empty-msg">데이터를 불러오는 중입니다...</td>
                </tr>
            </tbody>
        </table>
    </div>

</div>

<!-- 스크립트 영역 (비동기 데이터 호출) -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // 페이지 로드 시 조치록 목록 데이터 비동기 조회 호출
    loadActionLogs();
});

function loadActionLogs() {
    // 샘플 비동기 데이터 처리 예시 (추후 컨트롤러/REST API 연동)
    /*
    fetch('${pageContext.request.contextPath}/actionLog/list')
        .then(response => response.json())
        .then(data => {
            // 통계 및 목록 렌더링 로직
        });
    */
}
</script>