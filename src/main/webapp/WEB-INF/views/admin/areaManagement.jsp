<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="festival-container">

    <!-- 1. 상단 툴바 (도면 업로드, 레이어 토글, 드로잉 도구) -->
    <div class="festival-card top-toolbar">
        <div class="toolbar-group">
            <label class="btn-file-upload">
                <i class="fa-solid fa-file-image"></i> 도면 업로드
                <input type="file" id="uploadMapImage" accept="image/*" style="display: none;">
            </label>
            <span class="divider"></span>
            <button type="button" class="tool-btn active" id="btnModeSelect"><i class="fa-solid fa-hand"></i> 선택/이동</button>
            <button type="button" class="tool-btn" id="btnModePolygon"><i class="fa-solid fa-draw-polygon"></i> 구역 그리기</button>
        </div>

        <!-- 레이어 On/Off 토글 버튼 -->
        <div class="toolbar-group layer-toggles">
            <span class="toolbar-label"><i class="fa-solid fa-layer-group"></i> 레이어:</span>
            <button type="button" class="toggle-btn active" id="toggleZoneLayer" data-layer="zone">
                <i class="fa-solid fa-eye"></i> 구역
            </button>
            <button type="button" class="toggle-btn active" id="toggleFacilityLayer" data-layer="facility">
                <i class="fa-solid fa-eye"></i> 시설물
            </button>
        </div>

        <div class="toolbar-group">
            <button type="button" class="mini-btn danger" id="btnDeleteSelected"><i class="fa-solid fa-trash"></i> 선택 삭제</button>
            <button type="button" class="btn-success" id="btnExportJson"><i class="fa-solid fa-floppy-disk"></i> 최종 데이터 저장</button>
        </div>
    </div>

    <!-- 2. 하단 메인 워크스페이스 영역 (좌: 캔버스 / 우: 속성 패널) -->
    <div class="main-workspace">
        
        <!-- 좌측: 메인 도면 뷰포트 카드 -->
        <div class="festival-card map-viewport-card">
            <div class="panel-header">
                <h3 class="panel-title"><i class="fa-solid fa-map"></i> 행사장 도면 편집기</h3>
                <span class="zoom-info" id="zoomLevel">100%</span>
            </div>

            <!-- 도면 캔버스 오버레이 래퍼 -->
			<div class="map-container-wrapper" id="mapWrapper">
			    <!-- (1) 배경 도면 이미지 -->
			    <img id="bgMapImage" src="" alt="행사장 도면을 업로드하세요" class="bg-map-img" style="display:none;">
			
			    <!-- (2) 구역(Polygon) 드로잉 Canvas Layer -->
			    <canvas id="zoneCanvas" class="drawing-layer"></canvas>
			
			    <!-- (3) 시설물 아이콘(Marker) 배치 DOM Layer -->
			    <div id="facilityLayer" class="facility-dom-layer"></div>
			
			    <!-- 도면 미업로드 시 안내 메시지 -->
			    <div class="empty-map-notice" id="emptyNotice">
			        <i class="fa-solid fa-cloud-arrow-up"></i>
			        <p>상단의 [도면 업로드] 버튼을 눌러 행사장 평면도 이미지를 등록하세요.</p>
			    </div>
			</div>

            <!-- 하단 시설물 아이콘 툴바 (드래그앤드롭 배치용) -->
            <div class="facility-drag-bar">
                <span class="bar-title"></span>
                <div class="facility-chip" data-type="CCTV" draggable="true"><i class="fa-solid fa-video"></i> 드론</div>
                <div class="facility-chip" data-type="EMERGENCY" draggable="true"><i class="fa-solid fa-user-shield"></i> 안전요원</div>
                <div class="facility-chip" data-type="FIRE_EXT" draggable="true"><i class="fa-solid fa-fire-extinguisher"></i> 소화기</div>
                <div class="facility-chip" data-type="INFO" draggable="true"><i class="fa-solid fa-circle-info"></i> 안내소</div>
                <div class="facility-chip" data-type="MEDICAL" draggable="true"><i class="fa-solid fa-kit-medical"></i> 의무실</div>
                <div class="facility-chip" data-type="RESTROOM" draggable="true"><i class="fa-solid fa-restroom"></i> 화장실</div>
            </div>
        </div>

        <!-- 우측: 선택한 요소 세부 정보 설정 패널 -->
        <div class="festival-card detail-panel">
            <!-- 1. 상단 타이틀 (고정 영역) -->
            <div class="panel-header">
                <h3 class="panel-title" id="selectedTitle"><i class="fa-solid fa-sliders"></i> 선택 요소 정보</h3>
            </div>

            <div class="panel-body">
                <!-- 선택 요소가 없을 때 -->
                <div class="empty-detail-msg" id="emptyDetailMsg">
                    <i class="fa-solid fa-mouse-pointer"></i>
                    <p>도면 상의 구역 을 클릭하면 세부 정보를 수정할 수 있습니다.</p>
                </div>

                <!-- 선택 시 나타나는 속성 폼 (기본 숨김 -> 테스트 시 style="" 로 풀어서 확인 가능) -->
                <form id="elementDetailForm" class="info-form" style="display: none;">
                    <input type="hidden" id="selectedElementId" />
                    <input type="hidden" id="selectedElementType" /> <!-- ZONE or FACILITY -->

                    <div class="form-group">
                        <label class="form-label">유형</label>
                        <input type="text" id="elemTypeDisplay" class="form-input" readonly />
                    </div>

                    <div class="form-group">
                        <label class="form-label">명칭 (이름)</label>
                        <input type="text" id="elemName" class="form-input" placeholder="예: 1구역 (메인무대)" />
                    </div>

                    <div class="form-group">
                        <label class="form-label">상세 설명</label>
                        <textarea id="elemDesc" class="form-textarea" rows="3" placeholder="구역 또는 아이콘에 대한 상세 정보 입력"></textarea>
                    </div>

                    <!-- 구역(Zone) 클릭 시 표시할 전체 영역 -->
					<div class="zone-only-fields" style="display: none;">
					    <div class="form-group">
					        <label class="form-label">구역 채우기 색상</label>
					        <input type="color" id="elemColor" class="form-color-picker" value="#38bdf8" />
					    </div>
					    <div class="form-group">
					        <label class="form-label">담당 안전요원 배치</label>
					        <select id="elemAgent" class="form-select">
					            <option value="">-- 요원 선택 --</option>
					            <!-- AJAX로 요원 목록 동적 로드 -->
					        </select>
					    </div>
					    <div class="form-group">
					        <label class="form-label">스트리밍 IP / RTSP URL</label>
					        <input type="text" id="elemStreamUrl" class="form-input" placeholder="rtsp://192.168.0.100:554/stream" />
					    </div>
					</div>

                    <div class="form-actions">
                        <button type="button" class="btn-primary" id="btnApplyElement" onclick="applyElementInfo()"><i class="fa-solid fa-check"></i> 정보 적용</button>
                    </div>
                </form>
            </div>
        </div>

    </div> <!-- .main-workspace 끝 -->

</div> <!-- .festival-container 끝 -->
<!-- 맨 밑 </div> 태그 바로 아래에 추가 -->
<script src="${pageContext.request.contextPath}/resources/js/admin/areaManagement.js"></script>