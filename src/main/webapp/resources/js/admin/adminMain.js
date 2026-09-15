// 메인 전용 상태 변수
window.adminMainFacilities = [];
window.adminMainZones = [];
window.adminMainConfigData = null;

// 이벤트 리스너 해제를 위한 AbortController (중복 이벤트 방지용)
window.mapEventController = window.mapEventController || null;

// ==================================================
// [핵심] 비동기 페이지 이동 시 외부에서 직접 호출할 메인 진입점
// ==================================================
window.initAdminMainMap = function() {
    // 1. 상태값 완전 리셋
    window.currentScale = 1;
    window.panOffsetX = 0;
    window.panOffsetY = 0;

    // 2. 안전한 줌 & 팬 이벤트 재등록 (기존 이벤트 완전 제거 후 등록)
    initSafeZoomAndPan();

    // 3. 지도 데이터 로드 및 렌더링
    loadAdminMainMapData();

    // 4. [추가] 실시간 SSE 수신기 가동!
    window.initAdminMainSse();
};

// 최초 일반 페이지 로드 시 대응
if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", function() {
        window.initAdminMainMap();
    });
} else {
    window.initAdminMainMap();
}

// 창 크기가 변경될 때 구역/마커 좌표 재계산
window.addEventListener("resize", function() {
    if (window.adminMainConfigData) {
        renderMapAndOverlays(window.adminMainConfigData);
    }
});

// ==================================================
// 0. 스케일 계산 보조 함수
// ==================================================
function getScaleRatios() {
    const bgMapImageEl = document.getElementById("bgMapImage");
    const mapWrapper = document.getElementById("mapWrapper") || document.getElementById("admin-map");

    const naturalWidth = (bgMapImageEl && bgMapImageEl.naturalWidth) ? bgMapImageEl.naturalWidth : 1;
    const naturalHeight = (bgMapImageEl && bgMapImageEl.naturalHeight) ? bgMapImageEl.naturalHeight : 1;
    const currentWidth = (mapWrapper && mapWrapper.clientWidth) ? mapWrapper.clientWidth : naturalWidth;
    const currentHeight = (mapWrapper && mapWrapper.clientHeight) ? mapWrapper.clientHeight : naturalHeight;

    return {
        scaleX: naturalWidth / currentWidth,
        scaleY: naturalHeight / currentHeight,
        renderScaleX: currentWidth / naturalWidth,
        renderScaleY: currentHeight / naturalHeight
    };
}

// ==================================================
// 1. 안정적인 줌 & 팬(확대/축소 및 이동) 로직
// ==================================================
function initSafeZoomAndPan() {
    // 기존에 등록된 이벤트 리스너가 있다면 모두 제거 (이벤트 중복 쌓임 방지)
    if (window.mapEventController) {
        window.mapEventController.abort();
    }
    window.mapEventController = new AbortController();
    const { signal } = window.mapEventController;

    const mapWrapper = document.getElementById("mapWrapper") || document.getElementById("admin-map");
    const bgMapImageEl = document.getElementById("bgMapImage");
    const zoneCanvas = document.getElementById("zoneCanvas");
    const facilityLayer = document.getElementById("facilityLayer");
    const zoomLevelDisplay = document.getElementById("zoomLevel");

    if (!mapWrapper) return;

    let isPanning = false;
    let startX = 0;
    let startY = 0;

    // 모든 레이어에 변환 적용
    window.applyMapTransform = function() {
        const transformStr = `translate(${window.panOffsetX}px, ${window.panOffsetY}px) scale(${window.currentScale})`;

        if (bgMapImageEl) {
            bgMapImageEl.style.transformOrigin = "0 0";
            bgMapImageEl.style.transform = transformStr;
        }
        if (zoneCanvas) {
            zoneCanvas.style.transformOrigin = "0 0";
            zoneCanvas.style.transform = transformStr;
        }
        if (facilityLayer) {
            facilityLayer.style.transformOrigin = "0 0";
            facilityLayer.style.transform = transformStr;
        }

        if (zoomLevelDisplay) {
            zoomLevelDisplay.innerText = `${Math.round(window.currentScale * 100)}%`;
        }
    };

    // 마우스 휠로 확대 / 축소 ({ signal }을 통해 이전 이벤트 바인딩 자동 해제)
    mapWrapper.addEventListener("wheel", function(e) {
        e.preventDefault();

        const zoomFactor = 0.1;
        const delta = e.deltaY < 0 ? 1 : -1;
        const newScale = Math.min(Math.max(0.5, window.currentScale + delta * zoomFactor), 3.0);

        if (newScale === window.currentScale) return;

        const rect = mapWrapper.getBoundingClientRect();
        const mouseX = e.clientX - rect.left;
        const mouseY = e.clientY - rect.top;

        window.panOffsetX -= (mouseX - window.panOffsetX) * (newScale / window.currentScale - 1);
        window.panOffsetY -= (mouseY - window.panOffsetY) * (newScale / window.currentScale - 1);
        window.currentScale = newScale;

        window.applyMapTransform();
    }, { passive: false, signal });

    // 마우스 드래그로 이동 (Panning)
    mapWrapper.addEventListener("mousedown", function(e) {
        isPanning = true;
        startX = e.clientX - window.panOffsetX;
        startY = e.clientY - window.panOffsetY;
        mapWrapper.style.cursor = "grabbing";
    }, { signal });

    window.addEventListener("mousemove", function(e) {
        if (!isPanning) return;
        window.panOffsetX = e.clientX - startX;
        window.panOffsetY = e.clientY - startY;
        window.applyMapTransform();
    }, { signal });

    window.addEventListener("mouseup", function() {
        if (isPanning) {
            isPanning = false;
            if (mapWrapper) mapWrapper.style.cursor = "default";
        }
    }, { signal });
}

// ==================================================
// 2. 메인 지도 데이터 로드 함수
// ==================================================
function loadAdminMainMapData() {
    fetch('/admin/area/get', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (!data || !data.success || !data.configJson) {
                console.warn("저장된 배치 데이터가 없습니다:", data.message);
                return;
            }

            var configData = {};
            try {
                configData = typeof data.configJson === 'string' ? JSON.parse(data.configJson) : data.configJson;
                window.adminMainConfigData = configData;
            } catch (e) {
                console.error("JSON 파싱 에러:", e);
                return;
            }

            var mapConfig = configData.mapConfig || {};
            var imageSrc = configData.bgImageSrc
                || configData.bgImage
                || configData.imagePath
                || configData.mapImage
                || mapConfig.filePath
                || mapConfig.src;

            var bgMapImage = document.getElementById("bgMapImage");
            var emptyNotice = document.getElementById("emptyNotice");

            if (bgMapImage && imageSrc) {
                if (emptyNotice) emptyNotice.style.display = "none";

                bgMapImage.src = imageSrc;
                bgMapImage.style.display = "block";

                bgMapImage.onload = function() {
                    renderMapAndOverlays(configData);

                    // 💡 [추가] 이미지와 지도 그리기 완료 후 사이드바 요원 목록 갱신!
                    if (typeof renderAdminAgentList === 'function') {
                        renderAdminAgentList();
                    }
                };
            } else {
                // 이미지가 없더라도 구역 및 사이드바 정보는 표시되도록 처리
                renderMapAndOverlays(configData);
                if (typeof renderAdminAgentList === 'function') {
                    renderAdminAgentList();
                }
            }
        })
        .catch(function(error) {
            console.error("메인 지도 데이터 로드 실패:", error);
        });
}

// ==================================================
// 3. 통합 렌더링 함수
// ==================================================
function renderMapAndOverlays(configData) {
    var bgMapImage = document.getElementById("bgMapImage");
    var mapContainer = document.getElementById("mapWrapper") || document.getElementById("admin-map");
    if (!bgMapImage || !mapContainer) return;

    var containerWidth = mapContainer.clientWidth || bgMapImage.naturalWidth;
    var containerHeight = mapContainer.clientHeight || bgMapImage.naturalHeight;

    initMainCanvasSize(containerWidth, containerHeight);

    const { renderScaleX, renderScaleY } = getScaleRatios();

    var zonesData = configData.zones || configData.savedZones || [];
    var facilitiesData = configData.facilities || configData.savedFacilities || [];

    if (zonesData.length > 0) {
        window.adminMainZones = zonesData;
        drawMainZones(zonesData, renderScaleX, renderScaleY);
    }

    if (facilitiesData.length > 0) {
        window.adminMainFacilities = facilitiesData;
        renderMainFacilities(facilitiesData, renderScaleX, renderScaleY);
    }

    if (typeof window.applyMapTransform === "function") {
        window.applyMapTransform();
    }

}

function initMainCanvasSize(width, height) {
    var canvas = document.getElementById("zoneCanvas");
    var facilityLayer = document.getElementById("facilityLayer");

    if (canvas) {
        canvas.width = width;
        canvas.height = height;
    }
    if (facilityLayer) {
        facilityLayer.style.width = width + "px";
        facilityLayer.style.height = height + "px";
    }
}

function drawMainZones(zones, renderScaleX, renderScaleY) {
    var canvas = document.getElementById("zoneCanvas");
    if (!canvas) return;
    var ctx = canvas.getContext("2d");

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    zones.forEach(function(zone) {
        var points = zone.points;
        if (typeof points === "string") {
            try { points = JSON.parse(points); } catch (e) { points = []; }
        }

        if (!points || points.length < 3) return;

        ctx.beginPath();
        ctx.moveTo(points[0].x * renderScaleX, points[0].y * renderScaleY);

        for (var i = 1; i < points.length; i++) {
            ctx.lineTo(points[i].x * renderScaleX, points[i].y * renderScaleY);
        }

        ctx.closePath();
        
        // 💡 [수정] JSON의 zone.color 속성을 1순위로 읽어옵니다.
        ctx.fillStyle = zone.color || zone.fillColor || "rgba(56, 189, 248, 0.3)";
        ctx.fill();
        
        // 테두리 색상 (strokeColor가 없으면 테두리용 기본 색상 사용)
        ctx.strokeStyle = zone.strokeColor || "#38bdf8";
        ctx.lineWidth = 2;
        ctx.stroke();
    });
}

function renderMainFacilities(facilities, renderScaleX, renderScaleY) {
    var facilityLayer = document.getElementById("facilityLayer");
    if (!facilityLayer) return;

    facilityLayer.innerHTML = "";

    var facilityIconMap = {
        CCTV: "fa-video",
        EMERGENCY: "fa-user-shield",
        FIRE_EXT: "fa-fire-extinguisher",
        INFO: "fa-circle-info",
        MEDICAL: "fa-kit-medical",
        RESTROOM: "fa-restroom"
    };

    facilities.forEach(function(fac) {
        var iconClass = facilityIconMap[fac.type] || "fa-location-dot";
        var marker = document.createElement("div");

        var posX = fac.x * renderScaleX;
        var posY = fac.y * renderScaleY;

        marker.className = "facility-marker";
        marker.id = "main_fac_" + (fac.id || Math.random().toString(36).substr(2, 9));
        marker.style.position = "absolute";
        marker.style.left = posX + "px";
        marker.style.top = posY + "px";
        marker.style.transform = "translate(-50%, -50%)";
        marker.style.cursor = "pointer";
        marker.style.zIndex = "25";

        marker.innerHTML = `<i class="fa-solid ${iconClass}" style="font-size: 14px; color: #38bdf8; background: rgba(15, 23, 42, 0.8); padding: 5px; border-radius: 50%; border: 1px solid #38bdf8;"></i>`;

        facilityLayer.appendChild(marker);
    });
}



// ==================================================
// 4. SSE 실시간 지도 변경 수신 연결 함수
// ==================================================
window.initAdminMainSse = function() {
    if (window.adminMapSseSource) {
        window.adminMapSseSource.close();
        window.adminMapSseSource = null;
    }

    var contextPath = window.contextPath || '';
    window.adminMapSseSource = new EventSource(contextPath + '/api/sse/subscribe');

	window.adminMapSseSource.addEventListener("MAP_UPDATED", function(e) {
	    console.log("⚡ [SSE] 실시간 지도/구역 변경 신호 수신!");

	    try {
	        var rawData = typeof e.data === 'string' ? JSON.parse(e.data) : e.data;
	        
	        // 1. SSE로 들어온 최신 구역/DTO 데이터 세팅
	        var newConfigData = rawData;
	        if (rawData.configJson) {
	            newConfigData = typeof rawData.configJson === 'string' 
	                          ? JSON.parse(rawData.configJson) 
	                          : rawData.configJson;
	        }

	        // 전역 변수 갱신
	        window.adminMainConfigData = newConfigData;

	        // 2. 메인 지도 UI 갱신 (지도가 있는 페이지일 경우)
	        if (typeof renderMapAndOverlays === 'function') {
	            renderMapAndOverlays(newConfigData);
	        }

	        // 3. 💡 [핵심] 사이드바 요원 목록 실시간 재렌더링
	        // renderAdminAgentList가 있으면 즉시 다시 그리고, 없으면 전체 로드 함수 호출
	        if (typeof renderAdminAgentList === 'function') {
	            renderAdminAgentList();
	        } else if (typeof loadAdminAgentList === 'function') {
	            loadAdminAgentList();
	        }

	    } catch (err) {
	        console.error("SSE 데이터 처리 중 오류 발생:", err);
	    }
	});

    window.adminMapSseSource.onerror = function() {
        console.warn("SSE 연결 해제됨 또는 오류 발생");
    };
};


// ==========================================
// 1. 드론 비디오 모달 관련 함수 (플로팅 관제창 + AI 분석 연동)
// ==========================================
window.closeDroneModal = function() {
    const modal = document.getElementById("droneVideoModal");
    const imgEl = document.getElementById("modalStreamImg");
    const videoEl = document.getElementById("modalStreamVideo");
    const aiCanvas = document.getElementById("aiOverlayCanvas");

    // 💡 1. 실행 중인 AI 감지 타이머 정지
    if (window.aiDetectTimer) {
        clearInterval(window.aiDetectTimer);
        window.aiDetectTimer = null;
    }

    // 💡 2. 모달 닫을 때 남아있는 AI 바운딩 박스 잔상 제거
    if (aiCanvas) {
        const ctx = aiCanvas.getContext("2d");
        ctx.clearRect(0, 0, aiCanvas.width, aiCanvas.height);
    }

    if (imgEl) {
        imgEl.src = "";
        imgEl.removeAttribute("crossorigin");
    }
    if (videoEl) { 
        videoEl.pause(); 
        videoEl.src = ""; 
    }
    if (modal) modal.style.display = "none";
};

function openDroneModal(zone) {
    const modal = document.getElementById("droneVideoModal");
    const titleEl = document.getElementById("modalDroneTitle");
    const imgEl = document.getElementById("modalStreamImg");
    const videoEl = document.getElementById("modalStreamVideo");
    const noStreamEl = document.getElementById("modalNoStream");

    if (!modal) return;

    // 💡 기존에 작동 중이던 AI 분석 타이머가 있다면 재설정을 위해 먼저 정지
    if (window.aiDetectTimer) {
        clearInterval(window.aiDetectTimer);
        window.aiDetectTimer = null;
    }

    // DB 필드명 우선 참조
    const zoneTitle = zone.zoneName || zone.name || "구역";
    const droneId = zone.droneId || zone.drone_id || "미지정";
    const streamUrl = zone.streamUrl || zone.stream_url || "";

    if (titleEl) titleEl.textContent = `[${zoneTitle}] - 드론 관제 (${droneId})`;

    if (imgEl) imgEl.style.display = "none";
    if (videoEl) videoEl.style.display = "none";
    if (noStreamEl) noStreamEl.style.display = "none";

    if (!streamUrl) {
        if (noStreamEl) noStreamEl.style.display = "block";
    } else if (streamUrl.startsWith("http")) {
        if (imgEl) {
            imgEl.crossOrigin = "anonymous";
            const cacheBuster = (streamUrl.includes('?') ? '&' : '?') + '_t=' + Date.now();
            imgEl.src = streamUrl + cacheBuster;
            imgEl.style.display = "block";
        }
    } else if (streamUrl.endsWith(".mp4")) {
        if (videoEl) {
            videoEl.src = streamUrl;
            videoEl.style.display = "block";
            videoEl.play();
        }
    } else {
        if (imgEl) {
            imgEl.crossOrigin = "anonymous";
            imgEl.src = streamUrl;
            imgEl.style.display = "block";
        }
    }

    // [플로팅 창 전환 설정]
    modal.style.display = "block";
    modal.style.background = "transparent"; // 어두운 배경 제거
    modal.style.pointerEvents = "none";     // 외부 영역 클릭을 뒤쪽 지도에 투과

    // 내부 실제 영상 박스만 클릭 이벤트 복원
    const modalContent = modal.querySelector(".modal-content") || modal.firstElementChild;
    if (modalContent) {
        modalContent.style.pointerEvents = "auto";
    }

    // 💡 [핵심 추가] 모달이 켜지고 영상 DOM이 생성된 후 AI 프레임 캡처 및 바운딩 박스 연동 시작
    if (streamUrl) {
        setTimeout(function() {
            var mediaEl = document.getElementById('modalStreamVideo');
            if (!mediaEl || mediaEl.style.display === 'none' || !mediaEl.src) {
                mediaEl = document.getElementById('modalStreamImg');
            }

            if (mediaEl && mediaEl.src) {
                if (mediaEl.tagName === 'IMG') {
                    mediaEl.crossOrigin = "anonymous";
                }

                // 1.5초 간격으로 AI 프레임 캡처 후 서버 전송 (drawBoundingBoxes 자동 실행)
                window.aiDetectTimer = setInterval(function() {
                    if (typeof captureAndSendAIFrame === 'function') {
                        captureAndSendAIFrame(mediaEl, droneId);
                    }
                }, 1500);
            }
        }, 500);
    }
}

// ==========================================
// 2. 좌표 클릭 다각형 판별 함수 (Ray-casting)
// ==========================================
function isPointInPolygon(point, vs) {
    var x = point.x, y = point.y;
    var inside = false;
    for (var i = 0, j = vs.length - 1; i < vs.length; j = i++) {
        var xi = vs[i].x, yi = vs[i].y;
        var xj = vs[j].xj || vs[j].x, yi_test = vs[i].y, yj = vs[j].y; // 점 형태 유연 대응
        
        var xi = vs[i].x !== undefined ? vs[i].x : vs[i][0];
        var yi = vs[i].y !== undefined ? vs[i].y : vs[i][1];
        var xj = vs[j].x !== undefined ? vs[j].x : vs[j][0];
        var yj = vs[j].y !== undefined ? vs[j].y : vs[j][1];

        var intersect = ((yi > y) !== (yj > y))
            && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
    }
    return inside;
}

// ==========================================
// 3. DB 지도 데이터 로드 후 전역변수 저장 함수
// ==========================================
function loadMainMapData() {
    var ctx = window.contextPath || '';
    
    // DB에서 구역 및 시설물 불러오는 API 호출
    $.ajax({
        url: ctx + '/admin/area/load', // 서버의 구역 데이터 조회 API 주소
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response && response.zones) {
                // 💡 [핵심] 클릭 이벤트가 참조할 수 있도록 전역변수에 DB 구역 데이터 전달
                window.savedZones = response.zones;
                
                // Canvas에 배경 이미지 및 구역 다시 그리기 실행
                if (typeof drawMainMap === 'function') {
                    drawMainMap(response);
                }
            }
        },
        error: function(err) {
            console.error("메인 지도 데이터 로드 실패:", err);
        }
    });
}

// ==========================================
// 4. 지도 캔버스 클릭 이벤트 및 마우스 커서 설정
// ==========================================
$(document).ready(function() {
    const mapCanvas = document.getElementById("zoneCanvas"); 
    
    if (mapCanvas) {
        
        // 💡 [핵심] 공통 좌표 역산 함수 (화면 마우스 위치 -> DB 원본 좌표 복원)
        function getNaturalCoordinates(e) {
            const mapWrapper = document.getElementById("mapWrapper") || document.getElementById("admin-map");
            if (!mapWrapper) return null;

            // 1. Transform 변형이 없는 부모 컨테이너(mapWrapper)를 기준으로 클릭 위치 잡기 (이중 계산 방지)
            const rect = mapWrapper.getBoundingClientRect();
            const mouseX = e.clientX - rect.left;
            const mouseY = e.clientY - rect.top;

            // 2. CSS Transform(줌/팬)을 역산하여 캔버스 내부 좌표로 되돌리기
            const scale = window.currentScale || 1;
            const panX = window.panOffsetX || 0;
            const panY = window.panOffsetY || 0;

            const canvasX = (mouseX - panX) / scale;
            const canvasY = (mouseY - panY) / scale;

            // 3. 캔버스 내부 좌표를 DB에 저장된 '원본 이미지 비율(Natural)' 좌표계로 뻥튀기(또는 축소)
            const { scaleX, scaleY } = getScaleRatios(); 
            
            return {
                x: canvasX * scaleX,
                y: canvasY * scaleY
            };
        }

        // 🎯 1. 마우스 이동 시 커서 변경 (Hover 판별)
        mapCanvas.addEventListener("mousemove", function(e) {
            const clickPos = getNaturalCoordinates(e);
            if (!clickPos) return;

            const zoneList = window.adminMainZones || []; 
            
            const isHover = zoneList.some(zone => {
                let points = zone.points || zone.polygonPoints;
                if (typeof points === "string") {
                    try { points = JSON.parse(points); } catch(err) { points = []; }
                }
                // DB 원본 좌표(points)와 완벽히 복원된 마우스 좌표(clickPos)를 직접 비교!
                return points && isPointInPolygon(clickPos, points);
            });

            mapCanvas.style.cursor = isHover ? "pointer" : "default";
        });

        // 🎯 2. 캔버스 클릭 시 모달 오픈
        mapCanvas.addEventListener("click", function (e) {
            const clickPos = getNaturalCoordinates(e);
            if (!clickPos) return;

            const zoneList = window.adminMainZones || [];

            // 최신 구역(상위 레이어) 우선 탐색 (역순)
            const clickedZone = [...zoneList].reverse().find(zone => {
                let points = zone.points || zone.polygonPoints;
                if (typeof points === "string") {
                    try { points = JSON.parse(points); } catch (err) { points = []; }
                }
                return points && isPointInPolygon(clickPos, points);
            });

            if (clickedZone) {
                openDroneModal(clickedZone);
            }
        });
    }
});