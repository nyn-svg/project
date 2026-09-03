<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/control/controlMaincontent.css">
<div class="dashboard-wrapper">

    <!-- 상단 대시보드 요약 영역 -->
    <div class="top-widget-grid">
        
        <!-- [상단 좌측] 실시간 사건/사고 발생 현황 -->
        <div class="aurora-card alert-widget">
            <div class="widget-header">
                <h3 class="widget-title alert-title">
                    🚨 실시간 사건/사고 발생 현황
                </h3>
                <span class="badge badge-alert">조치 대기: 2건</span>
            </div>

            <div class="stat-badge-group">
                <div class="stat-badge">
                    <div class="stat-label">오늘 총 감지</div>
                    <div class="stat-value">14건</div>
                </div>
                <div class="stat-badge stat-badge-danger">
                    <div class="stat-label text-danger">미처리 알림</div>
                    <div class="stat-value text-danger">2건</div>
                </div>
                <div class="stat-badge">
                    <div class="stat-label">조치 완료</div>
                    <div class="stat-value text-info">12건</div>
                </div>
            </div>

            <div class="timeline-list">
                <div class="timeline-item timeline-danger">
                    <div class="timeline-content">
                        <strong class="text-danger-light">[위험] A구역 인파 밀집 감지</strong>
                        <span class="timeline-sub">기준 밀도 초과</span>
                    </div>
                    <span class="timeline-time">10분 전</span>
                </div>
                <div class="timeline-item timeline-warning">
                    <div class="timeline-content">
                        <strong class="text-warning-light">[경고] C구역 야생동물(멧돼지) 출몰</strong>
                        <span class="timeline-sub">외곽 펜스 부근</span>
                    </div>
                    <span class="timeline-time">25분 전</span>
                </div>
            </div>
        </div>

        <!-- [상단 우측] 현장 기상 및 비행 환경 정보 -->
        <div class="aurora-card weather-widget">
            <div class="widget-header">
                <h3 class="widget-title weather-title">
                    🌤️ 현장 기상 및 비행 환경 정보
                </h3>
                <span class="badge badge-success">비행 가능 (양호)</span>
            </div>

            <div class="env-metric-grid">
                <div class="metric-card">
                    <div class="metric-label">풍속</div>
                    <div class="metric-value text-info">2.4 m/s</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">기온</div>
                    <div class="metric-value">23.5 °C</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">습도</div>
                    <div class="metric-value">45 %</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">강수확률</div>
                    <div class="metric-value">10 %</div>
                </div>
            </div>

            <div class="flight-guide-box">
                <span>바람 제한: 풍속 10 m/s 이상 시 즉시 복귀 명령</span>
                <span class="text-muted">풍향: 북서풍 (NW)</span>
            </div>
        </div>

    </div>

    <!-- 하단 영역: 행사장 안전관리 가이드 (높이 100% 채움 적용) -->
    <div class="aurora-card safety-guide-section">
        <h2 class="section-title">
            📢 행사장 안전관리 가이드
        </h2>

        <div class="guide-card-grid">
            
            <!-- 1. 필수 안전수칙 -->
            <div class="guide-card">
                <h3 class="guide-title text-info">1. 필수 안전수칙</h3>
                <div class="guide-content">
                    <div class="guide-item">
                        <strong>🚶‍♂️ 인파 밀집 제어</strong>
                        <p>1㎡당 적정 인원 초과 시 일방통행 전환, 대기열 펜스 간격 유지.</p>
                    </div>
                    <div class="guide-item">
                        <strong>🎪 임시 시설물 안전</strong>
                        <p>무대/조명탑/고전압 구역 통제, 강풍·호우 시 철거 매뉴얼 적용.</p>
                    </div>
                    <div class="guide-item">
                        <strong>🚫 공통 금지사항</strong>
                        <p>불꽃놀이 및 인화물질 반입 제한, 주요 동선 적치물 금지.</p>
                    </div>
                </div>
            </div>

            <!-- 2. 위험 대응 프로세스 -->
            <div class="guide-card">
                <h3 class="guide-title text-warning">2. 위험 대응 프로세스 (3Step)</h3>
                <div class="process-list">
                    <div class="process-step">
                        <strong class="text-warning-light">Step 1. 상황 전파</strong>
                        <p>상황실 무전 보고, 대피 방송 송출.</p>
                    </div>
                    <div class="process-step">
                        <strong class="text-warning-light">Step 2. 대피 유도</strong>
                        <p>안전요원 비상구 배치, 역류 방지 유도.</p>
                    </div>
                    <div class="process-step">
                        <strong class="text-warning-light">Step 3. 현장 통제</strong>
                        <p>구급차 진입로 확보, 차단선 설정.</p>
                    </div>
                </div>
            </div>

            <!-- 3. 비상연락망 -->
            <div class="guide-card">
                <h3 class="guide-title text-danger">3. 비상연락망</h3>
                <table class="contact-table">
                    <tbody>
                        <tr>
                            <th>행사 종합상황실</th>
                            <td class="text-info">02-XXX-XXXX</td>
                        </tr>
                        <tr>
                            <th>관할 경찰서 (112)</th>
                            <td class="text-info">02-XXX-1120</td>
                        </tr>
                        <tr>
                            <th>관할 소방서 (119)</th>
                            <td class="text-info">02-XXX-1190</td>
                        </tr>
                        <tr>
                            <th>지자체 재난대책본부</th>
                            <td class="text-info">02-XXX-0119</td>
                        </tr>
                        <tr>
                            <th>현장 임시 의무실</th>
                            <td class="text-info">내선 104</td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>

        <div class="notice-ticker">
            <span class="ticker-badge">안전 공지</span>
            <div class="ticker-text">
                단위 면적당 적정 인원 초과 시 일방통행 전환 실행 | 위급 상황 발생 시 무전 채널 1번 종합상황실 즉시 보고
            </div>
        </div>

    </div>

</div>