<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
/* 실시간 관제 컨테이너 */
.realtime-container {
    padding: 24px;
    box-sizing: border-box;
    width: 100%;
}

/* 상단 헤더 영역 */
.realtime-header {
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.realtime-title {
    font-size: 20px;
    font-weight: 700;
    color: #ffffff;
    display: flex;
    align-items: center;
    gap: 8px;
}

.drone-count-badge {
    font-size: 14px;
    background: rgba(99, 102, 241, 0.2);
    color: #818cf8;
    border: 1px solid rgba(99, 102, 241, 0.4);
    padding: 4px 12px;
    border-radius: 20px;
}

/* 동적 그리드 레이아웃 (가로 4칸 고정, 세로는 자동 추가) */
.drone-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;                            /* 카드 간격 */
    width: 100%;                          /* 전체 너비 채우기 */
    padding: 10px;
    box-sizing: border-box;
}

/* 드론 스트리밍 카드 */
.drone-card {
    display: flex;
    flex-direction: column;
    width: 100%;
    background-color: rgba(20, 30, 50, 0.6);
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
}

/* 비디오 상단 정보 바 */
.drone-card-header {
    padding: 10px 14px;
    background: rgba(15, 23, 42, 0.6);
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.drone-name {
    font-size: 13px;
    font-weight: 600;
    color: #e2e8f0;
}

.drone-status {
	font-size: 12px;
	color: #94a3b8;
}
.drone-status.ready  { color: #0ea5e9; }
.drone-status.flying { color: #22c55e; }
.drone-status.error { color: #ef4444; }

/* 영상 출력 영역 */
.video-wrapper {
    position: relative;
    width: 100%;
    /* 16:9 비율 유지 (필요에 따라 height를 직접 지정해도 됩니다) */
    aspect-ratio: 16 / 9; 
    background-color: #000;
}

.video-wrapper img {
    width: 100%;
    height: 100%;
    object-fit: cover; /* 영역에 여백 없이 꽉 채우기 (비율을 맞추려면 contain 사용) */
    display: block;
}
.video-wrapper video {
    width: 100%;
    height: 100%;
    object-fit: cover; /* 영역에 여백 없이 꽉 채우기 (비율을 맞추려면 contain 사용) */
    display: block;
}

/* 안내 문구 공통 레이아웃 */
.drone-notice {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    gap: 8px;
    font-size: 13px;
    font-weight: 600;
}
.drone-notice.error { color: #f87171; }
.drone-notice.warning { color: #fcd34d; }
.drone-notice.ready { color: #38bdf8; }
</style>

<div class="realtime-container">
    <div class="realtime-header">
        <div class="realtime-title">
            <span>실시간 드론 관제</span>
            <span class="drone-count-badge">총 드론: <span id="droneCount">0</span>대</span>
        </div>
    </div>

    <!-- 드론 추가 시 동적으로 카드가 생성되는 영역 -->
    <div class="drone-grid" id="droneGrid">
        <!-- 스크립트를 통해 카드 요소가 동적으로 생성됩니다. -->
    </div>
</div>

<script>
$(document).ready(function() {
    var ctx = window.contextPath || '';

 	// 1. [공통] 상태별 안내 HTML 생성 함수 ('warning' 명칭으로 통일)
    function getNoticeHtml(status) {
        if (status === '고장' || status === 'error') {
            // [빨간색] DB상의 기체 고장 상태
            return `
	            <div class="drone-notice error">
		            <i class="fa-solid fa-triangle-exclamation" style="font-size: 28px; filter: drop-shadow(0 0 8px #ef4444);"></i>
		            <span>기체 고장 (점검중)</span>
		        </div>
            `;
        }
        
        if (status === 'warning' || status === '응답없음') {
            // [노란색] 비행 중이지만 스트리밍 영상 신호가 끊긴 상태
            return `
	            <div class="drone-notice warning">
		            <i class="fa-solid fa-plug-circle-xmark" style="font-size: 26px; filter: drop-shadow(0 0 8px #f59e0b);"></i>
		            <span>응답 없음 (점검 필요)</span>
		        </div>
            `;
        }

        // [푸른색] 기본 드론 대기 상태
        return `
	        <div class="drone-notice ready">
		        <i class="fa-solid fa-hourglass-half" style="font-size: 24px; filter: drop-shadow(0 0 8px #0ea5e9);"></i>
		        <span>드론 대기 중 (미비행)</span>
		    </div>
        `;
    }

    // 2. [오류 처리] 스트리밍 이미지 끊김/응답 없음 처리
    function handleStreamError(imgElement) {
        imgElement.onerror = null; // 무한 반복 차단
        var parent = imgElement.parentElement;
        if (!parent) return;

        imgElement.style.display = 'none';

        if (!parent.querySelector('.drone-notice')) {
            parent.insertAdjacentHTML('beforeend', getNoticeHtml('warning'));
        }
    }

    // 3. [메인 렌더링] 드론 그리드 생성 함수
    function renderDroneGrid(drones) {
        var gridContainer = document.getElementById('droneGrid');
        var countElement = document.getElementById('droneCount');
        if (!gridContainer) return;

        gridContainer.innerHTML = '';
        if (countElement) countElement.textContent = drones.length;

        // 정렬: 비행(1) -> 대기(2) -> 고장(3)
        var stateOrder = { '비행': 1, '대기': 2, '고장': 3 };
        drones.sort(function(a, b) {
            return (stateOrder[a.droneStatus] || 99) - (stateOrder[b.droneStatus] || 99);
        });

        drones.forEach(function(drone) {
            var isFlying = drone.droneStatus === '비행';

            // 카드 껍데기 생성
            var cardElement = document.createElement('div');
            cardElement.className = 'drone-card';
            cardElement.id = 'card-' + drone.droneId;
            cardElement.style.cursor = isFlying ? 'pointer' : 'not-allowed';

            cardElement.onclick = function() {
                if (!isFlying) {
                    alert('현재 비행 중인 드론이 아니므로 접근할 수 없는 페이지입니다.');
                    return;
                }
                location.href = ctx + '/drone/stream?id=' + drone.droneId + '&zone=' + encodeURIComponent(drone.zoneName);
            };

            // 헤더 생성
            var statusClassMap = { '비행': 'flying', '대기': 'ready', '고장': 'error' };
            var currentStatusClass = statusClassMap[drone.droneStatus] || 'ready';

            var headerElement = document.createElement('div');
            headerElement.className = 'drone-card-header';
            headerElement.innerHTML = `
                <span class="drone-name">\${drone.droneId}(\${drone.zoneName})</span>
                <span class="drone-status \${currentStatusClass}">\${drone.droneStatus}</span>
            `;

            // 비디오/안내 영역 생성
            var wrapperElement = document.createElement('div');
            wrapperElement.className = 'video-wrapper';

            if (isFlying) {
                var videoElement = document.createElement('img');
                videoElement.src = drone.url;
                
                // 🌟 [핵심] 동적 img 생성 시 onerror 핸들러 바인딩
                videoElement.onerror = function() {
                    handleStreamError(this);
                };
                
                wrapperElement.appendChild(videoElement);
            } else {
                wrapperElement.innerHTML = getNoticeHtml(drone.droneStatus);
            }

            // 카드 조립 (중복 appendChild 제거)
            cardElement.appendChild(headerElement);
            cardElement.appendChild(wrapperElement);
            gridContainer.appendChild(cardElement);
        });
    }

    // 서버 API 호출
    $.ajax({
        url: ctx + '/drone/api/list',
        type: 'GET',
        dataType: 'json',
        success: function(drones) {
            renderDroneGrid(drones);
        }
    });
});
</script>