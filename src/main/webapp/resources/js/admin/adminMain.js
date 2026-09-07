console.log("adminMain.js 파일 로드 성공!");

// 1. 페이지 로드 완료 시 자동 실행
document.addEventListener("DOMContentLoaded", function () {
    loadAdminMainMapData();
});

if (document.readyState === "complete" || document.readyState === "interactive") {
    loadAdminMainMapData();
}

// 창 크기가 변경될 때 구역/마커 좌표 재계산
window.addEventListener("resize", function () {
    if (window.adminMainConfigData) {
        renderMapAndOverlays(window.adminMainConfigData);
    }
});

// 메인 전용 상태 변수
window.adminMainFacilities = [];
window.adminMainZones = [];
window.adminMainConfigData = null;

// 메인 지도 데이터 로드 함수
function loadAdminMainMapData() {
    fetch('/admin/area/get', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(function(response) { return response.json(); })
    .then(function(data) {
        console.log("1. 서버 응답:", data);

        if (!data || !data.success || !data.configJson) {
            console.warn("저장된 배치 데이터가 없습니다:", data.message);
            return;
        }

        var configData = {};
        try {
            configData = typeof data.configJson === 'string' ? JSON.parse(data.configJson) : data.configJson;
            window.adminMainConfigData = configData; // 글로벌 저장
            console.log("2. 파싱된 JSON 객체:", configData);
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

        console.log("3. 찾은 이미지 경로:", imageSrc);

        var bgMapImage = document.getElementById("bgMapImage");
        var emptyNotice = document.getElementById("emptyNotice");

        if (bgMapImage && imageSrc) {
            if (emptyNotice) emptyNotice.style.display = "none";
            
            bgMapImage.src = imageSrc;
            bgMapImage.style.display = "block";

            bgMapImage.onload = function () {
                // 이미지 로드 후 크기 재계산 및 오버레이 렌더링
                renderMapAndOverlays(configData);
            };
        } else {
            console.warn("도면 이미지 경로를 찾지 못했습니다.");
        }
    })
    .catch(function(error) {
        console.error("메인 지도 데이터 로드 실패:", error);
    });
}

// 비율 유지(contain) 대응 통합 렌더링 함수
function renderMapAndOverlays(configData) {
    var bgMapImage = document.getElementById("bgMapImage");
    var mapContainer = document.getElementById("admin-map");
    if (!bgMapImage || !mapContainer) return;

    // 1. 원본 및 컨테이너 크기
    var naturalWidth = bgMapImage.naturalWidth || 1;
    var naturalHeight = bgMapImage.naturalHeight || 1;
    var containerWidth = mapContainer.clientWidth || naturalWidth;
    var containerHeight = mapContainer.clientHeight || naturalHeight;

    // 2. object-fit: contain 시 적용되는 단일 스케일 및 실제 이미지 표시 영역 계산
    var scale = Math.min(containerWidth / naturalWidth, containerHeight / naturalHeight);
    var renderedWidth = naturalWidth * scale;
    var renderedHeight = naturalHeight * scale;

    // 3. 중앙 정렬로 발생하는 여백(Offset) 계산
    var offsetX = (containerWidth - renderedWidth) / 2;
    var offsetY = (containerHeight - renderedHeight) / 2;

    // 캔버스 및 시설물 레이어 크기를 전체 컨테이너에 맞춤
    initMainCanvasSize(containerWidth, containerHeight);

    var zonesData = configData.zones || configData.savedZones || [];
    var facilitiesData = configData.facilities || configData.savedFacilities || [];

    // 스케일 및 오프셋 적용 렌더링
    if (zonesData.length > 0) {
        window.adminMainZones = zonesData;
        drawMainZones(zonesData, scale, offsetX, offsetY);
    }

    if (facilitiesData.length > 0) {
        window.adminMainFacilities = facilitiesData;
        renderMainFacilities(facilitiesData, scale, offsetX, offsetY);
    }
}

// 캔버스 및 시설물 레이어 크기 설정
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

// 비율(scale) 및 여백(offset) 반영 구역 렌더링
function drawMainZones(zones, scale, offsetX, offsetY) {
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
        // 원본 좌표 * 스케일 + 여백
        ctx.moveTo(points[0].x * scale + offsetX, points[0].y * scale + offsetY);

        for (var i = 1; i < points.length; i++) {
            ctx.lineTo(points[i].x * scale + offsetX, points[i].y * scale + offsetY);
        }

        ctx.closePath();

        ctx.fillStyle = zone.fillColor || "rgba(56, 189, 248, 0.3)";
        ctx.fill();

        ctx.strokeStyle = zone.strokeColor || "#38bdf8";
        ctx.lineWidth = 2;
        ctx.stroke();
    });
}

// 비율(scale) 및 여백(offset) 반영 시설물 마커 렌더링
function renderMainFacilities(facilities, scale, offsetX, offsetY) {
    var facilityLayer = document.getElementById("facilityLayer");
    if (!facilityLayer) return;

    facilityLayer.innerHTML = "";

    var facilityIconMap = {
        CCTV: "fa-video",
        EMERGENCY: "fa-bell",
        FIRE_EXT: "fa-fire-extinguisher",
        INFO: "fa-circle-info",
        MEDICAL: "fa-kit-medical",
        RESTROOM: "fa-restroom"
    };

    facilities.forEach(function(fac) {
        var iconClass = facilityIconMap[fac.type] || "fa-location-dot";
        var marker = document.createElement("div");

        // 원본 좌표 * 스케일 + 여백
        var posX = fac.x * scale + offsetX;
        var posY = fac.y * scale + offsetY;

        marker.className = "facility-marker";
        marker.id = "main_fac_" + (fac.id || Math.random().toString(36).substr(2, 9));
        marker.style.position = "absolute";
        marker.style.left = posX + "px";
        marker.style.top = posY + "px";
        marker.style.transform = "translate(-50%, -50%)";
        marker.style.cursor = "pointer";
        marker.style.zIndex = "25";

        marker.innerHTML = '<i class="fa-solid ' + iconClass + '" style="font-size: 14px; color: #38bdf8; background: rgba(15, 23, 42, 0.85); padding: 5px; border-radius: 50%; border: 1px solid #38bdf8; display: flex; align-items: center; justify-content: center; width: 26px; height: 26px;"></i>';

        facilityLayer.appendChild(marker);
    });
}