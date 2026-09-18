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
                <span class="kpi-value warning">0</span><span class="kpi-unit">개</span>
            </div>
            <div class="kpi-sub diff-up"></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">야생동물 위험</div>
            <div class="kpi-value-group">
                <span class="kpi-value warning">0</span><span class="kpi-unit">건</span>
            </div>
            <div class="kpi-sub diff-up"></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">근무중 안전요원</div>
            <div class="kpi-value-group">
                <span class="kpi-value primary"></span><span class="kpi-unit">명</span>
            </div>
            <div class="kpi-sub status-ok">(!연동됨)</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">비행중 드론</div>
            <div class="kpi-value-group">
                <span class="kpi-value primary">0</span><span class="kpi-unit">대</span>
            </div>
            <div class="kpi-sub status-ok">(!연동됨)</div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">미확인 긴급보고</div>
            <div class="kpi-value-group">
                <span class="kpi-value danger">0</span><span class="kpi-unit">건</span>
            </div>
            <div class="kpi-sub diff-up"></div>
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

// 3. 최근 위험 이벤트 실시간 갱신 로직
function initRealtimeEvents() {
    const $eventList = $('.event-list');
    if ($eventList.length === 0) return;

    const zones = ['푸드존', '메인 무대', '산책로 A구역', '동문 입구', '주차장 B구역', '체험 부스'];
    const dngrTypes = ['인파 밀집', '멧돼지 출현', '고라니 포착', '동선 혼잡', '안전펜스 충돌'];
    const levels = [
        { text: '위험', class: 'danger' },
        { text: '경계', class: 'warning' },
        { text: '주의', class: 'caution' }
    ];
    const statuses = [
        { text: '처리중', class: '' },
        { text: '출동', class: '' },
        { text: '완료', class: 'done' }
    ];

    // window.eventTimer에 타이머 ID 저장
    window.eventTimer = setInterval(function() {
        const now = new Date();
        const timeStr = String(now.getHours()).padStart(2, '0') + ':' + 
                        String(now.getMinutes()).padStart(2, '0') + ':' + 
                        String(now.getSeconds()).padStart(2, '0');

        const randZone = zones[Math.floor(Math.random() * zones.length)];
        const randType = dngrTypes[Math.floor(Math.random() * dngrTypes.length)];
        const randLevel = levels[Math.floor(Math.random() * levels.length)];
        const randStatus = statuses[Math.floor(Math.random() * statuses.length)];

        const newHtml = '<li class="event-item" style="display:none;">' +
                            '<span class="event-time">' + timeStr + '</span>' +
                            '<span class="event-desc">' + randZone + ' ' + randType + '</span>' +
                            '<span class="badge-tag ' + randLevel.class + '">' + randLevel.text + '</span>' +
                            '<span class="action-status ' + randStatus.class + '">' + randStatus.text + '</span>' +
                        '</li>';

        $eventList.prepend(newHtml);
        $eventList.find('li:first').slideDown(300);

        if ($eventList.find('li').length > 4) {
            $eventList.find('li:last').remove();
        }
    }, 7000);
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

    // 부모 wrapper 높이 지정
    $('.chart-wrapper').css({'position': 'relative', 'height': '200px', 'width': '100%'});

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
</style>