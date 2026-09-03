<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관제구역 관리</title>
    <!-- 외부 CSS 불러오기 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/areaManagement.css">
    <!-- 카카오맵 API (Drawing 라이브러리 포함) -->
    <!-- appkey 부분은 실제 발급받으신 자바스크립트 키로 대체하세요 -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_JAVASCRIPT_APP_KEY&libraries=drawing,services"></script>
</head>
<body>

    <div class="area-container">
        
        <!-- 1. 좌측: 구역 목록 패널 -->
        <div class="area-card area-list-panel">
            <div class="panel-header">
                <h2 class="panel-title">구역 목록</h2>
            </div>
            
            <div class="search-box">
                <input type="text" id="searchAreaInput" class="form-input" placeholder="구역명 검색">
                <button type="button" class="btn-search">🔍</button>
            </div>

            <div class="area-list" id="areaList">
                <!-- 구역 아이템 예시 (스크립트로 동적 생성 가능) -->
                <div class="area-item active">
                    <div class="area-item-header">
                        <span class="area-name">구역 A (푸드존)</span>
                        <span class="badge badge-active">활성</span>
                    </div>
                    <div class="area-item-info">
                        <span>면적: 12,540 m²</span>
                        <span>안전요원: 0/8</span>
                    </div>
                </div>

                <div class="area-item">
                    <div class="area-item-header">
                        <span class="area-name">구역 B (산책로)</span>
                        <span class="badge badge-inactive">비활성</span>
                    </div>
                    <div class="area-item-info">
                        <span>면적: 8,320 m²</span>
                        <span>안전요원: 0/6</span>
                    </div>
                </div>
            </div>

            <button type="button" class="btn-primary btn-add-area" id="btnAddArea">+ 구역 추가</button>
        </div>

        <!-- 2. 중앙: 구역 세부 정보 상세 설정 패널 -->
        <div class="area-card area-info-panel">
            <div class="panel-header">
                <h2 class="panel-title">구역 정보</h2>
            </div>

            <form id="areaDetailForm" class="info-form">
                <div class="form-group">
                    <label class="form-label" for="areaName">구역명</label>
                    <input type="text" id="areaName" class="form-input" value="구역 A (푸드존)">
                </div>

                <div class="form-group">
                    <label class="form-label">면적</label>
                    <div class="readonly-value" id="areaSize">12,540 m²</div>
                </div>

                <div class="form-group">
                    <label class="form-label">탐지 대상</label>
                    <div class="readonly-value">사람, 야생동물, 안전요원</div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="detectInterval">탐지 주기</label>
                    <select id="detectInterval" class="form-select">
                        <option value="0.5">0.5 초</option>
                        <option value="0.8" selected>0.8 초</option>
                        <option value="1.0">1.0 초</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="retentionPeriod">이벤트 기록 보관 기간</label>
                    <select id="retentionPeriod" class="form-select">
                        <option value="7">7 일</option>
                        <option value="14" selected>14 일</option>
                        <option value="30">30 일</option>
                    </select>
                </div>

                <div class="form-group row-group">
                    <label class="form-label">활성 상태</label>
                    <label class="switch">
                        <input type="checkbox" id="areaStatus" checked>
                        <span class="slider"></span>
                    </label>
                </div>

                <div class="form-group">
                    <label class="form-label" for="areaMemo">메모</label>
                    <textarea id="areaMemo" class="form-textarea" rows="3">푸드트럭 및 휴게 공간 포함 구역</textarea>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-danger" id="btnDelete">삭제</button>
                    <button type="submit" class="btn-success" id="btnSave">저장 (State 저장)</button>
                </div>
            </form>
        </div>

        <!-- 3. 우측: 카카오맵 지도 & 드로잉 영역 -->
        <div class="area-card area-map-panel">
            <div class="panel-header">
                <h2 class="panel-title">구역 지도 (편집 모드)</h2>
                <div class="map-controls">
                    <button type="button" class="btn-secondary" id="btnDrawPolygon">📐 영역 그리기</button>
                    <button type="button" class="btn-secondary" id="btnClearDraw">🗑️ 영역 삭제</button>
                    <button type="button" class="btn-primary" id="btnToggleEdit">✏️ 편집 시작</button>
                </div>
            </div>

            <div class="map-wrapper">
                <!-- 카카오맵 랜더링 피치 -->
                <div id="kakaoMap" class="map-view"></div>
            </div>

            <!-- 하단 시설물 아이콘 툴바 (필요 시 활용) -->
            <div class="facility-toolbar">
                <span class="toolbar-title">시설물 배치:</span>
                <div class="facility-item" data-type="PARKING">🅿️ 주차장</div>
                <div class="facility-item" data-type="RESTROOM">🚻 화장실</div>
                <div class="facility-item" data-type="INFO">ℹ️ 안내소</div>
                <div class="facility-item" data-type="MEDICAL">➕ 의무실</div>
                <div class="facility-item" data-type="CCTV">📷 CCTV</div>
            </div>
        </div>

    </div>

</body>
</html>