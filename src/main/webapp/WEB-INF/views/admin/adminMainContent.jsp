<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 대시보드 전용 CSS 연동 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/adminMainContent.css">

<div class="admin-dashboard-container">
    
    <!-- 1. 상단 요약 KPI 카드 (5개 영역) -->
    <section class="kpi-grid">
    <!-- 1. 미확인 위험 이력 (위험 발생 시 경보 Glow 효과) -->
    <div class="kpi-card ${uncheckedRiskCount > 0 ? 'kpi-warning-glow' : ''}">
        <div class="kpi-bg-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div class="kpi-header">
            <span class="kpi-title">미확인 위험 이력</span>
            <span class="kpi-status-badge ${uncheckedRiskCount > 0 ? 'badge-warning' : 'badge-neutral'}">
                <span class="pulse-dot ${uncheckedRiskCount > 0 ? 'warning' : 'neutral'}"></span>
                ${uncheckedRiskCount > 0 ? 'RISK' : 'NORMAL'}
            </span>
        </div>
        <div class="kpi-value-group">
            <span class="kpi-value warning counter" id="kpi-unchecked-risk" data-target="${uncheckedRiskCount != null ? uncheckedRiskCount : 0}">
                0
            </span>
            <span class="kpi-unit">건</span>
        </div>
    </div>

    <!-- 2. 미확인 긴급보고 (긴급 건수 1건 이상 시 Red Glow 이펙트) -->
    <div class="kpi-card ${unreadEmergencyCount > 0 ? 'kpi-danger-glow' : ''}">
        <div class="kpi-bg-icon"><i class="fa-solid fa-truck-medical"></i></div>
        <div class="kpi-header">
            <span class="kpi-title">미확인 긴급보고</span>
            <span class="kpi-status-badge ${unreadEmergencyCount > 0 ? 'badge-danger' : 'badge-neutral'}">
                <span class="pulse-dot ${unreadEmergencyCount > 0 ? 'danger' : 'neutral'}"></span>
                ${unreadEmergencyCount > 0 ? 'ALERT' : 'NORMAL'}
            </span>
        </div>
        <div class="kpi-value-group">
            <span class="kpi-value danger counter" id="kpi-unread-emergency-count" data-target="${unreadEmergencyCount != null ? unreadEmergencyCount : 0}">
                0
            </span>
            <span class="kpi-unit">건</span>
        </div>
    </div>

    <!-- 3. 근무중 안전요원 -->
    <div class="kpi-card">
        <div class="kpi-bg-icon"><i class="fa-solid fa-user-shield"></i></div>
        <div class="kpi-header">
            <span class="kpi-title">안전요원</span>
            <span class="kpi-status-badge badge-success">
                <span class="pulse-dot success"></span> LIVE
            </span>
        </div>
        <div class="kpi-value-group">
            <span class="kpi-value primary counter" data-target="${onDutyCount != null ? onDutyCount : 0}">
                0
            </span>
            <span class="kpi-unit">명</span>
        </div>
    </div>

    <!-- 4. 비행중 드론 -->
    <div class="kpi-card">
        <div class="kpi-bg-icon"><i class="fa-solid fa-crosshairs"></i></div>
        <div class="kpi-header">
            <span class="kpi-title">비행중 드론</span>
            <span class="kpi-status-badge badge-success">
                <span class="pulse-dot success"></span> ACTIVE
            </span>
        </div>
        <div class="kpi-value-group">
            <span class="kpi-value primary counter" data-target="${flyingDroneCount != null ? flyingDroneCount : 0}">
                0
            </span>
            <span class="kpi-unit">대</span>
        </div>
    </div>

<!-- 안전점검 바로가기 버튼 (카드 전체 가득 채우기) -->
<a href="${pageContext.request.contextPath}/admin/safetyCheck" class="kpi-card kpi-action-btn">
    <!-- 배경 워터마크 아이콘 -->
    <div class="kpi-bg-icon"><i class="fa-solid fa-clipboard-check"></i></div>
    
    <div class="kpi-action-content">
        <div class="kpi-action-left">
            <div class="kpi-action-icon">
                <i class="fa-solid fa-clipboard-check"></i>
            </div>
            <div class="kpi-action-info">
                <span class="kpi-action-title">안전점검</span>
                <span class="kpi-action-sub">상세 조회 바로가기</span>
            </div>
        </div>
        
        <!-- 우측 액션 화살표 원형 버튼 -->
        <div class="kpi-action-arrow">
            <i class="fa-solid fa-chevron-right arrow-anim"></i>
        </div>
    </div>
</a>
</section>

    <!-- 2. 중단 영역 (좌: 지도 관제 / 우: 대응 현황) -->
    <section class="dashboard-middle">
        <!-- 행사장 실시간 관제 지도 -->
		<div class="dashboard-card map-card">
		    <div class="card-header">
		        <span class="card-title">행사장 실시간 관제 지도</span>
		    </div>
		    <div class="card-body map-body">
		        <!-- 메인 화면용 지도 래퍼 (줌/팬 및 레이어 통합 영역) -->
		        <div id="admin-map" class="map-container-wrapper">
		            <!-- (1) 배경 도면 이미지 -->
		            <img id="bgMapImage" src="" alt="등록된 도면이 없습니다" class="bg-map-img" style="display:none;">
		
		            <!-- (2) 구역(Polygon) 드로잉 Canvas Layer -->
		            <canvas id="zoneCanvas" class="drawing-layer"></canvas>
		
		            <!-- (3) 시설물 아이콘(Marker) 배치 DOM Layer -->
		            <div id="facilityLayer" class="facility-dom-layer"></div>
		
		
		            <!-- 도면 미등록 안내 메시지 -->
		            <div class="empty-map-notice" id="emptyNotice">
		                <i class="fa-solid fa-map-location-dot"></i>
		                <p>등록된 행사장 평면도가 없습니다.</p>
		            </div>
		        </div>
		    </div>
		</div>

        <!-- 실시간 관제 이벤트 터미널 로그 -->
		<div class="dashboard-card terminal-card">
		    <div class="card-header">
		        <span class="card-title"><i class="fa-solid fa-terminal"></i> 이벤트 로그</span>
		        
		        <div class="terminal-controls">
		            <select id="terminalTypeSelect" class="terminal-select">
		                <option value="ALL">전체</option>
		                <option value="INFO">INFO</option>
		                <option value="ACTION">ACTION</option>
		                <option value="WARN">CAUTION</option>
		                <option value="DANGER">ALERT</option>
		            </select>
		            <input type="text" id="terminalSearchInput" class="terminal-search" placeholder="검색..." />
		            <span class="terminal-status-badge">
		                <span class="pulse-dot success"></span> LIVE
		            </span>
		        </div>
		    </div>
		
		    <div class="terminal-body-wrapper" style="position: relative;">
		        <!-- 🎯 [위치/문구 수정] 우측 상/하단 코너 미니 알림 배지 -->
		        <div id="terminalScrollTopIndicator" class="terminal-scroll-indicator top" style="display: none;">
		            ▲ 이전 로그
		        </div>
		
		        <div class="card-body terminal-body" id="terminalLogContainer">
		            <ul class="terminal-log-list" id="terminalLogList">
		                <!-- JS 데이터 영역 -->
		            </ul>
		            <div class="terminal-prompt">
		                <span class="prompt-symbol">&gt;</span> <span class="typing-text">Real-time system monitoring active</span><span class="terminal-cursor">_</span>
		            </div>
		        </div>
		
		        <div id="terminalScrollBottomIndicator" class="terminal-scroll-indicator bottom" style="display: none;">
		            ▼ 최신 로그
		        </div>
		    </div>
		</div>
    </section>

    <!-- 3. 하단 영역 (좌: 차트 2종 / 우: 최근 위험 이벤트) -->
    <section class="dashboard-bottom">
        <!-- 통계 차트 영역 -->
        <div class="dashboard-card chart-card">
            <div class="chart-box">
                <div class="card-header">
                    <span class="card-title">밀집도 추이 (%)</span>
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
                    <span class="card-title">야생동물 감지 신호 수위 (%)</span>
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
    
    <!-- 드론 실시간 영상 출력 모달 -->
<div id="droneVideoModal" class="drone-modal-overlay" style="display: none;">
    <div class="drone-modal-content">
        <div class="drone-modal-header">
            <span class="drone-modal-title" id="modalDroneTitle">드론 실시간 스트리밍</span>
            <button type="button" class="drone-modal-close" onclick="closeDroneModal()">&times;</button>
        </div>
        <div class="drone-modal-body">
		    <!-- 비디오/이미지와 Canvas를 겹쳐 올려줄 상대 위치(relative) 컨테이너 -->
		    <div style="position: relative; display: inline-block; width: 100%;">
		        <!-- MJPEG / MP4 모두 지원 가능하도록 img와 video 태그 준비 -->
		        <img id="modalStreamImg" src="" alt="스트리밍 연결 중..." style="width:100%; height:auto; display:none;" />
		        <video id="modalStreamVideo" src="" controls autoplay style="width:100%; height:auto; display:none;"></video>
		        
		        <!-- 🎯 [신규 추가] AI 바운딩 박스를 그릴 투명 캔버스 레이어 -->
		        <canvas id="aiOverlayCanvas" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 10;"></canvas>
		    </div>
		
		    <div id="modalNoStream" class="no-stream-msg" style="display:none;">연결된 드론 영상이 없습니다.</div>
		</div>
    </div>
</div>
    

</div>
<!-- adminMain.js 파일이 들어있는 정확한 경로로 지정 -->
<script src="${pageContext.request.contextPath}/resources/js/admin/adminMain.js"></script>

<!-- 1. Chart.js 외부 라이브러리 불러오기 (단독으로 닫아야 함) -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- 2. 실제 차트 및 데이터 로드 자바스크립트 로직 -->
<script>
//==========================================
//차트 인스턴스 전역 관리
//==========================================
window.densityChartInstance = window.densityChartInstance || null;
window.animalChartInstance = window.animalChartInstance || null;

//1. 실시간 인파 밀집도 차트 초기화
function initRealtimeDensityChart() {

	if (typeof Chart === 'undefined') {
        console.warn("[Chart Debug] Chart.js 라이브러리가 로드되지 않았습니다.");
        return false;
    }
	
 const canvas = document.getElementById('densityChart');
 if (!canvas) {
     console.warn("[Chart Debug] #densityChart Canvas 요소를 찾을 수 없습니다.");
     return false;
 }
 
 if (window.densityChartInstance) {
     window.densityChartInstance.destroy();
     window.densityChartInstance = null;
 }

 const ctx = canvas.getContext('2d');
 const initialData = Array(30).fill(0);
 const initialLabels = Array(30).fill('');

 window.densityChartInstance = new Chart(ctx, {
     type: 'line',
     data: {
         labels: initialLabels,
         datasets: [{
             label: '실시간 밀집 수위 (%)',
             data: initialData,
             borderColor: '#3b82f6',
             backgroundColor: 'rgba(59, 130, 246, 0.15)',
             borderWidth: 2,
             fill: true,
             tension: 0.4,
             pointRadius: 0
         }]
     },
     options: {
         responsive: true,
         maintainAspectRatio: false,
         animation: false,
         plugins: { legend: { display: false } },
         scales: {
             x: { display: false },
             y: { 
                 ticks: { color: '#888', font: { size: 10 } }, 
                 grid: { color: '#2b2b40' },
                 min: 0,
                 max: 100
             }
         }
     }
 });
 console.log("[Chart Debug] 밀집도 차트 초기화 완료");
 return true;
}

//2. 실시간 야생동물 AI 감지 신호 차트 초기화
function initRealtimeAnimalChart() {
	if (typeof Chart === 'undefined') {
        console.warn("[Chart Debug] Chart.js 라이브러리가 로드되지 않았습니다.");
        return false;
    }
	
 const canvas = document.getElementById('animalChart');
 if (!canvas) {
     console.warn("[Chart Debug] #animalChart Canvas 요소를 찾을 수 없습니다.");
     return false;
 }

 if (window.animalChartInstance) {
     window.animalChartInstance.destroy();
     window.animalChartInstance = null;
 }

 const ctx = canvas.getContext('2d');
 const initialLabels = Array(30).fill('');
 const initialGorani = Array(30).fill(0);
 const initialBoar = Array(30).fill(0);

 window.animalChartInstance = new Chart(ctx, {
     type: 'line',
     data: {
         labels: initialLabels,
         datasets: [
             {
                 label: '고라니 감지 신호 (%)',
                 data: initialGorani,
                 borderColor: '#a855f7',
                 backgroundColor: 'rgba(168, 85, 247, 0.12)',
                 borderWidth: 2,
                 fill: true,
                 tension: 0.4,
                 pointRadius: 0
             },
             {
                 label: '멧돼지 감지 신호 (%)',
                 data: initialBoar,
                 borderColor: '#f97316',
                 backgroundColor: 'rgba(249, 115, 22, 0.12)',
                 borderWidth: 2,
                 fill: true,
                 tension: 0.4,
                 pointRadius: 0
             }
         ]
     },
     options: {
         responsive: true,
         maintainAspectRatio: false,
         animation: false,
         plugins: {
             legend: {
                 display: true,
                 position: 'top',
                 align: 'end',
                 labels: {
                     color: '#ccc',
                     font: { size: 10 },
                     boxWidth: 10,
                     usePointStyle: true
                 }
             }
         },
         scales: {
             x: { display: false },
             y: { 
                 ticks: { 
                     color: '#888', 
                     font: { size: 10 },
                     callback: function(value) { return value + '%'; }
                 }, 
                 grid: { color: '#2b2b40' },
                 min: 0,
                 max: 100
             }
         }
     }
 });
 console.log("[Chart Debug] 동물 차트 초기화 완료");
 return true;
}

//💡 3. 밀집도 차트 갱신 함수 (평소 잔잔한 파동 + AI 연동 시 실제 수치 반영)
function updateDensityChart(densityVal) {
    if (!window.densityChartInstance) {
        var initialized = initRealtimeDensityChart();
        if (!initialized) return;
    }

    const chart = window.densityChartInstance;
    let val;

    // AI 감지 수치가 유효하면 실제 수치 사용, 없거나 0이면 평소 관제용 베이스라인(15~25%) 생성
    if (densityVal !== undefined && densityVal !== null && Number(densityVal) > 0) {
        val = Number(densityVal);
    } else {
        const lastVal = chart.data.datasets[0].data[chart.data.datasets[0].data.length - 1] || 18;
        const noise = (Math.random() - 0.5) * 4; // -2 ~ +2 변동
        val = Math.min(Math.max(Math.round(lastVal + noise), 12), 26);
    }

    chart.data.datasets[0].data.shift();
    chart.data.datasets[0].data.push(val);

    chart.update();
}

//💡 4. 야생동물 차트 갱신 함수 (평소 미세 신호 + AI 감지 시 튐 현상 연동)
function updateAnimalChart(boxes) {
    if (!window.animalChartInstance) {
        var initialized = initRealtimeAnimalChart();
        if (!initialized) return;
    }

    let goraniVal = 0;
    let boarVal = 0;

    if (boxes && Array.isArray(boxes) && boxes.length > 0) {
        boxes.forEach(function(item) {
            const label = String(item.label || '').toLowerCase();
            const confidencePercent = Number(item.confidence || 0) * 100;

            if (label.includes('gorani') || label.includes('고라니')) {
                goraniVal = Math.max(goraniVal, confidencePercent);
            } else if (label.includes('boar') || label.includes('멧돼지')) {
                boarVal = Math.max(boarVal, confidencePercent);
            }
        });
    }

    // 감지된 동물이 없을 때도 바닥에서 살짝 이퀄라이저처럼 다이나믹하게 움직임 (0~3% 미세 신호)
    if (goraniVal === 0) goraniVal = +(Math.random() * 3).toFixed(1);
    if (boarVal === 0) boarVal = +(Math.random() * 3).toFixed(1);

    const chart = window.animalChartInstance;
    
    chart.data.datasets[0].data.shift();
    chart.data.datasets[0].data.push(+goraniVal.toFixed(1));

    chart.data.datasets[1].data.shift();
    chart.data.datasets[1].data.push(+boarVal.toFixed(1));

    chart.update();
}

//💡 5. AI 감지 통신 함수
function captureAndSendAIFrame(mediaElement, droneId) {
 if (!mediaElement) return;

 var canvas = document.createElement('canvas');
 var ctx = canvas.getContext('2d');

 if (mediaElement.tagName === 'VIDEO') {
     if (mediaElement.paused || mediaElement.ended || !mediaElement.videoWidth) return;
     canvas.width = mediaElement.videoWidth;
     canvas.height = mediaElement.videoHeight;
     ctx.drawImage(mediaElement, 0, 0, canvas.width, canvas.height);
 } else if (mediaElement.tagName === 'IMG') {
     if (!mediaElement.complete || !mediaElement.naturalWidth) return;
     canvas.width = mediaElement.naturalWidth;
     canvas.height = mediaElement.naturalHeight;
     ctx.drawImage(mediaElement, 0, 0, canvas.width, canvas.height);
 } else {
     return;
 }

 canvas.toBlob(function(blob) {
     if (!blob) return;

     var formData = new FormData();
     formData.append("file", blob, "frame.jpg");
     formData.append("drone_id", droneId || "drone1");

     var contextPath = window.contextPath || '';

     $.ajax({
         url: contextPath + "/api/detectImage",
         type: "POST",
         data: formData,
         processData: false,
         contentType: false,
         success: function(res) {
             if (typeof res === 'string') {
                 try { res = JSON.parse(res); } catch (e) {}
             }

             // UI 텍스트 업데이트
             $('#modalPeopleCount').text((res.people_count || 0) + '명');
             $('#modalDensity').text((res.density_percent || 0) + '%');
             $('#modalDangerLevel').text(res.danger_level || '정상');

             // 🎯 차트 갱신 함수 호출
             updateDensityChart(res.density_percent);
             updateAnimalChart(res.boxes);
         }
     });
 }, "image/jpeg", 0.8);
}

//3. 최근 위험 이벤트 실시간 갱신 로직 (JSP EL 충돌 완벽 방지)
function initRealtimeEvents() {
    const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';

    function fetchRealtimeEvents() {
        const $targetList = $('.event-list');
        if ($targetList.length === 0) return;

        fetch(basePath + '/admin/fieldAction/api/list?statusType=PENDING')
            .then(res => res.json())
            .then(data => {
                if (!data || !Array.isArray(data) || data.length === 0) {
                    $targetList.html('<li class="event-item" style="justify-content: center; color: #a0aec0; padding: 20px 0;">현재 검토 대기 중인 위험 이벤트가 없습니다.</li>');
                    return;
                }

                const recentList = data.slice(0, 4);
                let html = '';

                recentList.forEach(item => {
                    // 1) 시각 파싱
                    const timeStr = formatEventTime(item.situDate || item.regDate);

                    // 2) 제출자 정제
                    let finder = '안전요원';
                    if (item.finder && item.finder !== 'null' && item.finder !== 'undefined' && item.finder !== 'false' && item.finder !== 'admin') {
                        finder = String(item.finder).trim();
                    }

                    // 3) 감지유형 정제
                    let situType = '자동감지';
                    if (item.situType && item.situType !== 'null' && item.situType !== 'undefined' && item.situType !== 'false') {
                        situType = String(item.situType).trim();
                    }

                    // 4) 위험유형 정제
                    let dngrType = '인파위험';
                    if (item.dngrType && item.dngrType !== 'null' && item.dngrType !== 'undefined' && item.dngrType !== 'false') {
                        dngrType = String(item.dngrType).trim();
                    }

                    // 🎯 5) [제출자 (감지유형)] 결합 (+ 연산자 사용으로 JSP 충돌 방지)
                    const descText = finder + ' (' + situType + ')';

                    // 6) 위험 유형 뱃지 색상
                    let levelClass = 'danger';
                    if (dngrType.includes('야생') || dngrType.includes('동물')) {
                        levelClass = 'warning';
                    } else if (dngrType.includes('혼잡') || dngrType.includes('주의')) {
                        levelClass = 'caution';
                    }

                    html += '<li class="event-item">' +
                                '<span class="event-time">' + timeStr + '</span>' +
                                '<span class="event-desc">' + descText + '</span>' +
                                '<span class="badge-tag ' + levelClass + '">' + dngrType + '</span>' +
                                '<span class="action-status">검토대기</span>' +
                            '</li>';
                });

                $targetList.html(html);
            })
            .catch(err => console.error('실시간 위험 이벤트 렌더링 에러:', err));
    }

    fetchRealtimeEvents();

    if (window.eventTimer) clearInterval(window.eventTimer);
    window.eventTimer = setInterval(fetchRealtimeEvents, 5000);
}

// 💡 시간 문자열/타임스탬프 파싱 보조 함수 (+ 연산자 방식 적용)
function formatEventTime(timeVal) {
    if (!timeVal || timeVal === 'null' || timeVal === 'undefined') return '00:00:00';

    const num = Number(timeVal);
    if (!isNaN(num) && num > 0) {
        const d = new Date(num);
        if (!isNaN(d.getTime())) {
            const hh = String(d.getHours()).padStart(2, '0');
            const mm = String(d.getMinutes()).padStart(2, '0');
            const ss = String(d.getSeconds()).padStart(2, '0');
            return hh + ':' + mm + ':' + ss;
        }
    }

    const str = String(timeVal).trim();
    if (str.includes(' ')) {
        const timePart = str.split(' ')[1];
        if (timePart) {
            const parts = timePart.split(':');
            const hh = (parts[0] || '00').padStart(2, '0');
            const mm = (parts[1] || '00').padStart(2, '0');
            const ss = (parts[2] || '00').padStart(2, '0');
            return hh + ':' + mm + ':' + ss;
        }
    }

    return '00:00:00';
}

// 4. 대시보드 실시간 실행 및 초기화
window.startRealtimeDashboard = function() {
    // 이전 인터벌 타이머 해제
    if (window.densityTimer) clearInterval(window.densityTimer);
    if (window.animalTimer) clearInterval(window.animalTimer);
    if (window.eventTimer) clearInterval(window.eventTimer);

    // 이전 차트 객체 제거
    if (window.densityChartInstance) { 
        window.densityChartInstance.destroy(); 
        window.densityChartInstance = null; 
    }
    if (window.animalChartInstance) { 
        window.animalChartInstance.destroy(); 
        window.animalChartInstance = null; 
    }
    
    // KPI 데이터를 서버에서 가져와 화면에 꽂아주는 통합 함수 작성
    window.initDashboardKPIs = function() {
        const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';
        
    
        // 긴급보고 점멸 및 카운트 갱신 함수가 있다면 여기서 함께 호출
        if (typeof updateEmergencyBlink === 'function') {
            updateEmergencyBlink();
        }
    };

    // 부모 wrapper 높이 지정
    $('.chart-wrapper').css({'position': 'relative', 'height': '200px', 'width': '100%'});

    if (typeof window.initDashboardKPIs === 'function') {
        window.initDashboardKPIs();
    }
    
    // 기능 순차 실행
    initRealtimeDensityChart();
    initRealtimeAnimalChart();
    initRealtimeEvents();
    

};

// 🚀 AJAX 삽입 후 HTML 렌더링 완료 시간을 위해 100ms 후 실행
setTimeout(function() {
    window.startRealtimeDashboard();
}, 100);


//💡 평소에도 차트가 1초마다 계속 움직이도록 만드는 배경 타이머
if (window.chartIdleTimer) clearInterval(window.chartIdleTimer);

window.chartIdleTimer = setInterval(function() {
    if (typeof updateDensityChart === 'function') updateDensityChart(null);
    if (typeof updateAnimalChart === 'function') updateAnimalChart([]);
}, 1000);



//🎯 메인 대시보드 파일(adminMainContent.jsp 또는 메인 JS) 하단에 추가/수정

// 1. 대시보드 데이터 전체를 불러오는 전역 함수 정의
    window.initMainPage = function() {
        console.log("🚀 대시보드 DB 데이터 재조회 시작");

        // ① KPI 데이터(신규 점검, 긴급보고, 요원 수, 드론 수) 조회 AJAX/Fetch 호출
        // (기존에 작성되어 있던 KPI 데이터 조회 함수나 AJAX 구문 실행)
        if (typeof updateEmergencyBlink === 'function') {
            updateEmergencyBlink();
        }
        
        // ② 실시간 위험 이벤트 목록 조회
        if (typeof initRealtimeEvents === 'function') {
            initRealtimeEvents();
        }

        // ③ 차트 및 기타 실시간 로직 초기화
        if (typeof initRealtimeDensityChart === 'function') {
            initRealtimeDensityChart();
        }
        if (typeof initRealtimeAnimalChart === 'function') {
            initRealtimeAnimalChart();
        }
        
     // KPI 숫자 카운팅 애니메이션 실행 함수
        function animateKpiCounters() {
            $('.counter').each(function() {
                const $this = $(this);
                const targetValue = parseInt($this.attr('data-target'), 10) || 0;

                $({ countNum: 0 }).animate({ countNum: targetValue }, {
                    duration: 900, // 0.9초 동안 카운트업
                    easing: 'swing',
                    step: function() {
                        $this.text(Math.floor(this.countNum));
                    },
                    complete: function() {
                        $this.text(this.countNum);
                    }
                });
            });
        }

        // 메인 페이지 로드 시 카운팅 실행
        $(document).ready(function() {
            animateKpiCounters();
        });
    };

    // 2. $(document).ready()를 쓰지 않고, 스크립트가 로드되는 즉시 함수 실행!
    //    (이렇게 하면 F5 새로고침 때도 실행되고, AJAX 비동기 이동 때도 100% 즉시 실행됩니다.)
    window.initMainPage();
    
    
    
    
    /**
     * 실시간 관제 터미널 콘솔 스크립트 (점멸/깜빡임 완벽 해결 버전)
     */
    (function initTerminalLog() {
        const logList = document.getElementById('terminalLogList');
        const logContainer = document.getElementById('terminalLogContainer');
        const typeSelect = document.getElementById('terminalTypeSelect');
        const searchInput = document.getElementById('terminalSearchInput');
        const topIndicator = document.getElementById('terminalScrollTopIndicator');
        const bottomIndicator = document.getElementById('terminalScrollBottomIndicator');
        
        if (!logList || !logContainer) return;

        const MAX_LOG_COUNT = 100;
        const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';
        const STORAGE_KEY = 'admin_terminal_logs';
        
        let activeEventSource = null;
        let allLogs = []; // 전체 로그 객체 배열 { type, message, timeStr }

        // 🎯 [1] 스크롤 위치 감지 (위/아래 알림 배지 토글)
        function updateScrollIndicators() {
            const scrollTop = logContainer.scrollTop;
            const scrollHeight = logContainer.scrollHeight;
            const clientHeight = logContainer.clientHeight;

            topIndicator.style.display = (scrollTop > 10) ? 'block' : 'none';
            bottomIndicator.style.display = (scrollTop + clientHeight < scrollHeight - 10) ? 'block' : 'none';
        }

        logContainer.addEventListener('scroll', updateScrollIndicators);

        // 🎯 [2] 필터 조건 충족 여부 검사
        function isMatchFilter(item, selectedType, keyword) {
            const matchType = (selectedType === 'ALL') || (item.type === selectedType);
            const matchKey = (keyword === '') || (item.message.toLowerCase().includes(keyword));
            return matchType && matchKey;
        }

        // 🎯 [3] 단일 로그 DOM 생성 및 append 전용 함수 (깜빡임 방지 핵심!)
        function appendSingleLogDOM(item) {
            let tagClass = 'info';
            let tagText = 'SYSTEM';

            switch(item.type) {
                case 'WARN':   tagClass = 'warn';   tagText = 'CAUTION'; break;
                case 'DANGER': tagClass = 'danger'; tagText = 'ALERT'; break;
                case 'ACTION': tagClass = 'action'; tagText = 'ACTION'; break;
                default:       tagClass = 'info';   tagText = 'INFO'; break;
            }

            const li = document.createElement('li');
            li.className = 'log-item';
            li.innerHTML = '<span class="log-time">' + item.timeStr + '</span>' +
                           '<span class="log-tag ' + tagClass + '">' + tagText + '</span>' +
                           '<span class="log-text">' + item.message + '</span>';

            logList.appendChild(li);

            // 표시 노드 수가 초과되면 맨 위 노드 1개만 깔끔하게 제거
            if (logList.children.length > MAX_LOG_COUNT) {
                logList.removeChild(logList.firstElementChild);
            }
        }

        // 🎯 [4] 화면 전체 재렌더링 (검색어/유형 변경시에만 호출됨)
        function renderFilteredLogs() {
            logList.innerHTML = ''; // 필터링 시에만 화면 비움
            
            const selectedType = typeSelect ? typeSelect.value : 'ALL';
            const keyword = searchInput ? searchInput.value.trim().toLowerCase() : '';

            allLogs.forEach(function(item) {
                if (isMatchFilter(item, selectedType, keyword)) {
                    appendSingleLogDOM(item);
                }
            });

            updateScrollIndicators();
        }

        // 필터/검색 변경 이벤트 연결
        if (typeSelect) typeSelect.addEventListener('change', renderFilteredLogs);
        if (searchInput) searchInput.addEventListener('input', renderFilteredLogs);

        // 🎯 [5] 실시간 새 로그 추가 (전체 재렌더링 없이 1개만 살짝 추가 -> 점멸 해제)
        function addNewLog(type, message, timeStr) {
            const logObj = { type: type, message: message, timeStr: timeStr };
            allLogs.push(logObj);

            if (allLogs.length > MAX_LOG_COUNT) {
                allLogs.shift();
            }

            // sessionStorage 업데이트
            try {
                sessionStorage.setItem(STORAGE_KEY, JSON.stringify(allLogs));
            } catch (e) {}

            // 현재 선택된 필터/검색어에 맞는 경우에만 단일 DOM 추가
            const selectedType = typeSelect ? typeSelect.value : 'ALL';
            const keyword = searchInput ? searchInput.value.trim().toLowerCase() : '';

            if (isMatchFilter(logObj, selectedType, keyword)) {
                appendSingleLogDOM(logObj);
                updateScrollIndicators();
                // 새 로그 추가 시 하단 스크롤 이동
                logContainer.scrollTop = logContainer.scrollHeight;
            }
        }

        // 🎯 [6] 이전 저장된 로그 복원
        function loadSavedLogs() {
            try {
                const saved = sessionStorage.getItem(STORAGE_KEY);
                if (saved) {
                    allLogs = JSON.parse(saved);
                    renderFilteredLogs();
                    logContainer.scrollTop = logContainer.scrollHeight;
                } else {
                    window.addTerminalLog('INFO', '관제 터미널 스트리밍 엔진 시작...');
                }
            } catch (e) {
                window.addTerminalLog('INFO', '관제 터미널 스트리밍 엔진 시작...');
            }
        }

        // 외부 전역 함수 등록
        window.addTerminalLog = function(type, message) {
            const now = new Date();
            const hh = String(now.getHours()).padStart(2, '0');
            const mm = String(now.getMinutes()).padStart(2, '0');
            const ss = String(now.getSeconds()).padStart(2, '0');
            const timeStr = '[' + hh + ':' + mm + ':' + ss + ']';

            addNewLog(type, message, timeStr);
        };

        // SSE 데이터 스트림 연결
        function connectSseStream() {
            if (activeEventSource) {
                activeEventSource.close();
                activeEventSource = null;
            }

            const sseUrl = basePath + '/api/sse/subscribe';
            const eventSource = new EventSource(sseUrl);
            activeEventSource = eventSource;

            eventSource.addEventListener('terminal-log', function(e) {
                try {
                    const data = JSON.parse(e.data);
                    window.addTerminalLog(data.type || 'INFO', data.message || '');
                } catch (err) {}
            });

            eventSource.addEventListener('situation-report', function(e) {
                try {
                    const data = JSON.parse(e.data);
                    const msg = '[긴급보고] ' + (data.situContent || '현장 긴급 상황이 접수되었습니다.');
                    window.addTerminalLog('DANGER', msg);
                } catch (err) {}
            });

            eventSource.addEventListener('situation-alert', function(e) {
                try {
                    const data = JSON.parse(e.data);
                    const dngrType = data.dngrType || '위험';
                    const msg = '[' + dngrType + '] ' + (data.situContent || '새로운 위험 요소가 감지되었습니다.');
                    window.addTerminalLog('WARN', msg);
                } catch (err) {}
            });

            eventSource.addEventListener('situation-update', function(e) {
                try {
                    const data = JSON.parse(e.data);
                    const msg = '상황 정보 업데이트 (요청No.' + (data.situNo || '-') + ')';
                    window.addTerminalLog('INFO', msg);
                } catch (err) {}
            });

            eventSource.onerror = function() {
                eventSource.close();
                activeEventSource = null;
                setTimeout(connectSseStream, 5000);
            };
        }

        window.closeTerminalSse = function() {
            if (activeEventSource) {
                activeEventSource.close();
                activeEventSource = null;
            }
        };

        window.addEventListener('beforeunload', window.closeTerminalSse);
        window.addEventListener('pagehide', window.closeTerminalSse);

        loadSavedLogs();
        connectSseStream();
    })();
    
</script>




<script>
    // adminMain.jsp HTML이 비동기로 꽂히는 즉시 지도 초기화 실행
    setTimeout(function() {
        if (typeof window.initAdminMainMap === 'function') {
            window.initAdminMainMap();
        }
    }, 50);
</script>
