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

.status-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background-color: #22c55e; /* 정상 스트리밍 녹색 */
    box-shadow: 0 0 8px #22c55e;
}

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
            <span class="drone-count-badge">모니터링 중: <span id="droneCount">0</span>대</span>
        </div>
    </div>

    <!-- 드론 추가 시 동적으로 카드가 생성되는 영역 -->
    <div class="drone-grid" id="droneGrid">
        <!-- 스크립트를 통해 카드 요소가 동적으로 생성됩니다. -->
    </div>
</div>

<script>
(function() {
    const droneList = [
        { id: 'DRONE-01', name: '1호기', zone: 'A구역', status: '비행', videoSrc: '/resources/video/sample1.mp4' },
        { id: 'DRONE-02', name: '2호기', zone: 'B구역', status: '비행', videoSrc: '/resources/video/sample2.mp4' },
        { id: 'DRONE-03', name: '3호기', zone: 'C구역', status: '비행', videoSrc: '/resources/video/sample3.mp4' },
    ];

    function renderDroneGrid(drones) {
        const gridContainer = document.getElementById('droneGrid');
        const countElement = document.getElementById('droneCount');
        
        if (!gridContainer) return;

        gridContainer.innerHTML = '';
        if (countElement) countElement.textContent = drones.length;

        drones.forEach(drone => {
            // 1. 카드 껍데기 요소 생성
            const cardElement = document.createElement('div');
            cardElement.className = 'drone-card';
            cardElement.id = 'card-' + drone.id;

            // 2. 헤더 생성
            const headerElement = document.createElement('div');
            headerElement.className = 'drone-card-header';
            headerElement.innerHTML = `
                <span class="drone-name">${drone.name} | ${drone.zone}</span>
                <span class="status-dot">${drone.status}</span>
            `;

            // 3. 비디오 wrapper 및 video 객체 직접 생성
            const wrapperElement = document.createElement('div');
            wrapperElement.className = 'video-wrapper';

            const videoElement = document.createElement('video');
            videoElement.src = drone.videoSrc;
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
        });
    }

    renderDroneGrid(droneList);
})();
</script>