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

.video-wrapper video {
    width: 100%;
    height: 100%;
    object-fit: cover; /* 영역에 여백 없이 꽉 채우기 (비율을 맞추려면 contain 사용) */
    display: block;
}
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
//이 페이지가 브라우저에 호출되어 눈에 보이기만 하면 이 괄호 안의 전체 코드가 무조건 처음부터 다시 자동 실행됩니다.
$(document).ready(function() {
	var ctx = window.contextPath || '';
	
    function renderDroneGrid(drones) {
        const gridContainer = document.getElementById('droneGrid');
        const countElement = document.getElementById('droneCount');
        
        if (!gridContainer) return;

        gridContainer.innerHTML = '';
        if (countElement) countElement.textContent = drones.length;
		 
        // '비행' 상태인 드론을 맨 앞으로, 그다음 '대기', '고장' 순으로 정렬합니다.
        const stateOrder = { '비행': 1, '대기': 2, '고장': 3 };
        drones.sort((a, b) => {
            const orderA = stateOrder[a.droneStatus] || 99;
            const orderB = stateOrder[b.droneStatus] || 99;
            return orderA - orderB;
        });
        
        drones.forEach(drone => {
            // 1. 카드 껍데기 요소 생성
            const cardElement = document.createElement('div');
            cardElement.className = 'drone-card';
            cardElement.id = 'card-' + drone.droneId;
            
         	// 카드 자체에 마우스 커서를 손가락 모양으로 바꾸고, 클릭 시 링크 이동 이벤트를 심습니다.
            if (drone.droneStatus === '비행') {
			    cardElement.style.cursor = 'pointer';
			} else {
			    cardElement.style.cursor = 'not-allowed';
			}
            cardElement.onclick = function() {
            	if (drone.droneStatus !== '비행') {
                    alert('현재 비행 중인 드론이 아니므로 접근할 수 없는 페이지입니다.');
                    return; // 함수를 즉시 종료하여 아래 location.href가 실행되지 않게 막음
                }
            	
                location.href = `\${ctx}/drone/stream?id=\${drone.droneId}&zone=\${encodeURIComponent(drone.zoneName)}`;
            };
			
        	// 상태 클래스 매핑
            const statusClassMap = { '비행': 'flying', '대기': 'ready', '고장': 'error' };
            const currentStatusClass = statusClassMap[drone.droneStatus] || 'ready'; // 기본값
            
            // 2. 헤더 생성
            const headerElement = document.createElement('div');
            headerElement.className = 'drone-card-header';
            headerElement.innerHTML = `
            	<span class="drone-name">\${drone.droneId}(\${drone.zoneName})</span>
                <span class="drone-status \${currentStatusClass}">\${drone.droneStatus}</span>
            `;
            cardElement.appendChild(headerElement);

            // 3. 비디오 wrapper 및 video 객체 직접 생성
            const wrapperElement = document.createElement('div');
            wrapperElement.className = 'video-wrapper';
            
			// '비행' 상태일 때만 실제 비디오 객체를 생성하여 재생합니다.
            if (drone.droneStatus === '비행') {
                
	            const videoElement = document.createElement('video');
	            videoElement.src = ctx + drone.url;
	            videoElement.autoplay = true;
	            videoElement.loop = true;
	            videoElement.muted = true; // 브라우저 자동재생 필수 조건
	            videoElement.playsInline = true;
	            videoElement.preload = 'metadata';
	
	            // 조립
	            wrapperElement.appendChild(videoElement);
	            cardElement.appendChild(headerElement);
	            cardElement.appendChild(wrapperElement);
	            gridContainer.appendChild(cardElement);
	
	            // DOM 추가 후 명시적 미디어 로드 및 재생
	            videoElement.load();
	            const playPromise = videoElement.play();
	            if (playPromise !== undefined) {
	                playPromise.catch(error => {
	                    console.log("재생 예외 처리:", error);
	                });
	            }
	            
            } else {
            	// '대기' 또는 '고장' 상태일 때는 비디오 대신 멋진 안내 문구를 띄웁니다.
                let noticeHtml = '';
                
                if (drone.droneStatus === '고장') {
                    noticeHtml = `
                        <div class="drone-notice error" style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; color: #f87171; gap: 8px;">
                            <i class="fa-solid fa-triangle-exclamation" style="font-size: 28px; filter: drop-shadow(0 0 8px #ef4444);"></i>
                            <span style="font-size: 13px; font-weight: 600;">기체 고장 (점검중)</span>
                        </div>
                    `;
                } else {
                    noticeHtml = `
                        <div class="drone-notice ready" style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; color: #64748b; gap: 8px;">
                            <i class="fa-solid fa-hourglass-half" style="font-size: 24px; color: #38bdf8; filter: drop-shadow(0 0 8px #0ea5e9);"></i>
                            <span style="font-size: 13px; font-weight: 600; color: #94a3b8;">드론 대기 중 (미비행)</span>
                        </div>
                    `;
                }
                
                wrapperElement.innerHTML = noticeHtml;
                cardElement.appendChild(wrapperElement);
                gridContainer.appendChild(cardElement);
            }
        });
    }
    
	// 서버에서 데이터를 가져오는 Ajax 함수
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