<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 기존 관제사 대시보드 공통 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/maincontent.css">
<!-- 관리자 메인 전용 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/adminMainContent.css">

<div class="dashboard-wrapper">

    <!-- 상단 대시보드 요약 영역 (2열 레이아웃) -->
    <div class="top-widget-grid">
        
        <!-- [상단 좌측] 실시간 안전요원 근무 현황 -->
        <div class="aurora-card alert-widget">
            <div class="widget-header">
                <h3 class="widget-title alert-title">
                    👮‍♂️ 실시간 안전요원 근무 현황
                </h3>
                <span class="badge badge-success">총 요원: ${totalAgentCount != null ? totalAgentCount : 12}명</span>
            </div>

            <div class="stat-badge-group">
                <div class="stat-badge">
                    <div class="stat-label">근무중</div>
                    <div class="stat-value text-info">${onDutyCount != null ? onDutyCount : 8}명</div>
                </div>
                <div class="stat-badge stat-badge-warning">
                    <div class="stat-label text-warning">휴식/외출</div>
                    <div class="stat-value text-warning">${breakCount != null ? breakCount : 2}명</div>
                </div>
                <div class="stat-badge">
                    <div class="stat-label">퇴근</div>
                    <div class="stat-value text-muted">${offDutyCount != null ? offDutyCount : 2}명</div>
                </div>
            </div>

            <!-- 최근 실시간 상태 변경 타임라인 -->
            <div class="timeline-list">
                <div class="timeline-item timeline-success">
                    <div class="timeline-content">
                        <strong>[김이슬 요원] 근무 상태 변경</strong>
                        <span class="timeline-sub">휴식중 ➔ 근무중 (A구역)</span>
                    </div>
                    <span class="timeline-time">5분 전</span>
                </div>
                <div class="timeline-item timeline-warning">
                    <div class="timeline-content">
                        <strong>[박안전 요원] 근무 상태 변경</strong>
                        <span class="timeline-sub">근무중 ➔ 외출중 (외부 업무)</span>
                    </div>
                    <span class="timeline-time">20분 전</span>
                </div>
            </div>
        </div>

        <!-- [상단 우측] 금일 업무 및 상황 보고 요약 -->
        <div class="aurora-card weather-widget">
            <div class="widget-header">
                <h3 class="widget-title weather-title">
                    📋 금일 현장 보고 접수 요약
                </h3>
                <span class="badge badge-alert">긴급 보고: 1건</span>
            </div>

            <div class="env-metric-grid">
                <div class="metric-card">
                    <div class="metric-label">일반 보고</div>
                    <div class="metric-value text-info">18 건</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">긴급 보고</div>
                    <div class="metric-value text-danger">1 건</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">조치 완료</div>
                    <div class="metric-value">17 건</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">조치 진행중</div>
                    <div class="metric-value text-warning">2 건</div>
                </div>
            </div>

            <div class="flight-guide-box">
                <span>⚡ 최근 긴급 보고: A구역 인파 밀집에 따른 추가 인력 배치 요청</span>
                <span class="text-muted">접수 시간: 14:20</span>
            </div>
        </div>

    </div>

    <!-- 하단 영역: 안전요원 관리 및 상태 현황 테이블 -->
    <div class="aurora-card safety-guide-section">
        <div class="widget-header">
            <h2 class="section-title">
                👥 현장 안전요원 실시간 목록
            </h2>
            <button type="button" class="btn-link-badge" onclick="location.href='${pageContext.request.contextPath}/admin/agents'">
                전체 요원 관리 ➔
            </button>
        </div>

        <!-- 요원 현황 테이블 -->
        <div class="agent-table-wrapper">
            <table class="agent-status-table">
                <thead>
                    <tr>
                        <th>요원 ID</th>
                        <th>이름</th>
                        <th>연락처</th>
                        <th>담당 구역</th>
                        <th>근무 시간</th>
                        <th>현재 상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="agent" items="${agentList}">
                        <tr>
                            <td>${agent.userId}</td>
                            <td><strong>${agent.userName}</strong></td>
                            <td>${agent.phone}</td>
                            <td><span class="badge badge-info">${agent.workArea}</span></td>
                            <td>${agent.workTime}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${agent.workStatus eq '근무중'}">
                                        <span class="badge badge-success">근무중</span>
                                    </c:when>
                                    <c:when test="${agent.workStatus eq '휴식중' or agent.workStatus eq '외출중'}">
                                        <span class="badge badge-warning">${agent.workStatus}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-offduty">${agent.workStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <!-- DB 데이터 연결 전 테스트용 데이터 -->
                    <c:if test="${empty agentList}">
                        <tr>
                            <td>agent01</td>
                            <td><strong>김이슬</strong></td>
                            <td>010-1234-5678</td>
                            <td><span class="badge badge-info">A구역</span></td>
                            <td>09:00 ~ 18:00</td>
                            <td><span class="badge badge-success">근무중</span></td>
                        </tr>
                        <tr>
                            <td>agent02</td>
                            <td><strong>박안전</strong></td>
                            <td>010-9876-5432</td>
                            <td><span class="badge badge-info">B구역</span></td>
                            <td>09:00 ~ 18:00</td>
                            <td><span class="badge badge-warning">휴식중</span></td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="notice-ticker">
            <span class="ticker-badge">관리자 알림</span>
            <div class="ticker-text">
                안전요원의 근무 구역 변경 및 상태 수정은 '전체 요원 관리' 메뉴에서 가능합니다.
            </div>
        </div>

    </div>

</div>