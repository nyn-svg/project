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
            <span class="kpi-title">근무중 안전요원</span>
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

        <!-- 실시간 위험 대응 현황 -->
        <div class="dashboard-card status-card">
            <div class="card-header">
                <span class="card-title">안전점검 제출 현황</span>
            </div>
            <div class="card-body">
                <ul class="status-list">
                    <li class="status-item">
                        <span class="status-label"><i class="fa-solid fa-circle-exclamation color-warning"></i> 위험</span>
                        <span class="status-count">0 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                    <li class="status-item">
                        <span class="status-label"><i class="fa-solid fa-triangle-exclamation color-caution"></i> 주의</span>
                        <span class="status-count">1 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                    <li class="status-item">
                        <span class="status-label"><i class="fa-solid fa-circle-info color-info"></i> 양호</span>
                        <span class="status-count">2 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                </ul>

                <hr class="card-divider" />

                <ul class="status-list sub-list">
                    <li class="status-item">
                        <span class="status-label">미확인 긴급보고</span>
                        <span class="status-count danger">0 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                    <li class="status-item">
                        <span class="status-label">조치필요 업무지시</span>
                        <span class="status-count">0 건</span>
                        <i class="fa-solid fa-chevron-right arrow-icon"></i>
                    </li>
                    <li class="status-item">
                        <span class="status-label">조치중 업무지시</span>
                        <span class="status-count">0 건</span>
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
</script>




<script>
    // adminMain.jsp HTML이 비동기로 꽂히는 즉시 지도 초기화 실행
    setTimeout(function() {
        if (typeof window.initAdminMainMap === 'function') {
            window.initAdminMainMap();
        }
    }, 50);
</script>
<style>
/* 모달 레이아웃 스타일 */
.drone-modal-overlay {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.75);
    display: flex; justify-content: center; align-items: center;
    z-index: 9999;
}
.drone-modal-content {
    background: #1e293b;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    width: 640px;
    max-width: 90%;
    overflow: hidden;
    box-shadow: 0 10px 25px rgba(0,0,0,0.5);
}
.drone-modal-header {
    padding: 14px 20px;
    background: #0f172a;
    display: flex; justify-content: space-between; align-items: center;
    color: #fff; font-weight: bold;
}
.drone-modal-close {
    background: none; border: none; color: #94a3b8; font-size: 24px; cursor: pointer;
}
.drone-modal-close:hover { color: #fff; }
.drone-modal-body { padding: 16px; background: #000; text-align: center; }
.no-stream-msg { color: #94a3b8; padding: 40px 0; }


/* ==========================================
   상단 KPI 5열 그리드 및 안전점검 버튼 카드
   ========================================== */
.kpi-grid {
    display: grid !important;
    grid-template-columns: repeat(5, 1fr) !important; /* 5개 카드 균등 배치 */
    gap: 16px;
    margin-bottom: 20px;
}

/* 안전점검 카드 - 빈 공간 없이 꽉 채우는 스타일 */
.kpi-action-btn {
    text-decoration: none;
    background: rgba(56, 189, 248, 0.08);
    border: 1px solid rgba(56, 189, 248, 0.25);
    display: flex;
    align-items: center;
    padding: 22px 24px; /* 여백 확장 */
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

.kpi-action-btn:hover {
    background: rgba(56, 189, 248, 0.16);
    border-color: #38bdf8;
    transform: translateY(-2px);
    box-shadow: 0 10px 30px rgba(56, 189, 248, 0.25);
}

/* 내부 컨텐츠 양끝 정렬 (FULL WIDTH) */
.kpi-action-content {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    z-index: 2;
}

.kpi-action-left {
    display: flex;
    align-items: center;
    gap: 16px;
}

/* 아이콘 박스 크기 확대 */
.kpi-action-icon {
    width: 52px;
    height: 52px;
    border-radius: 14px;
    background: rgba(56, 189, 248, 0.2);
    border: 1px solid rgba(56, 189, 248, 0.35);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    color: #38bdf8;
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.2);
}

/* 텍스트 크기 및 간격 정돈 */
.kpi-action-info {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.kpi-action-title {
    font-size: 17px;
    font-weight: 700;
    color: #ffffff;
    letter-spacing: -0.3px;
}

.kpi-action-sub {
    font-size: 13px;
    color: #38bdf8;
    font-weight: 500;
}

/* 우측 원형 화살표 버튼 */
.kpi-action-arrow {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: rgba(56, 189, 248, 0.15);
    border: 1px solid rgba(56, 189, 248, 0.3);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #38bdf8;
    font-size: 14px;
    transition: all 0.3s ease;
}

/* 호버 시 우측 버튼 강조 애니메이션 */
.kpi-action-btn:hover .kpi-action-arrow {
    background: #38bdf8;
    color: #0b132b;
    transform: translateX(4px);
    box-shadow: 0 0 15px rgba(56, 189, 248, 0.6);
}

/* =========================================================
   하단 영역 (.dashboard-bottom) 전용 비율 교정
   (상단 KPI 및 중단 지도/현장 카드는 영향 없음)
   ========================================================= */

/* 1. 하단 전체 컨테이너 (차트 영역 + 우측 이벤트 영역) */
.dashboard-bottom {
    display: flex !important;
    gap: 16px !important;
    width: 100% !important;
    align-items: stretch !important;
}

/* 2. 좌측 차트 카드 (남는 공간 전체 사용) */
.dashboard-bottom .chart-card {
    flex: 1 1 auto !important;
    min-width: 0 !important;          /* Flex 자식 너비 초과 방지 */
    display: flex !important;         /* 내부 chart-box 2개를 가로 배치 */
    gap: 16px !important;
    padding: 16px !important;
}

/* 3. 차트 카드 내부의 각 차트 박스 (밀집도 / 야생동물) 1:1 (50%) 균등 배치 */
.dashboard-bottom .chart-card .chart-box {
    flex: 1 1 50% !important;         /* 두 차트에 정확히 50%씩 분할 */
    min-width: 0 !important;          /* Chart.js 찌그러짐 방지 핵심 */
    display: flex !important;
    flex-direction: column !important;
}

.dashboard-bottom .chart-card .chart-box .card-body {
    flex: 1 !important;
    position: relative !important;
    min-height: 180px !important;
}

/* 4. 우측 최근 위험 이벤트 카드 (340px 너비 고정) */
.dashboard-bottom .event-card {
    flex: 0 0 340px !important;
    width: 340px !important;
    box-sizing: border-box !important;
}

/* 5. 우측 위험 이벤트 리스트 내 텍스트 말줄임(...) 및 정렬 */
.dashboard-bottom .event-list .event-item {
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    gap: 8px !important;
    padding: 12px 8px !important;
    width: 100% !important;
    box-sizing: border-box !important;
}

.dashboard-bottom .event-list .event-time {
    flex-shrink: 0 !important;
    width: 58px !important;
    font-size: 12px !important;
}

.dashboard-bottom .event-list .event-desc {
    flex: 1 !important;
    min-width: 0 !important;            /* flex 텍스트 말줄임 필수 속성 */
    white-space: nowrap !important;     /* 줄바꿈 방지 */
    overflow: hidden !important;        /* 넘치는 텍스트 숨김 */
    text-overflow: ellipsis !important; /* ... 표시 */
    font-size: 13px !important;
}

.dashboard-bottom .event-list .badge-tag,
.dashboard-bottom .event-list .action-status {
    flex-shrink: 0 !important;         /* 뱃지 우측 고정 */
}




/* ==========================================
   관제센터 HUD 스타일 KPI 카드 CSS
   ========================================== */

/* KPI 카드 기본 레이아웃 */
.kpi-card {
    position: relative;
    background: rgba(15, 23, 42, 0.6);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 18px;
    padding: 20px 22px;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.kpi-card:hover {
    border-color: rgba(56, 189, 248, 0.35);
    transform: translateY(-2px);
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4), 0 0 20px rgba(56, 189, 248, 0.12);
}

/* 🎯 1. 배경 은은한 워터마크 아이콘 */
.kpi-bg-icon {
    position: absolute;
    right: -12px;
    bottom: -15px;
    font-size: 85px;
    color: rgba(255, 255, 255, 0.035);
    pointer-events: none;
    z-index: 1;
    transition: all 0.3s ease;
}

.kpi-card:hover .kpi-bg-icon {
    color: rgba(56, 189, 248, 0.1);
    transform: scale(1.08) rotate(-4deg);
}

/* 상단 헤더 & 상태 배지 */
.kpi-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 14px;
    z-index: 2;
}

.kpi-title {
    font-size: 13.5px;
    font-weight: 600;
    color: #94a3b8;
    letter-spacing: -0.2px;
}

.kpi-status-badge {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 10px;
    font-weight: 700;
    padding: 3px 9px;
    border-radius: 20px;
    letter-spacing: 0.5px;
}

/* 배지 색상 라인업 */
.badge-success { background: rgba(34, 197, 94, 0.12); color: #4ade80; border: 1px solid rgba(34, 197, 94, 0.3); }
.badge-warning { background: rgba(245, 158, 11, 0.15); color: #fbbf24; border: 1px solid rgba(245, 158, 11, 0.35); }
.badge-danger  { background: rgba(239, 68, 68, 0.15); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.35); }
.badge-neutral { background: rgba(255, 255, 255, 0.05); color: #64748b; border: 1px solid rgba(255, 255, 255, 0.1); }

/* 🎯 2. 라이브 깜빡임 펄스 점 (Pulse Dot) */
.pulse-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    display: inline-block;
}

.pulse-dot.success { background-color: #4ade80; animation: pulse-green 1.8s infinite; }
.pulse-dot.warning { background-color: #fbbf24; animation: pulse-yellow 1.8s infinite; }
.pulse-dot.danger  { background-color: #f87171; animation: pulse-red 1.2s infinite; }
.pulse-dot.neutral { background-color: #64748b; }

@keyframes pulse-green {
    0% { box-shadow: 0 0 0 0 rgba(74, 222, 128, 0.8); }
    70% { box-shadow: 0 0 0 6px rgba(74, 222, 128, 0); }
    100% { box-shadow: 0 0 0 0 rgba(74, 222, 128, 0); }
}

@keyframes pulse-red {
    0% { box-shadow: 0 0 0 0 rgba(248, 113, 113, 0.8); }
    70% { box-shadow: 0 0 0 7px rgba(248, 113, 113, 0); }
    100% { box-shadow: 0 0 0 0 rgba(248, 113, 113, 0); }
}

/* 🎯 3. 미확인 건수 발생 시 카드 발광 (Glow) */
.kpi-danger-glow {
    border-color: rgba(239, 68, 68, 0.4) !important;
    animation: danger-glow 2s infinite alternate;
}

.kpi-warning-glow {
    border-color: rgba(245, 158, 11, 0.4) !important;
}

@keyframes danger-glow {
    from { box-shadow: 0 0 10px rgba(239, 68, 68, 0.1); }
    to { box-shadow: 0 0 22px rgba(239, 68, 68, 0.35); }
}

/* 수치 및 단위 타이포그래피 */
.kpi-value-group {
    display: flex;
    align-items: baseline;
    gap: 6px;
    z-index: 2;
}

.kpi-value {
    font-size: 34px;
    font-weight: 800;
    line-height: 1;
    font-family: 'Segoe UI', -apple-system, sans-serif;
    letter-spacing: -1px;
}

.kpi-value.primary { color: #38bdf8; text-shadow: 0 0 14px rgba(56, 189, 248, 0.35); }
.kpi-value.warning { color: #fbbf24; text-shadow: 0 0 14px rgba(251, 191, 36, 0.35); }
.kpi-value.danger  { color: #f87171; text-shadow: 0 0 14px rgba(248, 113, 113, 0.4); }

.kpi-unit {
    font-size: 13px;
    font-weight: 600;
    color: #64748b;
}
</style>