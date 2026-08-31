<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <!-- 모바일 전용 뷰포트 설정 (화면 비율 및 확대 방지) -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>행사장 안전관리 시스템 - 안전요원</title>
    <!-- 아이콘 폰트 (FontAwesome) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 모바일 전용 CSS (추후 작성) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentMain.css">
	<!-- 카카오맵 API 로드 -->
<script type="text/javascript" src="http://dapi.kakao.com/v2/maps/sdk.js?appkey=893d42a705b8275bf35865b1d40e6d96&autoload=false"></script>
</head>
<body>

    <div class="mobile-container">
        <!-- 1. 상단 파란색 헤더 (프로필 및 알림) -->
        <header class="mobile-header">
            <div class="user-info">
                <i class="fa-solid fa-user-circle profile-icon"></i>
                <span class="user-name">김이슬 요원</span>
                <span class="badge-work">근무중</span>
            </div>
            <div class="header-right">
                <div class="notification-bell">
                    <i class="fa-solid fa-bell"></i>
                    <span class="bell-count">2</span>
                </div>
            </div>
        </header>

        <!-- 2. 본문 메인 콘텐츠 영역 -->
        <main class="mobile-content">
            <!-- 1. 현재 위험 알림 카드 -->
				<div class="alert-card">
				    <div class="alert-header">
				        <i class="fa-solid fa-circle-exclamation alert-icon"></i>
				        <span class="alert-title">현재 위험 알림</span>
				    </div>
				    <div class="alert-body">
				        <p class="alert-desc">A구역 인원 밀집도가 위험 수준을 초과했습니다.</p>
				        <div class="alert-location">
				            <i class="fa-solid fa-location-dot pin-icon"></i>
				            <span>A구역 · 인원 밀집도 78%</span>
				        </div>
				    </div>
				</div>
				
				<!-- 2. 내 위치 및 담당 구역 (지도) -->
					<div class="map-card">
					    <div class="map-card-header">
					        <span class="map-card-title">내 위치 및 담당 구역</span>
					    </div>
					    <div class="map-container">
					        <div id="agent-map"></div>
					    </div>
					</div>
					
				<!-- 3. 주요 액션 버튼 (상황 보고 / 긴급 보고) -->
				<div class="action-btn-group">
				    <button type="button" class="btn-action btn-report" onclick="location.href='${pageContext.request.contextPath}/agent/report'">
				        <i class="fa-solid fa-briefcase"></i>
				        <span>상황 보고</span>
				    </button>
				    <button type="button" class="btn-action btn-emergency" onclick="location.href='${pageContext.request.contextPath}/agent/emergency'">
				        <i class="fa-solid fa-user-shield"></i>
				        <span>긴급 보고</span>
				    </button>
				</div>
				
				<!-- 4. 안전수칙 게시글 리스트 -->
				<div class="rules-card">
				    <div class="rules-card-header">
				        <span class="rules-card-title">안전수칙</span>
				    </div>
				    <ul class="rules-list">
					    <li class="rules-item" 
					        data-title="인파 밀집 발생 시 대응 요령" 
					        data-date="2026.05.20" 
					        data-content="1. 즉시 현장 상황을 파악하고 관제 센터에 보고합니다.&#10;2. 이동 동선을 확보하여 보행자의 일방통행을 유도합니다.&#10;3. 확성기를 통해 이동 안내 방송을 지속적으로 실시합니다.">
					        <span class="badge-guide">[안내]</span>
					        <span class="rules-text">인파 밀집 발생 시 대응 요령</span>
					        <span class="rules-date">05.20</span>
					    </li>
					    <li class="rules-item" 
					        data-title="야생동물 발견 시 행동 요령" 
					        data-date="2026.05.19" 
					        data-content="1. 야생동물 자극 금지 (소리지르기, 돌 던지기 등)&#10;2. 등 또는 뒷모습을 보이지 말고 천천히 대피합니다.&#10;3. 안전 통제선 설치 후 종합 상황실로 즉시 연락합니다.">
					        <span class="badge-notice">[공지]</span>
					        <span class="rules-text">야생동물 발견 시 행동 요령</span>
					        <span class="rules-date">05.19</span>
					    </li>
					</ul>
				</div>
        </main>

        <!-- 3. 하단 네비게이션 탭바 -->
        <nav class="bottom-nav">
            <a href="${pageContext.request.contextPath}/agent/main" class="nav-item active" >
                <i class="fa-solid fa-house"></i>
                <span>홈</span>
            </a>
            <a href="${pageContext.request.contextPath}/agent/history" class="nav-item">
                <i class="fa-solid fa-clipboard-list"></i>
                <span>업무</span>
            </a>
            <a href="#" class="nav-item">
                <i class="fa-solid fa-user"></i>
                <span>정보</span>
            </a>
        </nav>
        
        <!-- 안전수칙 모달 팝업 -->
			<div id="rulesModal" class="modal-overlay">
			    <div class="modal-content">
			        <div class="modal-header">
			            <h3 id="modalTitle" class="modal-title">안전수칙</h3>
			            <button type="button" id="closeModalBtn" class="modal-close">&times;</button>
			        </div>
			        <div class="modal-body">
			            <p id="modalDate" class="modal-date">작성일: 2026.05.20</p>
			            <div id="modalBodyText" class="modal-text">
			                [...]
			            </div>
			        </div>
			    </div>
			</div>
        
        
    </div>

</body>

<script>
kakao.maps.load(function() {
    var container = document.getElementById('agent-map');
    var myPosition = new kakao.maps.LatLng(36.3504, 127.3845); // 예시: 대전 중심/현장 위치
    var dangerPosition = new kakao.maps.LatLng(36.3512, 127.3855); // 위험 구역 위치

    var options = {
        center: myPosition,
        level: 3
    };

    var map = new kakao.maps.Map(container, options);

    // 1. 내 위치 마커 생성 (초록색 핀 아이콘 등)
    var myMarker = new kakao.maps.Marker({
        position: myPosition,
        map: map
    });

    // 2. 위험 구역 마커 생성
    var dangerMarker = new kakao.maps.Marker({
        position: dangerPosition,
        map: map
    });

    // 3. 위험 구역 서클(원) 표시 (이미지 시안의 빨간 반경)
    var circle = new kakao.maps.Circle({
        center: dangerPosition,
        radius: 60, // 미터 단위
        strokeWeight: 1,
        strokeColor: '#ef4444',
        strokeOpacity: 0.8,
        strokeStyle: 'solid',
        fillColor: '#ef4444',
        fillOpacity: 0.2
    });

    circle.setMap(map);
});

document.addEventListener("DOMContentLoaded", function() {
    var modal = document.getElementById("rulesModal");
    var closeBtn = document.getElementById("closeModalBtn");
    var ruleItems = document.querySelectorAll(".rules-item");

    // 안전수칙 항목 클릭 시 모달 열기
    ruleItems.forEach(function(item) {
        item.style.cursor = "pointer";
        item.addEventListener("click", function() {
            var title = this.getAttribute("data-title");
            var date = this.getAttribute("data-date");
            var content = this.getAttribute("data-content");

            document.getElementById("modalTitle").innerText = title;
            document.getElementById("modalDate").innerText = "작성일: " + date;
            document.getElementById("modalBodyText").innerText = content;

            modal.classList.add("active");
        });
    });

    // 닫기 버튼(X) 클릭 시 모달 닫기
    closeBtn.addEventListener("click", function() {
        modal.classList.remove("active");
    });

    // 모달 바깥 배경 클릭 시 닫기
    modal.addEventListener("click", function(event) {
        if (event.target === modal) {
            modal.classList.remove("active");
        }
    });
});
</script>
</html>