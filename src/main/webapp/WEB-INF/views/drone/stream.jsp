<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/drone-stream.css">

<!-- 전체 화면 분할 컨테이너 -->
<div class="drone-stream-wrapper">

    <!-- [좌측 영역] 비디오 스트리밍 + 하단 감지 이력 -->
    <div class="stream-main-area">
        
        <!-- 비디오 스트리밍 영역 -->
        <div class="stream-video-box">
            <div class="stream-header-info">
                <span class="drone-title">드론 [ ${droneId} ] 실시간 스트리밍</span>
            </div>
            <div class="stream-placeholder">
                <p>[ 드론 ${droneId} ] 실시간 영상 스트리밍 영역</p>
            </div>
        </div>

    </div>

    <!-- [우측 영역] 관제 컨트롤 카드가 위치할 독립 패널 -->
    <div class="control-panel-right">

        <!-- 1. 드론 정보 카드 -->
        <div class="control-card drone-info-card">
            <div class="card-title" id="drone-name-display">드론01</div>
            <div class="info-row">
                <span>배터리</span>
                <span class="info-value" id="drone-battery-display">70%</span>
            </div>
            <div class="info-row">
                <span>구역명</span>
                <span class="info-value" id="drone-zone-display">A구역</span>
            </div>
        </div>

        <!-- 2. 밀집도 카드 -->
        <div class="control-card density-card">
            <div class="card-header">
                <span class="card-title">밀집도</span>
                <div class="density-value-box">
                    <span id="density-rate-display">00</span> %
                </div>
            </div>

            <!-- 오버레이 및 사람 수 표시 토글 -->
            <div class="control-btn-group">
                <button type="button" class="control-btn active" id="btn-toggle-overlay">오버레이 효과 토글</button>
                <button type="button" class="control-btn active" id="btn-toggle-count">사람 수 표시 토글</button>
            </div>

            <!-- 민감도 설정 -->
            <div class="sensitivity-panel">
                <div class="sensitivity-label">민감도 설정</div>
                <div class="sensitivity-grid">
                    <button type="button" class="sens-btn" data-level="low">저고도/음영영역<br><small>10.0</small></button>
                    <button type="button" class="sens-btn active" data-level="mid">기본<br><small>15.0</small></button>
                    <button type="button" class="sens-btn" data-level="high">고고도/<br><small>20.0</small></button>
                </div>
            </div>
        </div>
        
        <!-- 3. 야생동물 감지 카드 -->
        <div class="control-card wildlife-card">
            <div class="card-header">
                <span class="card-title">야생동물</span>
                <span class="danger-badge" id="wildlife-risk-level">심각</span>
            </div>

            <div class="control-btn-group" style="margin-bottom: 8px;">
                <button type="button" class="control-btn active" id="btn-toggle-bbox">바운딩 박스 토글</button>
            </div>

            <div class="wildlife-body">
                <div class="detection-info">
                    <div>객체명 : <strong id="detected-object-name" style="color: #f8fafc;">고라니</strong></div>
                    <div>신뢰도 : <span id="detected-confidence">72</span> %</div>
                </div>
                <button type="button" class="misdetect-btn" id="btn-report-misdetection">오감지</button>
            </div>
        </div>

        <!-- 4. 자동 신고 카드 -->
        <div class="control-card report-card">
            <div class="card-title">자동 신고</div>
            <div class="report-status-box">
                <span class="status-text" id="report-status-text">소방서 신고 완료</span>
                <span class="status-time" id="report-status-time">2026-08-27 09:58</span>
            </div>
        </div>

    </div>

</div>