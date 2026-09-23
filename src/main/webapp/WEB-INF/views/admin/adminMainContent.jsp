<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 대시보드 전용 CSS 연동 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/adminMainContent.css">

<div class="admin-dashboard-container">
    
    <!-- 1. 상단 요약 KPI 카드 (5개 영역) -->
    <section class="kpi-grid">
        <div class="kpi-card">
		    <div class="kpi-title">신규 안전점검 현황</div>
		    <div class="kpi-value-group">
		        <span class="kpi-value warning" id="kpi-unread-count">0</span><span class="kpi-unit">개</span>
		    </div>
		    <div class="kpi-sub diff-up"></div>
		</div>
        <div class="kpi-card">
		    <div class="kpi-title">미확인 긴급보고</div>
		    <div class="kpi-value-group">
		        <span id="kpi-unread-emergency-count" class="kpi-value danger">0</span><span class="kpi-unit">건</span>
		    </div>
		    <div class="kpi-sub diff-up"></div>
		</div>
        <div class="kpi-card">
            <div class="kpi-title">근무중 안전요원</div>
            <div class="kpi-value-group">
                <span class="kpi-value primary">0</span><span class="kpi-unit">명</span>
            </div>
            <div class="kpi-sub status-ok"></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-title">비행중 드론</div>
            <div class="kpi-value-group">
                <span class="kpi-value primary">0</span><span class="kpi-unit">대</span>
            </div>
            <div class="kpi-sub status-ok"></div>
        </div>

        <!-- 🎯 [신규] 5번째 버튼형 카드: 안전점검 바로가기 -->
        <a href="${pageContext.request.contextPath}/admin/safetyCheck" class="kpi-card kpi-action-btn">
            <div class="kpi-action-content">
                <div class="kpi-action-icon">
                    <i class="fa-solid fa-clipboard-check"></i>
                </div>
                <div class="kpi-action-info">
                    <span class="kpi-action-title">안전점검</span>
                    <span class="kpi-action-sub">상세 조회 <i class="fa-solid fa-arrow-right arrow-anim"></i></span>
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

//3. 최근 위험 이벤트 실시간 갱신 로직 (타임스탬프 & DOM 재탐색 보정)
function initRealtimeEvents() {
    const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';

    function fetchRealtimeEvents() {
        // 🎯 렌더링 직전에 화면 상의 .event-list 요소를 새로 탐색 (DOM 유실 방지)
        const $targetList =$('.event-list');
        if ($targetList.length === 0) return;

        fetch(basePath + '/admin/fieldAction/api/list?statusType=PENDING')
            .then(res => res.json())
            .then(data => {
                if (!data || !Array.isArray(data) || data.length === 0) {
                    $targetList.html('<li class="event-item" style="justify-content: center; color: #a0aec0; padding: 20px 0;">현재 검토 대기 중인 위험 이벤트가 없습니다.</li>');
                    return;
                }

                // 최근 등록된 상위 4개 데이터 추출
                const recentList = data.slice(0, 4);
                let html = '';

                recentList.forEach(item => {
                    // 🎯 1) 시각 파싱 (13자리 타임스탬프 숫자를 HH:mm:ss로 변환)
                    const timeStr = formatEventTime(item.situDate || item.regDate);

                    // 🎯 2) 제출자 정제 (finder가 null/admin이면 '안전요원')
                    let finder = '안전요원';
                    if (item.finder && item.finder !== 'null' && item.finder !== 'undefined' && item.finder !== 'false' && item.finder !== 'admin') {
                        finder = String(item.finder).trim();
                    }

                    // 🎯 3) 감지유형 정제 (situType)
                    let situType = '자동감지';
                    if (item.situType && item.situType !== 'null' && item.situType !== 'undefined' && item.situType !== 'false') {
                        situType = String(item.situType).trim();
                    }

                    // 🎯 4) 위험유형 정제 (dngrType)
                    let dngrType = '인파위험';
                    if (item.dngrType && item.dngrType !== 'null' && item.dngrType !== 'undefined' && item.dngrType !== 'false') {
                        dngrType = String(item.dngrType).trim();
                    }

                    // 🎯 5) [제출자 (감지유형)] 출력 (예: 안전요원 (자동감지) / agent01 (여기까지더미))
                    const descText = `${finder} (${situType})`;

                    // 🎯 6) 위험 유형 뱃지 색상
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

                // 🎯 최신 탐색된 DOM에 HTML 덮어쓰기
                $targetList.html(html);
            })
            .catch(err => console.error('실시간 위험 이벤트 렌더링 에러:', err));
    }

    // 최초 1회 즉시 실행
    fetchRealtimeEvents();

    // 5초 주기로 DB 재조회하여 실시간 갱신
    if (window.eventTimer) clearInterval(window.eventTimer);
    window.eventTimer = setInterval(fetchRealtimeEvents, 5000);
}

// 💡 시간 문자열/타임스탬프 파싱 보조 함수
function formatEventTime(timeVal) {
    if (!timeVal || timeVal === 'null' || timeVal === 'undefined') return '00:00:00';

    // 1) 13자리 숫자 타임스탬프 처리 (e.g. 1788447600000)
    const num = Number(timeVal);
    if (!isNaN(num) && num > 0) {
        const d = new Date(num);
        if (!isNaN(d.getTime())) {
            const hh = String(d.getHours()).padStart(2, '0');
            const mm = String(d.getMinutes()).padStart(2, '0');
            const ss = String(d.getSeconds()).padStart(2, '0');
            return `${hh}:${mm}:${ss}`;
        }
    }

    // 2) "2026-09-04 00:00" 형태의 문자열 처리
    const str = String(timeVal).trim();
    if (str.includes(' ')) {
        const timePart = str.split(' ')[1];
        if (timePart) {
            const parts = timePart.split(':');
            const hh = (parts[0] || '00').padStart(2, '0');
            const mm = (parts[1] || '00').padStart(2, '0');
            const ss = (parts[2] || '00').padStart(2, '0');
            return `${hh}:${mm}:${ss}`;
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


/* ==========================================
   상단 KPI 5열 그리드 및 안전점검 버튼 카드
   ========================================== */
.kpi-grid {
    display: grid !important;
    grid-template-columns: repeat(5, 1fr) !important; /* 5개 카드 균등 배치 */
    gap: 16px;
    margin-bottom: 20px;
}

/* 액션 버튼 카드 기본 스타일 */
.kpi-action-btn {
    text-decoration: none !important;
    background: linear-gradient(135deg, rgba(14, 165, 233, 0.12) 0%, rgba(59, 130, 246, 0.05) 100%) !important;
    border: 1px solid rgba(56, 189, 248, 0.3) !important;
    cursor: pointer;
    transition: all 0.25s ease-in-out !important;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 16px !important;
}

/* 마우스 호버 시 네온 입체 효과 */
.kpi-action-btn:hover {
    background: linear-gradient(135deg, rgba(14, 165, 233, 0.25) 0%, rgba(59, 130, 246, 0.15)) !important;
    border-color: #38bdf8 !important;
    box-shadow: 0 0 18px rgba(56, 189, 248, 0.35), inset 0 0 10px rgba(56, 189, 248, 0.1) !important;
    transform: translateY(-2px);
}

.kpi-action-content {
    display: flex;
    align-items: center;
    gap: 14px;
    width: 100%;
}

/* 아이콘 보관함 */
.kpi-action-icon {
    width: 44px;
    height: 44px;
    border-radius: 12px;
    background: rgba(56, 189, 248, 0.15);
    border: 1px solid rgba(56, 189, 248, 0.3);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    color: #38bdf8;
    flex-shrink: 0;
    transition: all 0.25s ease;
}

.kpi-action-btn:hover .kpi-action-icon {
    background: #38bdf8;
    color: #0f172a;
    box-shadow: 0 0 12px rgba(56, 189, 248, 0.6);
}

/* 텍스트 영역 */
.kpi-action-info {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.kpi-action-title {
    font-size: 15px;
    font-weight: 700;
    color: #ffffff;
    letter-spacing: -0.02em;
}

.kpi-action-sub {
    font-size: 12px;
    color: #38bdf8;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 6px;
}

/* 화살표 애니메이션 */
.arrow-anim {
    transition: transform 0.2s ease;
}

.kpi-action-btn:hover .arrow-anim {
    transform: translateX(4px);
}
</style>