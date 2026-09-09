console.log("areaManagement.js 파일이 정상 로드되었습니다.");

function initAreaManagement() {
	
	// 0. 스케일 계산 보조 함수 (옵셔널 체이닝 제거로 구형 환경 대응)
	function getScaleRatios() {
	    const bgMapImageEl = document.getElementById("bgMapImage");
	    const mapWrapper = document.getElementById("mapWrapper");

	    const naturalWidth = (bgMapImageEl && bgMapImageEl.naturalWidth) ? bgMapImageEl.naturalWidth : 1;
	    const naturalHeight = (bgMapImageEl && bgMapImageEl.naturalHeight) ? bgMapImageEl.naturalHeight : 1;
	    const currentWidth = (mapWrapper && mapWrapper.clientWidth) ? mapWrapper.clientWidth : naturalWidth;
	    const currentHeight = (mapWrapper && mapWrapper.clientHeight) ? mapWrapper.clientHeight : naturalHeight;

	    return {
	        scaleX: naturalWidth / currentWidth,         // 화면px -> 원본px 변환용
	        scaleY: naturalHeight / currentHeight,       // 화면px -> 원본px 변환용
	        renderScaleX: currentWidth / naturalWidth,   // 원본px -> 화면px 변환용
	        renderScaleY: currentHeight / naturalHeight  // 원본px -> 화면px 변환용
	    };
	}

    // --------------------------------------------------
    // 1단계: 도면 업로드 
    // --------------------------------------------------
    const uploadInput = document.getElementById("uploadMapImage");
    const bgMapImage = document.getElementById("bgMapImage");
    const emptyNotice = document.getElementById("emptyNotice");

    if (uploadInput) {
        uploadInput.onchange = function (e) {
            const file = e.target.files[0];
            if (file && file.type.startsWith("image/")) {
                const reader = new FileReader();
                reader.onload = function (event) {
                    if (bgMapImage) {
                        bgMapImage.src = event.target.result;
                        bgMapImage.style.display = "block";
                    }
                    if (emptyNotice) {
                        emptyNotice.style.display = "none";
                    }
                    // 이미지 변경 시 캔버스 크기 재조정
                    setTimeout(resizeCanvas, 100);
                };
                reader.readAsDataURL(file);
            } else {
                alert("이미지 파일만 업로드할 수 있습니다.");
            }
        };
    }

    // --------------------------------------------------
    // 2단계: 상단 툴바 모드 전환
    // --------------------------------------------------
    window.currentMode = "select";

    const btnModeSelect = document.getElementById("btnModeSelect");
    const btnModePolygon = document.getElementById("btnModePolygon");

    function clearActiveTools() {
        document.querySelectorAll(".tool-btn").forEach(btn => {
            btn.classList.remove("active");
        });
    }

    if (btnModeSelect) {
        btnModeSelect.onclick = function () {
            window.currentMode = "select";
            clearActiveTools();
            this.classList.add("active");
            console.log("현재 모드: 선택/이동 모드");
        };
    }

    if (btnModePolygon) {
        btnModePolygon.onclick = function () {
            window.currentMode = "draw";
            clearActiveTools();
            this.classList.add("active");
            console.log("현재 모드: 구역 그리기 모드");
        };
    }

	// --------------------------------------------------
	    // 3단계: Canvas 구역(Polygon) 그리기 (이벤트 보완)
	    // --------------------------------------------------
	    const canvas = document.getElementById("zoneCanvas");
	    if (!canvas) {
	        console.error("zoneCanvas 요소를 찾을 수 없습니다.");
	        return;
	    }

	    const ctx = canvas.getContext("2d");

	    function resizeCanvas() {
	        const wrapper = document.getElementById("mapWrapper");
	        if (wrapper) {
	            // 캔버스 자체 resolution(해상도) 설정
	            canvas.width = wrapper.clientWidth || wrapper.offsetWidth;
	            canvas.height = wrapper.clientHeight || wrapper.offsetHeight;
	            redrawCanvas();
	        }
	    }

	    // 캔버스 크기 초기화
	    setTimeout(resizeCanvas, 200);
	    window.addEventListener("resize", resizeCanvas);

	    let isDrawing = false;
	    let currentPolygon = [];
	    let mousePos = { x: 0, y: 0 };
	    window.savedPolygons = window.savedPolygons || [];

		function redrawCanvas() {
		    ctx.clearRect(0, 0, canvas.width, canvas.height);
		    const { renderScaleX, renderScaleY } = getScaleRatios();

		    // 1. 저장된 구역들 렌더링 (원본 좌표 -> 화면 좌표 변환)
		    window.savedPolygons.forEach(poly => {
		        if (!poly.points || poly.points.length < 3) return;
		        ctx.beginPath();
		        ctx.moveTo(poly.points[0].x * renderScaleX, poly.points[0].y * renderScaleY);
		        for (let i = 1; i < poly.points.length; i++) {
		            ctx.lineTo(poly.points[i].x * renderScaleX, poly.points[i].y * renderScaleY);
		        }
		        ctx.closePath();
		        ctx.fillStyle = poly.color || "rgba(56, 189, 248, 0.35)";
		        ctx.fill();
		        ctx.strokeStyle = "#38bdf8";
		        ctx.lineWidth = 2;
		        ctx.stroke();
		    });

		    // 2. 작성 중인 구역 표시 (마우스 클릭 좌표는 이미 원본 좌표로 변환되어 저장됨)
		    if (currentPolygon.length > 0) {
		        ctx.beginPath();
		        ctx.moveTo(currentPolygon[0].x * renderScaleX, currentPolygon[0].y * renderScaleY);
		        for (let i = 1; i < currentPolygon.length; i++) {
		            ctx.lineTo(currentPolygon[i].x * renderScaleX, currentPolygon[i].y * renderScaleY);
		        }

		        if (isDrawing) {
		            ctx.lineTo(mousePos.x * renderScaleX, mousePos.y * renderScaleY);
		        }

		        ctx.strokeStyle = "#fbbf24";
		        ctx.lineWidth = 2;
		        ctx.stroke();

		        currentPolygon.forEach(pt => {
		            ctx.beginPath();
		            ctx.arc(pt.x * renderScaleX, pt.y * renderScaleY, 6, 0, Math.PI * 2);
		            ctx.fillStyle = "#fbbf24";
		            ctx.fill();
		        });
		    }
		}

		// 마우스 이동 (수정)
		canvas.addEventListener("mousemove", function (e) {
		    if (window.currentMode !== "draw" || !isDrawing) return;
		    const rect = canvas.getBoundingClientRect();
		    const scale = getScaleRatios();
		    const currentScale = window.currentScale || 1; // 현재 줌 배율
		    
		    // 1. 현재 클릭 위치를 Zoom 배율로 나누고 -> 2. 원본 이미지 비율 곱하기
		    mousePos.x = ((e.clientX - rect.left) / currentScale) * scale.scaleX;
		    mousePos.y = ((e.clientY - rect.top) / currentScale) * scale.scaleY;
		    redrawCanvas();
		});

		// mousedown으로 점 찍기 (수정)
		canvas.addEventListener("mousedown", function (e) {
		    if (e.button !== 0) return;

		    if (window.currentMode !== "draw") return;

		    const rect = canvas.getBoundingClientRect();
		    const scale = getScaleRatios();
		    const currentScale = window.currentScale || 1; // 현재 줌 배율

		    // 1. 현재 클릭 위치를 Zoom 배율로 나누고 -> 2. 원본 이미지 비율 곱하기
		    const x = ((e.clientX - rect.left) / currentScale) * scale.scaleX;
		    const y = ((e.clientY - rect.top) / currentScale) * scale.scaleY;

		    currentPolygon.push({ x: x, y: y });
		    isDrawing = true;

		    redrawCanvas();
		});

	    // 마우스 우클릭 (구역 완성)
	    canvas.addEventListener("contextmenu", function (e) {
	        if (window.currentMode !== "draw" || !isDrawing) return;
	        e.preventDefault();

	        if (currentPolygon.length >= 3) {
	            window.savedPolygons.push({
	                id: "zone_" + Date.now(),
	                name: "신규 구역 " + (window.savedPolygons.length + 1),
	                points: [...currentPolygon],
	                color: "rgba(56, 189, 248, 0.35)"
	            });
	            console.log("구역 생성 완료:", window.savedPolygons);
	        } else {
	            alert("구역을 완성하려면 최소 3개 이상의 점을 찍어야 합니다.");
	        }

	        currentPolygon = [];
	        isDrawing = false;
	        redrawCanvas();
	    });
		
		
		
		// --------------------------------------------------
		    // 4단계: 구역 선택 및 우측 상세 패널 데이터 연동
		    // --------------------------------------------------
		    const emptyDetailMsg = document.getElementById("emptyDetailMsg");
		    const elementDetailForm = document.getElementById("elementDetailForm");
		    const selectedElementId = document.getElementById("selectedElementId");
		    const selectedElementType = document.getElementById("selectedElementType");
		    const elemTypeDisplay = document.getElementById("elemTypeDisplay");
		    const elemName = document.getElementById("elemName");
		    const elemColor = document.getElementById("elemColor");
		    const zoneOnlyFields = document.querySelector(".zone-only-fields");
		    const facilityOnlyFields = document.querySelector(".facility-only-fields");

		    let selectedZone = null; // 현재 선택된 구역 객체 저장

		    // 다각형 내부 클릭 여부 판별 수학 함수 (Ray-Casting 알고리즘)
		    function isPointInPolygon(point, vs) {
		        let x = point.x, y = point.y;
		        let inside = false;
		        for (let i = 0, j = vs.length - 1; i < vs.length; j = i++) {
		            let xi = vs[i].x, yi = vs[i].y;
		            let xj = vs[j].x, yj = vs[j].y;
		            let intersect = ((yi > y) !== (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
		            if (intersect) inside = !inside;
		        }
		        return inside;
		    }

			// 선택/이동 모드일 때 캔버스 클릭 처리 (수정)
			canvas.addEventListener("click", function (e) {
			    if (window.currentMode !== "select") return;

			    const rect = canvas.getBoundingClientRect();
			    const scale = getScaleRatios();
			    const currentScale = window.currentScale || 1; // 현재 줌 배율

			    // 클릭 좌표를 '원본 이미지 기준 좌표'로 변환 (mousedown 식과 동일)
			    const clickPt = { 
			        x: ((e.clientX - rect.left) / currentScale) * scale.scaleX, 
			        y: ((e.clientY - rect.top) / currentScale) * scale.scaleY 
			    };

			    // 저장된 구역들 중 클릭한 위치에 있는 구역 탐색 (역순으로 클릭된 맨 위 구역 찾기)
			    let clickedZone = null;
			    for (let i = window.savedPolygons.length - 1; i >= 0; i--) {
			        if (isPointInPolygon(clickPt, window.savedPolygons[i].points)) {
			            clickedZone = window.savedPolygons[i];
			            break;
			        }
			    }

			    if (clickedZone) {
			        window.selectedZone = clickedZone;
			        openZoneDetailForm(clickedZone);
			    } else {
			        // 빈 공간 클릭 시 선택 해제
			        window.selectedZone = null;
			        closeDetailForm();
			    }
			});

			// 우측 상세 정보 폼에 구역 데이터 채우기
			function openZoneDetailForm(zone) {
			    if (emptyDetailMsg) emptyDetailMsg.style.display = "none";
			    if (elementDetailForm) elementDetailForm.style.display = "block";

			    // 공통 입력창 데이터 바인딩
			    if (selectedElementId) selectedElementId.value = zone.id;
			    if (selectedElementType) selectedElementType.value = "ZONE";
			    if (elemTypeDisplay) elemTypeDisplay.value = "구역 (Zone)";
			    if (elemName) elemName.value = zone.name || "";

			    const elemDesc = document.getElementById("elemDesc");
			    if (elemDesc) elemDesc.value = zone.description || "";

			    // 구역 색상
			    if (elemColor) elemColor.value = rgbaToHex(zone.color) || "#38bdf8";

			    // [추가] 드롭다운 옵션을 활성화된 요원 목록으로 먼저 갱신
			    populateAgentSelectOptions();

			    // 안전요원 선택값 바인딩
			    const elemAgent = document.getElementById("elemAgent");
			    if (elemAgent) elemAgent.value = zone.agentId || "";

			    // 스트리밍 URL
			    const elemStreamUrl = document.getElementById("elemStreamUrl");
			    if (elemStreamUrl) elemStreamUrl.value = zone.streamUrl || "";

			    if (zoneOnlyFields) zoneOnlyFields.style.display = "block";
			    if (facilityOnlyFields) facilityOnlyFields.style.display = "none";
			}

		    // 상세 패널 닫기 (초기 상태)
		    function closeDetailForm() {
		        if (emptyDetailMsg) emptyDetailMsg.style.display = "block";
		        if (elementDetailForm) elementDetailForm.style.display = "none";
		    }

		    // RGBA 색상을 HEX(#ffffff) 색상 코드로 변환해 주는 보조 함수
		    function rgbaToHex(rgba) {
		        if (!rgba || !rgba.startsWith("rgba")) return "#38bdf8";
		        const parts = rgba.match(/^rgba\((\d+),\s*(\d+),\s*(\d+)/);
		        if (!parts) return "#38bdf8";
		        return "#" + [parts[1], parts[2], parts[3]].map(x => parseInt(x).toString(16).padStart(2, '0')).join('');
		    }

			
			

			// --------------------------------------------------
			    // 5단계: 시설물 아이콘 배치 (Click / Drag & Drop)
			    // --------------------------------------------------
			    const facilityLayer = document.getElementById("facilityLayer");
			    const facilityChips = document.querySelectorAll(".facility-chip");

			    window.savedFacilities = window.savedFacilities || [];
			    let selectedFacility = null; // 현재 선택된 시설물 마커

			    // 시설물 마커 아이콘 클래스 매핑
			    const facilityIconMap = {
			        CCTV: "fa-video",
			        EMERGENCY: "fa-user-shield",
			        FIRE_EXT: "fa-fire-extinguisher",
			        INFO: "fa-circle-info",
			        MEDICAL: "fa-kit-medical",
			        RESTROOM: "fa-restroom"
			    };

			    // 1. 하단 칩 드래그 이벤트 설정
			    facilityChips.forEach(chip => {
			        chip.ondragstart = function (e) {
			            const type = chip.getAttribute("data-type");
			            e.dataTransfer.setData("facilityType", type);
			        };
			    });

			    const mapWrapper = document.getElementById("mapWrapper");
			    if (mapWrapper) {
			        mapWrapper.ondragover = function (e) {
			            e.preventDefault(); // 드롭 허용
			        };

					mapWrapper.ondrop = function (e) {
					    e.preventDefault();
					    const type = e.dataTransfer.getData("facilityType");
					    if (!type) return;

					    const facilityLayer = document.getElementById("facilityLayer");
					    const rect = (facilityLayer || mapWrapper).getBoundingClientRect();
					    const scale = window.currentScale || 1;
					    const ratios = getScaleRatios();

					    // 1. 화면 클릭 시점의 raw px 계산
					    const rawX = (e.clientX - rect.left) / scale;
					    const rawY = (e.clientY - rect.top) / scale;

					    // 2. 화면 px -> 원본 이미지 좌표 px로 변환해서 전달
					    const originX = rawX * ratios.scaleX;
					    const originY = rawY * ratios.scaleY;

					    addFacilityMarker(type, originX, originY);
					};
			    }

				// 2. 시설물 마커 생성 및 DOM 추가 (수정)
				function addFacilityMarker(type, originX, originY, id = null, name = null, streamUrl = "") {
				    const facilityId = id || "fac_" + Date.now();
				    const iconClass = facilityIconMap[type] || "fa-location-dot";
				    const facilityName = name || `${type} 아이콘`;
				    const ratios = getScaleRatios();

				    // 원본 좌표 -> 현재 화면 렌더링용 px 좌표 변환
				    const displayX = originX * ratios.renderScaleX;
				    const displayY = originY * ratios.renderScaleY;

				    const marker = document.createElement("div");
				    marker.className = "facility-marker";
				    marker.id = facilityId;
				    marker.style.position = "absolute";
				    marker.style.left = `${displayX}px`;
				    marker.style.top = `${displayY}px`;
				    marker.style.transform = "translate(-50%, -50%)";
				    marker.style.cursor = "pointer";
				    marker.style.zIndex = "25";
				    marker.innerHTML = `<i class="fa-solid ${iconClass}" style="font-size: 14px; color: #38bdf8; background: rgba(15, 23, 42, 0.8); padding: 5px; border-radius: 50%; border: 1px solid #38bdf8;"></i>`;

				    // 데이터 객체에는 '원본 이미지 기준 좌표' 저장
				    const facData = {
				        id: facilityId,
				        type: type,
				        name: facilityName,
				        x: originX,
				        y: originY,
				        streamUrl: streamUrl
				    };

				    if (!id) {
				        window.savedFacilities.push(facData);
				    }

			        // 시설물 마커 클릭 시 우측 폼 연동
			        marker.onclick = function (e) {
			            e.stopPropagation();
						window.selectedFacility = facData; // 💡 selectedFacility -> window.selectedFacility로 수정!
						window.selectedZone = null;
			            openFacilityDetailForm(facData);
			        };

			        if (facilityLayer) {
			            facilityLayer.appendChild(marker);
			        }
			    }

				// 함수 이름은 유지하고, 내부만 비우거나 폼을 숨기도록 수정
				function openFacilityDetailForm(facility) {
				    if (elementDetailForm) elementDetailForm.style.display = "none";
				    if (emptyDetailMsg) emptyDetailMsg.style.display = "block";
				}

			
			
				// --------------------------------------------------
				    // 6단계: 선택 요소 삭제 및 최종 데이터 저장 (JSON)
				    // --------------------------------------------------
				    const btnDeleteSelected = document.getElementById("btnDeleteSelected");
				    const btnExportJson = document.getElementById("btnExportJson");

					// 1. [선택 삭제] 버튼 클릭 이벤트
					if (btnDeleteSelected) {
					    btnDeleteSelected.onclick = function () {
					        const currentType = selectedElementType ? selectedElementType.value : "";

					        // 1) 구역 삭제
					        if (currentType === "ZONE" && window.selectedZone) {
					            if (confirm(`'${window.selectedZone.name}' 구역을 삭제하시겠습니까?`)) {
					                window.savedPolygons = window.savedPolygons.filter(p => p.id !== window.selectedZone.id);
					                window.selectedZone = null;
					                selectedZone = null;
					                closeDetailForm();
					                redrawCanvas();
					                alert("구역이 삭제되었습니다.");
					            }
					        } 
					        // 2) 시설물 삭제
					        else if (currentType === "FACILITY" && window.selectedFacility) {
					            if (confirm(`'${window.selectedFacility.name}' 시설물을 삭제하시겠습니까?`)) {
					                // 배열에서 제거
					                window.savedFacilities = window.savedFacilities.filter(f => f.id !== window.selectedFacility.id);
					                
					                // DOM 마커 제거
					                const markerElem = document.getElementById(window.selectedFacility.id);
					                if (markerElem) markerElem.remove();

					                // 선택 상태 초기화
					                window.selectedFacility = null;
					                selectedFacility = null;
					                closeDetailForm();
					                alert("시설물이 삭제되었습니다.");
					            }
					        } else {
					            alert("삭제할 구역이나 시설물을 도면에서 먼저 선택해 주세요.");
					        }
					    };
					}

					// 2. [최종 데이터 저장] 버튼 클릭 이벤트 (오라클 DB 저장 연동)
					if (btnExportJson) {
					    btnExportJson.onclick = function () {
					        if (window.savedPolygons.length === 0 && window.savedFacilities.length === 0) {
					            alert("저장할 구역이나 시설물 데이터가 없습니다.");
					            return;
					        }

					        // 서버에 업로드하고 받은 실제 이미지 URL 경로를 저장
					        const mapUrl = window.currentMapUrl || (window.bgMapImage ? window.bgMapImage.src : "");

					        const resultData = {
					            bgImageSrc: mapUrl,
					            zones: window.savedPolygons,
					            facilities: window.savedFacilities
					        };
							
							

					        const targetUrl = "/admin/area/save";

					        fetch(targetUrl, {
					            method: "POST",
					            headers: {
					                "Content-Type": "application/json; charset=utf-8"
					            },
					            body: JSON.stringify(resultData)
					        })
					        .then(res => {
					            if (!res.ok) {
					                throw new Error("서버 응답 에러 (상태코드: " + res.status + ")");
					            }
					            return res.json();
					        })
					        .then(data => {
					            if (data.success) {
					                alert(data.message);
					            } else {
					                alert("저장 실패: " + data.message);
					            }
					        })
					        .catch(err => {
					            console.error("저장 에러:", err);
					            alert("서버 통신 중 오류가 발생했습니다: " + err.message);
					        });
					    };
					}
						
					// 3. 페이지 로드 시 DB에서 배치 데이터 자동으로 불러오기 및 캔버스/시설물/도면 복원
					function loadSavedAreaConfig() {
					    const targetUrl = "/admin/area/get";

					    fetch(targetUrl, {
					        method: "GET",
					        headers: {
					            "Accept": "application/json"
					        }
					    })
					    .then(res => {
					        if (!res.ok) {
					            throw new Error("서버 응답 에러 (상태코드: " + res.status + ")");
					        }
					        return res.json();
					    })
					    .then(data => {
					        if (data.success && data.configJson) {
					            // DB에 저장된 JSON 문자열 파싱
					            const configData = JSON.parse(data.configJson);

					            // 1) 구역(Polygon) 데이터 복원
					            if (configData.zones && Array.isArray(configData.zones)) {
					                window.savedPolygons = configData.zones;
					            }

					            // 2) 시설물 복원 전용 렌더링 함수
					            const renderFacilities = () => {
					                if (configData.facilities && Array.isArray(configData.facilities)) {
					                    window.savedFacilities = configData.facilities;

					                    if (facilityLayer) {
					                        facilityLayer.innerHTML = "";
					                    }

					                    window.savedFacilities.forEach(facility => {
					                        addFacilityMarker(
					                            facility.type,
					                            facility.x,
					                            facility.y,
					                            facility.id,
					                            facility.name,
					                            facility.streamUrl || ""
					                        );
					                    });
					                }

					                // 캔버스 구역 다각형 재렌더링
					                if (typeof redrawCanvas === "function") {
					                    redrawCanvas();
					                } else if (typeof draw === "function") {
					                    draw();
					                }
					            };

					            // 0) 도면 배경 이미지 복원 후 시설물/캔버스 복원
					            if (configData.bgImageSrc) {
					                window.currentMapUrl = configData.bgImageSrc;
					                loadBgImageToCanvas(configData.bgImageSrc);

					                // 이미지 HTML 요소의 로드가 끝난 시점에 시설물 렌더링
					                const bgMapImageEl = document.getElementById("bgMapImage");
					                if (bgMapImageEl) {
					                    if (bgMapImageEl.complete && bgMapImageEl.naturalWidth > 0) {
					                        renderFacilities();
					                    } else {
					                        bgMapImageEl.onload = function() {
					                            renderFacilities();
					                        };
					                    }
					                } else {
					                    renderFacilities();
					                }
					            } else {
					                renderFacilities();
					            }

					            console.log("DB 배치 데이터 불러오기 성공:", configData);
					        }
					    })
					    .catch(err => {
					        console.error("배치 데이터 불러오기 에러:", err);
					    });
					}
			
	
							// 1. 전역 변수로 현재 배경 도면 URL 관리
							window.currentMapUrl = "";

							// 2. JSP의 ID인 uploadMapImage 태그 연결
							const uploadMapImage = document.getElementById("uploadMapImage");
							if (uploadMapImage) {
							    uploadMapImage.onchange = function (e) {
							        const file = e.target.files[0];
							        if (!file) return;

							        const formData = new FormData();
							        formData.append("file", file);

							        // 서버로 파일 업로드
							        fetch("/admin/area/uploadMap", {
							            method: "POST",
							            body: formData
							        })
							        .then(res => res.json())
							        .then(data => {
							            if (data.success) {
							                window.currentMapUrl = data.fileUrl; // 업로드된 파일 URL 저장
							                
							                // 캔버스 및 img 태그에 이미지 복원
							                loadBgImageToCanvas(data.fileUrl);
							                alert("도면 업로드 완료!");
							            } else {
							                alert("도면 업로드 실패: " + data.message);
							            }
							        })
							        .catch(err => {
							            console.error("도면 업로드 에러:", err);
							            alert("도면 파일 업로드 중 오류가 발생했습니다.");
							        });
							    };
							}

							// 3. 캔버스 배경 및 JSP의 <img id="bgMapImage"> 둘 다에 이미지를 넣어주는 함수
							function loadBgImageToCanvas(url) {
							    if (!url) return;

							    // JSP 내의 emptyNotice 안내문은 숨기고 <img id="bgMapImage"> 보이기
							    const emptyNotice = document.getElementById("emptyNotice");
							    const bgMapImageEl = document.getElementById("bgMapImage");
							    if (emptyNotice) emptyNotice.style.display = "none";
							    if (bgMapImageEl) {
							        bgMapImageEl.src = url;
							        bgMapImageEl.style.display = "block";
							    }

							    // Canvas 배경 그리기용 Image 객체 생성
							    const img = new Image();
							    img.crossOrigin = "Anonymous";
							    img.onload = function () {
							        window.bgMapImage = img;
							        if (typeof redrawCanvas === "function") {
							            redrawCanvas();
							        } else if (typeof draw === "function") {
							            draw();
							        }
							    };
							    img.src = url;
							}
							
							
							// 레이어 On/Off 토글 기능 (구역 / 시설물)
							const toggleZoneLayer = document.getElementById("toggleZoneLayer");
							const toggleFacilityLayer = document.getElementById("toggleFacilityLayer");

							// 1. 구역 레이어 숨기기/보이기
							if (toggleZoneLayer) {
							    toggleZoneLayer.onclick = function () {
							        const zoneCanvas = document.getElementById("zoneCanvas");
							        if (!zoneCanvas) return;

							        this.classList.toggle("active");
							        const isActive = this.classList.contains("active");

							        zoneCanvas.style.display = isActive ? "block" : "none";

							        const icon = this.querySelector("i");
							        if (icon) {
							            icon.className = isActive ? "fa-solid fa-eye" : "fa-solid fa-eye-slash";
							        }
							    };
							}

							// 2. 시설물 레이어 숨기기/보이기
							if (toggleFacilityLayer) {
							    toggleFacilityLayer.onclick = function () {
							        const facLayer = document.getElementById("facilityLayer");
							        if (!facLayer) return;

							        this.classList.toggle("active");
							        const isActive = this.classList.contains("active");

							        facLayer.style.display = isActive ? "block" : "none";

							        const icon = this.querySelector("i");
							        if (icon) {
							            icon.className = isActive ? "fa-solid fa-eye" : "fa-solid fa-eye-slash";
							        }
							    };
							}
							
							
							// 안정적인 줌 & 팬(확대/축소 및 이동) 연동 로직
							(function initSafeZoomAndPan() {
							    const mapWrapper = document.getElementById("mapWrapper");
							    const bgMapImageEl = document.getElementById("bgMapImage");
							    const zoneCanvas = document.getElementById("zoneCanvas");
							    const facilityLayer = document.getElementById("facilityLayer");
							    const zoomLevelDisplay = document.getElementById("zoomLevel");

							    if (!mapWrapper) return;

							    window.currentScale = 1;
							    window.panOffsetX = 0;
							    window.panOffsetY = 0;

							    let isPanning = false;
							    let startX = 0;
							    let startY = 0;

							    // 모든 레이어(이미지, 캔버스, 시설물 아이콘)에 동시에 변환 적용
							    function applyTransform() {
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
							    }

							    // 1. 마우스 휠로 확대 / 축소
							    mapWrapper.addEventListener("wheel", function (e) {
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

							        applyTransform();
							    }, { passive: false });

							    // 2. 마우스 드래그로 이동 (Panning)
							    mapWrapper.addEventListener("mousedown", function (e) {
							        // 우클릭 또는 선택/이동 모드일 때 팬 이동 동작
							        const btnModeSelect = document.getElementById("btnModeSelect");
							        const isSelectActive = btnModeSelect && btnModeSelect.classList.contains("active");

							        if (isSelectActive || e.button === 1 || e.button === 2) {
							            isPanning = true;
							            startX = e.clientX - window.panOffsetX;
							            startY = e.clientY - window.panOffsetY;
							        }
							    });

							    window.addEventListener("mousemove", function (e) {
							        if (!isPanning) return;
							        window.panOffsetX = e.clientX - startX;
							        window.panOffsetY = e.clientY - startY;
							        applyTransform();
							    });

							    window.addEventListener("mouseup", function () {
							        isPanning = false;
							    });
							})();
							
							
							// [정보 적용] 버튼 클릭 시 실행될 전역 함수
							window.applyElementInfo = function () {
							    const typeEl = document.getElementById("selectedElementType");
							    const currentType = typeEl ? typeEl.value : "";
							    const elemName = document.getElementById("elemName");
							    const elemDesc = document.getElementById("elemDesc");

							    console.log("현재 currentType:", typeof currentType !== 'undefined' ? currentType : '없음');
							    console.log("현재 selectedFacility:", window.selectedFacility);

							    // 1. 구역(ZONE) 정보 업데이트
							    if (currentType === "ZONE" && window.selectedZone) {
							        window.selectedZone.name = elemName ? elemName.value : "";
							        window.selectedZone.description = elemDesc ? elemDesc.value : "";

							        const elemAgent = document.getElementById("elemAgent");
							        window.selectedZone.agentId = elemAgent ? elemAgent.value : "";

							        const elemColor = document.getElementById("elemColor");
							        if (elemColor) {
							            const hexColor = elemColor.value;
							            const r = parseInt(hexColor.slice(1, 3), 16);
							            const g = parseInt(hexColor.slice(3, 5), 16);
							            const b = parseInt(hexColor.slice(5, 7), 16);
							            window.selectedZone.color = `rgba(${r}, ${g}, ${b}, 0.35)`;
							        }

							        if (typeof redrawCanvas === "function") redrawCanvas();
							        alert("구역 정보가 적용되었습니다.");
							    } 
							    // 2. 시설물(FACILITY) 정보 업데이트
							    else if (currentType === "FACILITY" && window.selectedFacility) {
							        const newName = elemName ? elemName.value : "";
							        const newDesc = elemDesc ? elemDesc.value : "";
							        const elemStreamUrl = document.getElementById("elemStreamUrl");
							        const newStreamUrl = elemStreamUrl ? elemStreamUrl.value : "";

							        // 선택 객체 변경
							        window.selectedFacility.name = newName;
							        window.selectedFacility.description = newDesc;
							        window.selectedFacility.streamUrl = newStreamUrl;

							        // DB로 전송될 savedFacilities 배열 내부 원본 데이터 동기화
							        if (window.savedFacilities) {
							            const target = window.savedFacilities.find(f => f.id === window.selectedFacility.id);
							            if (target) {
							                target.name = newName;
							                target.description = newDesc;
							                target.streamUrl = newStreamUrl;
							            }
							        }

							        alert("시설물 정보가 적용되었습니다.");
							    } else {
							        alert("선택된 구역이나 시설물이 없습니다.");
							    }
							};
							
							
							// DB에서 안전요원 목록을 조회하여 드롭다운 옵션 채우기
							function loadAgentList() {
							    fetch("/admin/api/agents")
							        .then(res => {
							            if (!res.ok) throw new Error("네트워크 응답 이상: " + res.status);
							            return res.json();
							        })
							        .then(agents => {
							            const elemAgent = document.getElementById("elemAgent");
							            if (!elemAgent) return;

							            // 기본 선택지만 남기고 초기화
							            elemAgent.innerHTML = '<option value="">-- 요원 선택 --</option>';

							            // userId에 'agent'가 포함된 유저만 필터링해서 드롭다운에 추가
							            agents
							                .filter(agent => agent.userId && agent.userId.includes("agent")) // 👈 이 줄 추가!
							                .forEach(agent => {
							                    const option = document.createElement("option");
							                    option.value = agent.userId;
							                    const nameDisplay = agent.userName ? `${agent.userName} (${agent.userId})` : agent.userId;
							                    option.textContent = nameDisplay;
							                    elemAgent.appendChild(option);
							                });
							        })
							        .catch(err => console.error("요원 목록 로드 실패:", err));
							}

							
							// 구역 상세 폼의 '담당 안전요원 배치' 드롭다운 옵션 갱신
							function populateAgentSelectOptions() {
							    const elemAgent = document.getElementById("elemAgent");
							    if (!elemAgent) return;

							    // 현재 선택되어 있던 값(기존 agentId) 기억
							    const currentSelectedValue = elemAgent.value;

							    // 기본 옵션만 남기고 초기화
							    elemAgent.innerHTML = '<option value="">-- 요원 선택 --</option>';

							    // currentAgentList(활성화된 요원 목록)가 존재하면 옵션 생성
							    if (Array.isArray(window.currentAgentList) || Array.isArray(currentAgentList)) {
							        const list = window.currentAgentList || currentAgentList;
							        
							        list.forEach(agent => {
							            const option = document.createElement("option");
							            option.value = agent.id || agent.userId; // DB에 저장되는 ID 필드명에 맞춰 설정
							            option.textContent = `${agent.userName || agent.name || agent.userId} (${agent.userId})`;
							            elemAgent.appendChild(option);
							        });
							    }

							    // 기존에 선택되어 있던 값이 있다면 다시 복구
							    if (currentSelectedValue) {
							        elemAgent.value = currentSelectedValue;
							    }
							}
							
							
							
							
							
							// 스크립트 실행
							loadAgentList();
									
							// 4. 페이지 로드 시 저장된 데이터 불러오기
							loadSavedAreaConfig();
			
			
}

initAreaManagement();