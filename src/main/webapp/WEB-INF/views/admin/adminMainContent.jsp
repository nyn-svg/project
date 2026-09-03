<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 대시보드 전용 CSS 연동 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/adminMainContent.css">

<div class="admin-dashboard-container">
    
    <!-- 1. 상단 요약 KPI 카드 (5개 영역) -->
    <section class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-title">밀집도 위험구역</div>
            <div class="kpi-value-group">
                <span class="kpi-value warning">5</span><span class="kpi-unit">개</span>
            </div>
            <div class="kpi-sub diff-up">↑ 2</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">야생동물 위험</div>
            <div class="kpi-value-group">
                <span class="kpi-value warning">3</span><span class="kpi-unit">건</span>
            </div>
            <div class="kpi-sub diff-up">↑ 1</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">근무중 안전요원</div>
            <div class="kpi-value-group">
                <span class="kpi-value primary">94</span><span class="kpi-unit">명</span>
            </div>
            <div class="kpi-sub status-ok">정상</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">비행중 드론</div>
            <div class="kpi-value-group">
                <span class="kpi-value primary">4</span><span class="kpi-unit">대</span>
            </div>
            <div class="kpi-sub status-ok">정상</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">미확인 긴급보고</div>
            <div class="kpi-value-group">
                <span class="kpi-value danger">3</span><span class="kpi-unit">건</span>
            </div>
            <div class="kpi-sub diff-up">↑ 2</div>
        </div>
    </section>

    <!-- 2. 중단 영역 (좌: 지도 관제 / 우: 대응 현황) -->
    <section class="dashboard-middle">
        <!-- 행사장 실시간 관제 지도 -->
        <div class="dashboard-card map-card">
            <div class="card-header">
                <span class="card-title">행사장 실시간 관제 지도</span>
            </div>
            <div class="card-body map-body">
                <!-- 실제 GIS 지도(Kakao, VWorld 등) 또는 Canvas 영역 -->
                <div id="admin-map" class="map-view-area">
                    <!-- 지도 위에 표시될 범례 오버레이 -->
                    <div class="map-legend-overlay">
                        <div class="legend-item"><span class="dot agent"></span> 안전요원</div>
                        <div class="legend-item"><span class="dot drone"></span> 드론 위치</div>
                        <div class="legend-item"><span class="dot danger-zone"></span> 위험구역</div>
                        <div class="legend-item"><span class="dot density-high"></span> 밀집도 높음</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 실시간 위험 대응 현황 -->
        <div class="dashboard-card status-card">
            <div class="card-header">
                <span class="card-title">실시간 위험 대응 현황</span>
            </div>
            <div class="card-body">
                <ul class="status-list">
                    <li class="status-item">
                        <span class="status-label"><i class="fa-solid fa-triangle-exclamation color-danger"></i> 심각</span>
                        <span class="status-count">2 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                    <li class="status-item">
                        <span class="status-label"><i class="fa-solid fa-circle-exclamation color-warning"></i> 경계</span>
                        <span class="status-count">5 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                    <li class="status-item">
                        <span class="status-label"><i class="fa-solid fa-triangle-exclamation color-caution"></i> 주의</span>
                        <span class="status-count">8 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                    <li class="status-item">
                        <span class="status-label"><i class="fa-solid fa-circle-info color-info"></i> 관심</span>
                        <span class="status-count">21 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                </ul>

                <hr class="card-divider" />

                <ul class="status-list sub-list">
                    <li class="status-item">
                        <span class="status-label">미확인 긴급보고</span>
                        <span class="status-count danger">3 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                    <li class="status-item">
                        <span class="status-label">조치필요 업무지시</span>
                        <span class="status-count">5 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                    <li class="status-item">
                        <span class="status-label">조치중 업무지시</span>
                        <span class="status-count">2 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                </ul>
            </div>
        </div>
    </section>

    <!-- 3. 하단 영역 (좌: 차트 2종 / 우: 최근 위험 이벤트) -->
    <section class="dashboard-bottom">
        <!-- 통계 차트 영역 -->
        <div class="dashboard-card chart-card">
            <div class="chart-box">
                <div class="card-header">
                    <span class="card-title">시간대별 밀집도 추이 (전체)</span>
                </div>
                <div class="card-body">
                    <!-- Chart.js 등의 라인 차트 영역 -->
                    <div class="chart-wrapper">
                        <canvas id="densityChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="chart-box">
                <div class="card-header">
                    <span class="card-title">야생동물 출현 빈도 (최근 7일)</span>
                </div>
                <div class="card-body">
                    <!-- Chart.js 등의 바 차트 영역 -->
                    <div class="chart-wrapper">
                        <canvas id="animalChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- 최근 위험 이벤트 -->
        <div class="dashboard-card event-card">
            <div class="card-header">
                <span class="card-title">최근 위험 이벤트</span>
            </div>
            <div class="card-body">
                <ul class="event-list">
                    <li class="event-item">
                        <span class="event-time">14:32</span>
                        <span class="event-desc">푸드존 인근 밀집</span>
                        <span class="badge-tag danger">심각</span>
                        <span class="action-status">처리중</span>
                    </li>
                    <li class="event-item">
                        <span class="event-time">14:28</span>
                        <span class="event-desc">산책로 멧돼지 출현</span>
                        <span class="badge-tag warning">경계</span>
                        <span class="action-status">출동</span>
                    </li>
                    <li class="event-item">
                        <span class="event-time">14:21</span>
                        <span class="event-desc">입구 인과 엉킴</span>
                        <span class="badge-tag caution">주의</span>
                        <span class="action-status done">완료</span>
                    </li>
                </ul>
            </div>
        </div>
    </section>

</div>