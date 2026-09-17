<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Pretendard 고급 웹폰트 CDN 로드 -->
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />

<!-- 1. 우측 60px 고정 퀵바 (관리자 전용 아이콘) -->
<aside class="quick-sidebar">
    <div class="quick-top">
        <button id="toggle-drawer-btn" class="quick-btn toggle-btn" title="사이드바 열기/닫기">
            ❮❮
        </button>
    </div>

    <nav class="quick-nav">
    <!-- 1) 대시보드 요약 -->
    <button class="quick-nav-item active" data-target="panel-admin-dashboard">
        <span class="nav-icon"><i class="fa-solid fa-mask-ventilator"></i></span>
        <span class="nav-label">드론</span>
    </button>

    <!-- 2) 안전요원 관리 -->
    <button class="quick-nav-item" data-target="panel-admin-agents">
        <span class="nav-icon"><i class="fa-solid fa-users-gear"></i></span>
        <span class="nav-label">요원</span>
    </button>

    <!-- 3) 이력/보고서 -->
    <button class="quick-nav-item" data-target="panel-admin-reports">
        <span class="nav-icon"><i class="fa-solid fa-file-invoice"></i></span>
        <span class="nav-label">이력</span>
    </button>

    <!-- 4) 비상연락망 관리 -->
    <button class="quick-nav-item" data-target="panel-admin-emergency">
        <span class="nav-icon"><i class="fa-solid fa-address-book"></i></span>
        <span class="nav-label">연락망</span>
    </button>

    <!-- 🎯 5) 사이드바 하단 고정 로그아웃 버튼 -->
    <button type="button" class="quick-nav-item btn-sidebar-logout" onclick="location.href='${pageContext.request.contextPath}/logout'">
        <span class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>
        <span class="nav-label">로그아웃</span>
    </button>
</nav>
</aside>

<!-- 2. 왼쪽으로 열리는 260px 서브 드로어 패널 -->
<div id="sub-drawer" class="sub-drawer">
    
    <!-- 1) 대시보드 요약 패널 -->
<div id="panel-admin-dashboard" class="drawer-content active">
    <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
        <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">드론 목록</span>
    </div>
    <div class="drawer-body">
        <!-- 💡 드론 리스트가 동적으로 생성될 영역 -->
        <div id="adminDroneListContainer"></div>
    </div>
</div>

    <!-- 2) 안전요원 관리 패널 -->
<div id="panel-admin-agents" class="drawer-content">
    <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
        <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">안전요원 관리</span>
    </div>
    <div class="drawer-body">
        
        
        <!-- 👈 요원 목록이 리스트 형태로 담길 컨테이너 추가 -->
        <div id="agentListContainer" class="agent-list-container" style="margin-top: 10px;">
            <!-- JS에서 요원 목록을 여기에 동적으로 생성합니다 -->
        </div>
    </div>
</div>

<!-- 3) 관제 이력/보고서 패널 -->
<div id="panel-admin-reports" class="drawer-content">
    <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px; border-bottom: 1px solid #333; padding-bottom: 8px;">
        <span style="font-size: 15px; font-weight: 700; white-space: nowrap;"><i class="fa-solid fa-clipboard-check" style="color: #007bff;"></i> 안전점검 제출 현황</span>
        <button type="button" id="btn-refresh-history" class="mini-btn" style="background: transparent; border: none; color: #aaa; cursor: pointer;" title="새로고침">
            <i class="fa-solid fa-arrows-rotate"></i>
        </button>
    </div>

    <!-- 제출 이력 요약 카드 리스트 영역 -->
    <div class="drawer-body" id="history-list-container" style="padding: 10px 0; display: flex; flex-direction: column; gap: 10px; overflow-y: auto; max-height: calc(100vh - 120px);">
        <!-- AJAX로 이력 카드 목록이 여기에 동적 생성됩니다 -->
    </div>
</div>


    <!-- 4) 비상연락망 관리 패널 -->
	<div id="panel-admin-emergency" class="drawer-content">
	    <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 36px; min-height: 36px; margin-bottom: 4px;">
	        <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">비상연락망 관리</span>
	        
	        <!-- 깔끔한 + 아이콘 버튼 -->
	        <button type="button" onclick="openEmergencyContactModal()" title="연락처 추가"
	                style="background: rgb(0, 0, 0); border: none; color: #fff; width: 28px; height: 28px; border-radius: 6px; cursor: pointer; display: flex; align-items: center; justify-content: center; box-shadow: 0 0 8px rgba(56, 189, 248, 0.4);">
	            <i class="fa-solid fa-plus" style="font-size: 13px;"></i>
	        </button>
	    </div>
	    
	    <div class="drawer-body" style="padding-top: 0;">
	        <!-- 💡 [위치 바짝 올린] 카테고리 필터 탭 -->
	        <div class="emergency-tab-group" style="display: flex; gap: 4px; margin: 4px 0 10px 0; background: rgba(0,0,0,0.2); padding: 3px; border-radius: 6px;">
	            <button type="button" class="emg-tab-btn active" data-category="ALL" onclick="filterEmergencyCategory('ALL', this)"
	                    style="flex: 1; padding: 5px 0; font-size: 11px; background: rgb(0, 0, 0); color: #fff; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; transition: all 0.2s;">전체</button>
	            <button type="button" class="emg-tab-btn" data-category="HOST" onclick="filterEmergencyCategory('HOST', this)"
	                    style="flex: 1; padding: 5px 0; font-size: 11px; background: transparent; color: #a0aec0; border: none; border-radius: 4px; cursor: pointer; transition: all 0.2s;">주최측</button>
	            <button type="button" class="emg-tab-btn" data-category="AGENCY" onclick="filterEmergencyCategory('AGENCY', this)"
	                    style="flex: 1; padding: 5px 0; font-size: 11px; background: transparent; color: #a0aec0; border: none; border-radius: 4px; cursor: pointer; transition: all 0.2s;">유관기관</button>
	            <button type="button" class="emg-tab-btn" data-category="MEDICAL" onclick="filterEmergencyCategory('MEDICAL', this)"
	                    style="flex: 1; padding: 5px 0; font-size: 11px; background: transparent; color: #a0aec0; border: none; border-radius: 4px; cursor: pointer; transition: all 0.2s;">의료</button>
	        </div>
	
	        <!-- 비상연락망 목록 컨테이너 -->
	        <div id="emergencyContactListContainer"></div>
	    </div>
	</div>

</div>



<!-- 요원 상세 정보 모달 (딥 & 드림 오로라 테마) -->
<div id="agentDetailModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(5, 7, 15, 0.85); z-index: 99999; justify-content: center; align-items: center; backdrop-filter: blur(8px);">
    
    <!-- 모달 카드 컨테이너 -->
    <div style="background: radial-gradient(circle at 0% 0%, #1a102f 0%, #0d1127 50%, #080914 100%); border: 1px solid rgba(147, 51, 234, 0.25); border-radius: 16px; width: 360px; padding: 24px; color: #f1f5f9; box-shadow: 0 20px 50px rgba(0, 0, 0, 0.8), 0 0 30px rgba(126, 34, 206, 0.12); position: relative; z-index: 100000;">
        
        <!-- 헤더 -->
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.06); padding-bottom: 14px; margin-bottom: 18px;">
            <div style="display: flex; align-items: center; gap: 8px;">
                <span style="display: inline-block; width: 7px; height: 7px; border-radius: 50%; background: #a855f7; box-shadow: 0 0 10px #a855f7;"></span>
                <h3 style="margin: 0; font-size: 15px; font-weight: 700; color: #e2e8f0; letter-spacing: -0.3px;">안전요원 상세 정보</h3>
            </div>
            <button type="button" onclick="closeAgentModal()" style="background: none; border: none; color: #64748b; font-size: 18px; cursor: pointer; padding: 0; transition: color 0.2s;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#64748b'">✕</button>
        </div>
        
        <!-- 바디 -->
        <div style="display: flex; flex-direction: column; gap: 12px; font-size: 13px;">
            <div style="display: flex; justify-content: space-between; align-items: center; background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.03); padding: 9px 14px; border-radius: 8px;">
                <span style="color: #64748b;">이름</span>
                <strong id="modalAgentName" style="color: #f1f5f9; font-size: 14px;">-</strong>
            </div>
            <div style="display: flex; justify-content: space-between; align-items: center; background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.03); padding: 9px 14px; border-radius: 8px;">
                <span style="color: #64748b;">아이디</span>
                <span id="modalAgentId" style="color: #38bdf8; font-weight: 600; font-family: monospace;">-</span>
            </div>
            <div style="display: flex; justify-content: space-between; align-items: center; background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.03); padding: 9px 14px; border-radius: 8px;">
                <span style="color: #64748b;">연락처</span>
                <span id="modalAgentPhone" style="color: #cbd5e1;">-</span>
            </div>
            <div style="display: flex; justify-content: space-between; align-items: center; background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.03); padding: 9px 14px; border-radius: 8px;">
                <span style="color: #64748b;">이메일</span>
                <span id="modalAgentEmail" style="color: #cbd5e1;">-</span>
            </div>
            <div style="display: flex; justify-content: space-between; align-items: center; background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.03); padding: 9px 14px; border-radius: 8px;">
                <span style="color: #64748b;">계정 상태</span>
                <span id="modalAgentStatus" style="color: #34d399; font-weight: 600;">-</span>
            </div>
        </div>
        
        <!-- 푸터 -->
        <div style="margin-top: 22px; text-align: right;">
            <button type="button" onclick="closeAgentModal()" style="background: rgba(255, 255, 255, 0.05); color: #cbd5e1; border: 1px solid rgba(255,255,255,0.08); padding: 8px 18px; border-radius: 8px; cursor: pointer; font-size: 12px; font-weight: 500; transition: all 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.1)'; this.style.color='#fff';" onmouseout="this.style.background='rgba(255,255,255,0.05)'; this.style.color='#cbd5e1';">닫기</button>
        </div>
    </div>
</div>


<!-- ========================================== -->
<!-- 체크리스트 상세 보기 공통 모달 (테마 통일) -->
<!-- ========================================== -->
<div id="checklistDetailModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(5, 7, 15, 0.85); z-index: 99999; justify-content: center; align-items: center; backdrop-filter: blur(8px);">
    
    <div style="background: radial-gradient(circle at 0% 0%, #1a102f 0%, #0d1127 50%, #080914 100%); border: 1px solid rgba(147, 51, 234, 0.25); border-radius: 16px; width: 680px; max-width: 90%; max-height: 85vh; padding: 24px; color: #f1f5f9; box-shadow: 0 20px 50px rgba(0, 0, 0, 0.8), 0 0 30px rgba(126, 34, 206, 0.12); display: flex; flex-direction: column; position: relative; z-index: 100000;">
        
        <!-- 헤더 -->
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.06); padding-bottom: 14px; margin-bottom: 14px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <h3 id="modal-user-title" style="margin: 0; font-size: 16px; font-weight: 700; color: #e2e8f0;">점검 상세 내역</h3>
                <span id="modal-target-badge" style="padding: 3px 8px; border-radius: 4px; font-size: 11px; font-weight: 600;">요원</span>
            </div>
            <button type="button" class="btn-close-modal" style="background: none; border: none; color: #64748b; font-size: 18px; cursor: pointer;">✕</button>
        </div>

        <!-- 서브 요약 바 -->
        <div style="background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.03); padding: 10px 14px; border-radius: 8px; display: flex; justify-content: space-between; font-size: 13px; color: #94a3b8; margin-bottom: 14px;">
            <div>제출시간: <span id="modal-check-date" style="color: #fff;">-</span></div>
            <div id="modal-status-summary" style="display: flex; gap: 10px; font-weight: 600;"></div>
        </div>

        <!-- 본문 (스크롤) -->
        <div id="modal-detail-body" style="overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 12px; padding-right: 4px;">
            <!-- 동적 데이터 영역 -->
        </div>

        <!-- 푸터 -->
        <div style="margin-top: 18px; text-align: right; border-top: 1px solid rgba(255, 255, 255, 0.06); padding-top: 14px;">
            <button type="button" class="btn-close-modal" style="background: rgba(255, 255, 255, 0.05); color: #cbd5e1; border: 1px solid rgba(255,255,255,0.08); padding: 8px 18px; border-radius: 8px; cursor: pointer; font-size: 12px;">닫기</button>
        </div>
    </div>
</div>


<!-- 비상연락망 등록/수정 모달 -->
<div id="emergencyContactModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.7); z-index: 9999; justify-content: center; align-items: center;">
    <div style="background: #1e1e2d; border: 1px solid #2b2b40; border-radius: 8px; width: 360px; padding: 20px; color: #fff;">
        <h3 id="emergencyModalTitle" style="margin-top: 0; font-size: 16px; margin-bottom: 15px;">비상연락처 등록</h3>
        
        <input type="hidden" id="emgContactId">

        <div style="margin-bottom: 12px;">
            <label style="display: block; font-size: 12px; color: #a0aec0; margin-bottom: 4px;">카테고리</label>
            <select id="emgCategory" style="width: 100%; background: #151521; border: 1px solid #363654; color: #fff; padding: 8px; border-radius: 4px;">
                <option value="HOST">행사 주최측</option>
                <option value="AGENCY">유관기관</option>
                <option value="MEDICAL">의료 인프라</option>
            </select>
        </div>

        <div style="margin-bottom: 12px;">
            <label style="display: block; font-size: 12px; color: #a0aec0; margin-bottom: 4px;">구분 / 기관명</label>
            <input type="text" id="emgTitle" placeholder="예: 종합상황실 직통" style="width: 100%; background: #151521; border: 1px solid #363654; color: #fff; padding: 8px; border-radius: 4px; box-sizing: border-box;">
        </div>

        <div style="margin-bottom: 12px;">
            <label style="display: block; font-size: 12px; color: #a0aec0; margin-bottom: 4px;">연락처 / 채널</label>
            <input type="text" id="emgPhone" placeholder="예: 02-1234-5678" style="width: 100%; background: #151521; border: 1px solid #363654; color: #fff; padding: 8px; border-radius: 4px; box-sizing: border-box;">
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display: block; font-size: 12px; color: #a0aec0; margin-bottom: 4px;">정렬 순서</label>
            <input type="number" id="emgSortOrder" value="1" style="width: 100%; background: #151521; border: 1px solid #363654; color: #fff; padding: 8px; border-radius: 4px; box-sizing: border-box;">
        </div>

        <div style="display: flex; justify-content: flex-end; gap: 8px;">
            <button type="button" onclick="closeEmergencyContactModal()" style="background: #363654; border: none; color: #fff; padding: 8px 14px; border-radius: 4px; cursor: pointer;">취소</button>
            <button type="button" onclick="saveEmergencyContact()" style="background: #38bdf8; border: none; color: #fff; padding: 8px 14px; border-radius: 4px; cursor: pointer;">저장</button>
        </div>
    </div>
</div>








<!-- ContextPath 전달 -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/resources/js/drone-sidebar.js"></script>





<!-- ContextPath 전달 및 안전요원 목록 로드 스크립트 -->
<script>

//어드민 사이드바 패널에 드론 목록을 뿌려주는 함수
function renderAdminDroneList() {
    var ctx = window.contextPath || '';
    var $container = $('#adminDroneListContainer');

    if (!$container.length) return;

    $.ajax({
        url: ctx + '/drone/api/list',
        type: 'GET',
        dataType: 'json',
        success: function(drones) {
            
            // 💡 [추가] KPI 카드의 비행중 드론 수 동적 업데이트
            var $kpiDroneValue = $('.kpi-card:contains("비행중 드론") .kpi-value.primary');
            if ($kpiDroneValue.length) {
                $kpiDroneValue.text(drones ? drones.length : 0);
            }

            $container.empty();

            if (!drones || drones.length === 0) {
                $container.html('<div style="color: #a0aec0; font-size: 12px; padding: 10px 0;">등록된 드론이 없습니다.</div>');
                return;
            }

            var $ul = $('<ul>').css({
                'list-style': 'none',
                'padding': '0',
                'margin': '0'
            });

            drones.forEach(function(drone, index) {
                var droneId = drone.droneId || "드론 ID 없음";
                var streamUrl = drone.url || "";

                var $li = $('<li>')
                    .css({
                        'background': 'rgba(255, 255, 255, 0.05)',
                        'border': '1px solid rgba(255, 255, 255, 0.1)',
                        'border-radius': '8px',
                        'padding': '12px',
                        'margin-bottom': '8px',
                        'cursor': 'pointer',
                        'transition': 'background 0.2s'
                    })
                    .attr('data-drone-id', droneId)
                    .attr('data-stream-url', streamUrl)
                    .on('mouseover', function() { $(this).css('background', 'rgba(255, 255, 255, 0.1)'); })
                    .on('mouseout', function() { $(this).css('background', 'rgba(255, 255, 255, 0.05)'); })
                    .on('click', function() {
                        // 💡 [핵심 수정] 모달 오픈 및 AI 타이머 시작은 openDroneModal() 내부로 전담 (이중 실행 방지)
                        var modalParam = {
                            zoneName: drone.zoneName || "구역 미지정",
                            droneId: droneId,
                            streamUrl: streamUrl
                        };

                        if (typeof openDroneModal === 'function') {
                            openDroneModal(modalParam);
                        } else if (typeof openDroneModalByData === 'function') {
                            openDroneModalByData(drone);
                        }
                    });

                var html = 
                    '<div style="display: flex; justify-content: space-between; align-items: center;">' +
                        '<strong style="color: #fff; font-size: 14px;">' + droneId + '</strong>' +
                        '<span style="font-size: 11px; color: #38bdf8; background: rgba(56, 189, 248, 0.1); padding: 2px 6px; border-radius: 4px;">' +
                            (streamUrl ? '연결됨' : '대기중') +
                        '</span>' +
                    '</div>' +
                    '<div style="font-size: 12px; color: #a0aec0; margin-top: 6px;">' +
                        
                    '</div>';

                $li.html(html);
                $ul.append($li);
            });

            $container.append($ul);
        },
        error: function(xhr, status, error) {
            console.error("패널 드론 목록 로드 실패 - 상태코드:", xhr.status, "에러내용:", error);
            $container.html('<div style="color: #f87171; font-size: 12px; padding: 10px 0;">목록을 불러오지 못했습니다.</div>');
        }
    });
}

function drawBoundingBoxes(boxes) {
    // <img>와 <video> 중 현재 화면에 보이고 있는 요소 선택
    var mediaEl = document.getElementById('modalStreamVideo');
    if (!mediaEl || mediaEl.style.display === 'none') {
        mediaEl = document.getElementById('modalStreamImg');
    }
    
    var canvas = document.getElementById('aiOverlayCanvas');
    if (!mediaEl || !canvas) return;

    var ctx = canvas.getContext('2d');

    // 미디어의 원본 해상도 구하기
    var sourceWidth = mediaEl.videoWidth || mediaEl.naturalWidth || canvas.width;
    var sourceHeight = mediaEl.videoHeight || mediaEl.naturalHeight || canvas.height;
    
    // 화면에 실제로 표시되고 있는 크기 구하기
    var displayWidth = mediaEl.clientWidth;
    var displayHeight = mediaEl.clientHeight;

    // 캔버스 크기를 현재 화면 표시 크기와 동일하게 맞춰 해상도 깨짐 방지
    canvas.width = displayWidth;
    canvas.height = displayHeight;

    // 이전 프레임 잔상 지우기
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    if (!boxes || boxes.length === 0) return;

    // 원본 영상 좌표 -> 화면 표시 좌표 비율 계산
    var scaleX = displayWidth / sourceWidth;
    var scaleY = displayHeight / sourceHeight;

    boxes.forEach(function(item) {
        var box = item.box; // [x1, y1, x2, y2]
        var x1 = box[0] * scaleX;
        var y1 = box[1] * scaleY;
        var width = (box[2] - box[0]) * scaleX;
        var height = (box[3] - box[1]) * scaleY;

        // 라벨에 따른 박스 색상 구분 (사람: 형광 하늘색, 야생동물: 빨간색)
        var color = (item.label === 'person') ? '#00e5ff' : '#ff0055';

        // 1. 바운딩 박스 테두리 그리기
        ctx.strokeStyle = color;
        ctx.lineWidth = 2;
        ctx.strokeRect(x1, y1, width, height);

        // 2. 라벨 텍스트 상자 배경
        ctx.fillStyle = color;
        ctx.font = 'bold 12px Arial';
        var labelText = item.label + ' ' + Math.round(item.confidence * 100) + '%';
        var textWidth = ctx.measureText(labelText).width;

        var textY = (y1 - 18 > 0) ? y1 - 18 : y1;
        ctx.fillRect(x1, textY, textWidth + 8, 18);

        // 3. 라벨 텍스트 출력
        ctx.fillStyle = '#ffffff';
        ctx.fillText(labelText, x1 + 4, textY + 13);
    });
}

//영상(video) 또는 이미지(img/canvas) 요소를 캡처하여 Spring으로 보내는 함수
function captureAndSendAIFrame(mediaElement, droneId) {
    if (!mediaElement) return;

    var canvas = document.createElement('canvas');
    var ctx = canvas.getContext('2d');

    // mediaElement가 <video>인 경우
    if (mediaElement.tagName === 'VIDEO') {
        if (mediaElement.paused || mediaElement.ended || !mediaElement.videoWidth) return;
        canvas.width = mediaElement.videoWidth;
        canvas.height = mediaElement.videoHeight;
        ctx.drawImage(mediaElement, 0, 0, canvas.width, canvas.height);
    } 
    // mediaElement가 스트리밍 <img>인 경우 (MJPEG 등)
    else if (mediaElement.tagName === 'IMG') {
        if (!mediaElement.complete || !mediaElement.naturalWidth) return;
        canvas.width = mediaElement.naturalWidth;
        canvas.height = mediaElement.naturalHeight;
        ctx.drawImage(mediaElement, 0, 0, canvas.width, canvas.height);
    } else {
        return;
    }

    // Canvas를 이미지 파일(Blob)로 변환 후 자바 서버 전송
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
                console.log("[" + droneId + "] AI 감지 결과:", res);

                // 1. 문자열 형태 응답 안전 파싱
                if (typeof res === 'string') {
                    try { res = JSON.parse(res); } catch (e) {}
                }

                // 2. 응답 데이터 기반 모달 UI 실시간 갱신
                $('#modalPeopleCount').text((res.people_count || 0) + '명');
                $('#modalDensity').text((res.density_percent || 0) + '%');
                $('#modalDangerLevel').text(res.danger_level || '정상');
                
                // 3. 야생동물이 감지된 경우 처리
                if (res.detected_animals && res.detected_animals.length > 0) {
                    $('#modalAnimalWarning').text('⚠️ 감지된 동물: ' + res.detected_animals.join(', ')).show();
                } else {
                    $('#modalAnimalWarning').hide();
                }

                // 4. AI 바운딩 박스 Canvas 렌더링 호출
                if (res.boxes && typeof drawBoundingBoxes === 'function') {
                    drawBoundingBoxes(res.boxes);
                }

                // 🎯 5. [추가] 실시간 차트 데이터 주입
                if (typeof updateDensityChart === 'function') {
                    updateDensityChart(res.density_percent);
                }
                if (typeof updateAnimalChart === 'function') {
                    updateAnimalChart(res.boxes);
                }
            }
        });
    }, "image/jpeg", 0.8);
}


function closeDroneModal() {
    // 1. AI 감지 인터벌 타이머 중지
    if (window.aiDetectTimer) {
        clearInterval(window.aiDetectTimer);
        window.aiDetectTimer = null;
    }

    // 2. Canvas에 남아있는 바운딩 박스 지우기
    var canvas = document.getElementById('aiOverlayCanvas');
    if (canvas) {
        var ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    }

    // 3. 모달 닫기
    $('#droneVideoModal').hide();
}

window.contextPath = '${pageContext.request.contextPath}';

// 전체 요원 데이터를 보관할 변수
let currentAgentList = [];

// 요원 ID로 담당 구역 이름 찾기 함수 (SSE 및 DB 최신 전역 객체 참조)
function getAgentZoneName(userId) {
    var configData = window.adminMainConfigData;
    
    if (!configData) return '미배정';
    
    var zones = configData.zones || configData.savedZones || [];
    if (zones.length === 0) return '미배정';

    var matchedZone = zones.find(function(zone) {
        return zone.agentId === userId;
    });

    return matchedZone ? matchedZone.name : '미배정';
}

// 1. 사이드바 패널용 안전요원 목록 비동기 데이터 조회 (새로고침 대응)
function loadAdminAgentList() {
    const container = document.getElementById("agentListContainer");
    if (!container) return;

    container.innerHTML = '<div style="color: #a0aec0; font-size: 12px; padding: 5px 0;">목록 불러오는 중...</div>';

    // 무조건 최신 DB 구역 정보와 요원 목록을 함께 조회하여 전역 변수 동기화
    Promise.all([
        fetch(window.contextPath + "/admin/area/get").then(res => res.json()).catch(() => null),
        fetch(window.contextPath + "/admin/api/agents").then(res => {
            if (!res.ok) throw new Error("네트워크 응답 이상: " + res.status);
            return res.json();
        })
    ])
    .then(([configRes, agents]) => {
        // 새로고침 시 DB 최신 구역 데이터 반영
        if (configRes && configRes.success && configRes.configJson) {
            window.adminMainConfigData = typeof configRes.configJson === 'string'
                                       ? JSON.parse(configRes.configJson)
                                       : configRes.configJson;
        }

        // 요원 목록 필터링 (활성화된 agent 계정만 남김)
        currentAgentList = agents.filter(agent => {
            const isAgent = agent.userId && agent.userId.includes("agent");
            const isEnabled = agent.enabled === 1 || agent.enabled === true || agent.enabled === 'Y' || agent.enabled === '1';
            return isAgent && isEnabled;
        });

        // 화면 출력
        renderAdminAgentList();
    })
    .catch(err => {
        console.error("사이드바 요원 목록 로드 실패:", err);
        container.innerHTML = '<div style="color: #f87171; font-size: 12px;">목록을 불러오지 못했습니다.</div>';
    });
}

// 2. 화면에 요원 목록을 뿌려주는 함수 (SSE 수신 시에도 이 함수가 호출되어 즉시 반영됨)
function renderAdminAgentList() {
	// 💡 [추가] KPI 카드의 안전요원 수 동적 업데이트
    const kpiAgentValue = document.querySelector(".kpi-card .kpi-value.primary");
    if (kpiAgentValue) {
        kpiAgentValue.innerText = currentAgentList ? currentAgentList.length : 0;
    }
    const container = document.getElementById("agentListContainer");
    if (!container) return;

    if (currentAgentList.length === 0) {
        container.innerHTML = '<div style="color: #a0aec0; font-size: 12px;">등록된 안전요원이 없습니다.</div>';
        return;
    }

    let html = '<ul style="list-style: none; padding: 0; margin: 0;">';
    
    currentAgentList.forEach((agent, index) => {
        const name = agent.userName || "이름 없음";
        const userId = agent.userId || "";
        
        // 매번 실행 시점의 최신 window.adminMainConfigData를 읽음
        var assignedZoneName = getAgentZoneName(userId);

        html += '<li onclick="openAgentModal(' + index + ')" ' +
            'style="background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; padding: 12px; margin-bottom: 8px; cursor: pointer; transition: background 0.2s;" ' +
            'onmouseover="this.style.background=\'rgba(255, 255, 255, 0.1)\'" ' +
            'onmouseout="this.style.background=\'rgba(255, 255, 255, 0.05)\'">' +
            '<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">' +
            '<strong style="color: #fff; font-size: 14px;">' + name + '</strong>' +
            '<span style="font-size: 11px; color: #38bdf8; background: rgba(56, 189, 248, 0.1); padding: 2px 6px; border-radius: 4px;">' + userId + '</span>' +
            '</div>' +
            '<div style="font-size: 12px; color: #a0aec0;">' +
            '<span>📍 담당구역: ' + assignedZoneName + '</span>' +
            '</div>' +
            '</li>';
    });
    
    html += '</ul>';

    container.innerHTML = html;
}

// 3. 모달 열기 함수
function openAgentModal(index) {
    const agent = currentAgentList[index];
    if (!agent) return;

    document.getElementById("modalAgentName").textContent = agent.userName || "미등록";
    document.getElementById("modalAgentId").textContent = agent.userId || "-";
    document.getElementById("modalAgentPhone").textContent = agent.phone || "미등록";
    document.getElementById("modalAgentEmail").textContent = agent.email || "미등록";
 
    const statusElem = document.getElementById("modalAgentStatus");
    if (agent.enabled === 1 || agent.enabled === "1" || agent.enabled === true || agent.enabled === 'Y') {
        statusElem.textContent = "근무 가능 (활성)";
        statusElem.style.color = "#4ade80";
    } else {
        statusElem.textContent = "비활성";
        statusElem.style.color = "#f87171";
    }

    const modal = document.getElementById("agentDetailModal");
    modal.style.display = "flex";
}

// 4. 모달 닫기 함수
function closeAgentModal() {
    const modal = document.getElementById("agentDetailModal");
    modal.style.display = "none";
}

//5. SSE (Server-Sent Events) 실시간 수신 연결
function initAgentSseSubscriber() {
    // 💡 이미 연결이 진행 중이거나 열려 있다면 중복 생성 차단
    if (window.agentEventSource && window.agentEventSource.readyState !== EventSource.CLOSED) {
        return;
    }

    // 기존 연결이 완전히 닫힌 경우만 정리 후 재연결
    if (window.agentEventSource) {
        window.agentEventSource.close();
        window.agentEventSource = null;
    }

    const sseUrl = (window.contextPath || '') + '/api/sse/subscribe';
    const eventSource = new EventSource(sseUrl);
    window.agentEventSource = eventSource;

    eventSource.addEventListener('connect', function(e) {
        console.log('[SSE] 사이드바 요원 모니터링 연결 완료');
    });

    // 서버에서 AGENT_STATUS_CHANGE 이벤트 감지 시 실행
    eventSource.addEventListener('AGENT_STATUS_CHANGE', function(e) {
    console.log('[SSE 수신 성공] 데이터:', e.data);
    
    // loadAdminAgentList 함수가 정상적으로 존재하는지 확인
    if (typeof loadAdminAgentList === 'function') {
        loadAdminAgentList();
    } else {
        console.error('[오류] loadAdminAgentList 함수가 정의되지 않았거나 전역 스코프가 아닙니다!');
    }
});

    // 💡 [추가] 이벤트 이름 없이 서버에서 일반 send()로 보냈을 경우를 대비한 기본 message 수신
    eventSource.onmessage = function(e) {
        console.log('[SSE] 일반 수신 메시지:', e.data);
        loadAdminAgentList();
    };

    eventSource.onerror = function(err) {
        // SSE 소켓 문제 발생 시 기존 객체 정리
        console.warn('[SSE] 연결 disconnected 또는 재시도 중...');
    };
}

// 이벤트 리스너 등록 및 초기화
document.addEventListener("DOMContentLoaded", function () {
    const agentBtn = document.querySelector('.quick-nav-item[data-target="panel-admin-agents"]');

    // 1. 퀵바의 '요원' 버튼 클릭 시 데이터 로드
    if (agentBtn) {
        agentBtn.addEventListener("click", function () {
            loadAdminAgentList();
        });
    }

    // 2. 페이지 초기화/새로고침 시 요원 데이터 자동 로드
    loadAdminAgentList();

});
</script>


<script>
$(document).ready(function() {
	if (typeof renderAdminDroneList === 'function') {
        renderAdminDroneList();
    }

    // 패널 열릴 때 or 새로고침 클릭 시 이력 로드
    $('[data-target="panel-admin-reports"]').on('click', function() {
        loadChecklistHistory();
    });
    $('#btn-refresh-history').on('click', function(e) {
        e.stopPropagation();
        loadChecklistHistory();
    });
    $('[data-target="panel-admin-emergency"]').on('click', function() {
        renderEmergencyContactList();
    });

    // 1. 제출 이력 목록 로드 AJAX
    function loadChecklistHistory() {
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/api/checklist/history',
            type: 'GET',
            success: function(list) {
                renderHistoryCards(list);
            },
            error: function() {
                console.error('이력 목록을 불러오지 못했습니다.');
            }
        });
    }

    // 2. 이력 카드 사이드바 렌더링
    function renderHistoryCards(list) {
        const $container = $('#history-list-container').empty();

        if (!list || list.length === 0) {
            $container.append('<div style="color: #777; text-align: center; padding: 20px; font-size: 13px;">제출된 점검 내역이 없습니다.</div>');
            return;
        }

        list.forEach(function(item) {
            const isAgent = item.targetType === 'AGENT';
            const targetBadgeClass = isAgent ? 'background: #007bff; color: #fff;' : 'background: #6f42c1; color: #fff;';
            const targetName = isAgent ? '안전요원' : '관제사';

            // 상태 요약 배지 생성
            let statusBadge = '';
            if (item.dangerCount > 0) {
                statusBadge = '<span style="background: rgba(231, 76, 60, 0.2); color: #e74c3c; border: 1px solid #e74c3c; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold;">🚨 위험 ' + item.dangerCount + '</span>';
            } else if (item.cautionCount > 0) {
                statusBadge = '<span style="background: rgba(241, 196, 15, 0.2); color: #f1c40f; border: 1px solid #f1c40f; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold;">⚠️ 주의 ' + item.cautionCount + '</span>';
            } else {
                statusBadge = '<span style="background: rgba(46, 204, 113, 0.2); color: #2ecc71; border: 1px solid #2ecc71; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold;">✅ 양호</span>';
            }

            let html = '';
            html += '<div class="history-card" data-userid="' + item.userId + '" data-checkdate="' + item.checkDateStr + '" data-target="' + item.targetType + '" style="background: #2b2b40; border-radius: 8px; padding: 12px; cursor: pointer; border: 1px solid #363654; transition: all 0.2s;">';
            html += '   <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">';
            html += '       <div style="display: flex; align-items: center; gap: 6px;">';
            html += '           <span style="font-weight: bold; font-size: 14px; color: #fff;">' + item.userId + '</span>';
            html += '           <span style="' + targetBadgeClass + ' padding: 1px 5px; border-radius: 3px; font-size: 10px;">' + targetName + '</span>';
            html += '       </div>';
            html += '       <div>' + statusBadge + '</div>';
            html += '   </div>';
            html += '   <div style="font-size: 11px; color: #888; display: flex; justify-content: space-between;">';
            html += '       <span><i class="fa-regular fa-clock"></i> ' + item.checkDateStr + '</span>';
            html += '       <span>총 ' + item.totalCount + '문항</span>';
            html += '   </div>';
            html += '</div>';

            const $card = $(html);
            
            // 카드 호버 효과 및 클릭 시 모달 오픈
            $card.hover(
                function() { $(this).css({'border-color': '#007bff', 'background': '#32324d'}); },
                function() { $(this).css({'border-color': '#363654', 'background': '#2b2b40'}); }
            );

            $card.on('click', function() {
                openDetailModal(item.userId, item.checkDateStr, item.targetType);
            });

            $container.append($card);
        });
    }

 // 3. 모달 열기 및 상세 결과 조회 AJAX
    function openDetailModal(userId, checkDateStr, targetType) {
        $('#modal-user-title').text(userId + ' 님의 점검 결과');
        $('#modal-check-date').text(checkDateStr);
        
        const isAgent = targetType === 'AGENT';
        $('#modal-target-badge')
            .text(isAgent ? '안전요원' : '관제사')
            .css('background', isAgent ? '#007bff' : '#6f42c1');

        // 💡 [수정] AJAX 요청과 상관없이 모달 창부터 화면에 즉시 표시
        $('#checklistDetailModal').css('display', 'flex');
        $('#modal-detail-body').html('<div style="text-align:center; color:#aaa; padding:20px;">불러오는 중...</div>');

        $.ajax({
            url: '${pageContext.request.contextPath}/admin/api/checklist/history/detail',
            type: 'GET',
            data: { userId: userId, checkDateStr: checkDateStr },
            dataType: 'json',
            success: function(details) {
                console.log("받아온 상세 데이터:", details);
                renderModalDetail(details);
            },
            error: function(xhr, status, error) {
                console.error("상세조회 에러:", error);
                $('#modal-detail-body').html('<div style="text-align:center; color:#f87171; padding:20px;">상세 정보를 불러오지 못했습니다.</div>');
            }
        });
    }

    // 4. 모달 본문 상세 내용 렌더링
    function renderModalDetail(details) {
        const $body = $('#modal-detail-body').empty();
        const $summary = $('#modal-status-summary').empty();

        if (!details || details.length === 0) {
            $body.append('<div style="text-align:center; color:#888;">상세 내역이 없습니다.</div>');
            return;
        }

        let normal = 0, caution = 0, danger = 0;
        let categoryMap = {};

        // 카테고리별 그룹핑
        details.forEach(function(d) {
            if (d.checkStatus === '정상') normal++;
            else if (d.checkStatus === '주의') caution++;
            else if (d.checkStatus === '위험') danger++;

            // 💡 [수정] category 값이 없거나 null일 경우 대비 예외처리 추가
            var catName = d.category || '기타 점검 항목';

            if (!categoryMap[catName]) {
                categoryMap[catName] = [];
            }
            categoryMap[catName].push(d);
        });

        // 헤더 요약 렌더링
        $summary.append('<span style="color:#2ecc71;">정상 ' + normal + '</span>');
        $summary.append('<span style="color:#f1c40f;">주의 ' + caution + '</span>');
        $summary.append('<span style="color:#e74c3c;">위험 ' + danger + '</span>');

        // 카테고리별 문항 및 답변 렌더링
        Object.keys(categoryMap).forEach(function(cat) {
            let catHtml = '<div style="background: #151521; border-radius: 8px; padding: 12px 16px; border: 1px solid #2b2b40;">';
            catHtml += '  <h4 style="margin: 0 0 10px 0; color: #007bff; font-size: 14px;"><i class="fa-solid fa-layer-group"></i> ' + cat + '</h4>';
            catHtml += '  <div style="display: flex; flex-direction: column; gap: 8px;">';

            categoryMap[cat].forEach(function(item) {
                let statusStyle = '';
                if (item.checkStatus === '정상') statusStyle = 'background: rgba(46,204,113,0.15); color: #2ecc71; border: 1px solid #2ecc71;';
                else if (item.checkStatus === '주의') statusStyle = 'background: rgba(241,196,15,0.15); color: #f1c40f; border: 1px solid #f1c40f;';
                else if (item.checkStatus === '위험') statusStyle = 'background: rgba(231,76,60,0.15); color: #e74c3c; border: 1px solid #e74c3c;';
                else statusStyle = 'background: #323248; color: #aaa;';

                // 💡 [수정] itemTitle, question 누락 예외처리
                var title = item.itemTitle || item.title || '점검 항목';
                var questionText = item.question || '';
                var statusText = item.checkStatus || '미응답';

                catHtml += '    <div style="padding: 10px; background: #1e1e2d; border-radius: 6px; border: 1px solid #2a2a3d;">';
                catHtml += '      <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 10px;">';
                catHtml += '        <div style="font-size: 13px; font-weight: 600; color: #ddd;">' + title + '</div>';
                catHtml += '        <span style="padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; white-space: nowrap; ' + statusStyle + '">' + statusText + '</span>';
                catHtml += '      </div>';
                if (questionText) {
                    catHtml += '      <div style="font-size: 12px; color: #888; margin-top: 4px;">' + questionText + '</div>';
                }

                if (item.remark && item.remark.trim() !== '') {
                    catHtml += '  <div style="margin-top: 6px; padding: 6px 10px; background: #252538; border-left: 3px solid #f1c40f; font-size: 12px; color: #ffeb3b;">';
                    catHtml += '    <strong><i class="fa-regular fa-comment-dots"></i> 비고:</strong> ' + item.remark;
                    catHtml += '  </div>';
                }
                catHtml += '    </div>';
            });

            catHtml += '  </div></div>';
            $body.append(catHtml);
        });
    }

    // 5. 모달 닫기 이벤트
    $('.btn-close-modal, #checklistDetailModal').on('click', function(e) {
        if (e.target === this) {
            $('#checklistDetailModal').hide();
        }
    });
});


//비상연락망 전체 데이터 보관 변수 및 현재 선택된 카테고리
var rawEmergencyList = [];
var currentEmergencyCategory = 'ALL';

// 1. 비상연락망 목록 불러오기 (AJAX)
function renderEmergencyContactList() {
    var ctx = window.contextPath || '';
    var $container = $('#emergencyContactListContainer');

    if (!$container.length) return;

    $.ajax({
        url: ctx + '/api/emergency/list',
        type: 'GET',
        dataType: 'json',
        success: function(list) {
            rawEmergencyList = list || [];
            // 데이터 로드 완료 후 현재 선택된 탭 기준으로 목록 렌더링
            displayFilteredEmergencyList();
        },
        error: function(xhr, status, error) {
            console.error("비상연락망 로드 실패:", error);
            $container.html('<div style="color: #f87171; font-size: 12px; padding: 10px 0; text-align: center;">목록을 불러오지 못했습니다.</div>');
        }
    });
}

// 2. 카테고리 탭 클릭 이벤트 처리
function filterEmergencyCategory(category, btnElem) {
    currentEmergencyCategory = category;

    // 탭 스타일 전환
    $('.emg-tab-btn').css({
        'background': 'transparent',
        'color': '#a0aec0',
        'font-weight': 'normal'
    }).removeClass('active');

    $(btnElem).css({
        'background': '#38bdf8',
        'color': '#fff',
        'font-weight': 'bold'
    }).addClass('active');

    // 필터링된 목록 출력
    displayFilteredEmergencyList();
}

// 3. 실제 화면 카드 렌더링 함수
function displayFilteredEmergencyList() {
    var $container = $('#emergencyContactListContainer');
    $container.empty();

    // 선택된 카테고리 필터링
    var filteredList = rawEmergencyList.filter(function(item) {
        if (currentEmergencyCategory === 'ALL') return true;
        return item.category === currentEmergencyCategory;
    });

    if (!filteredList || filteredList.length === 0) {
        $container.html('<div style="color: #a0aec0; font-size: 12px; padding: 15px 0; text-align: center;">해당 카테고리의 연락처가 없습니다.</div>');
        return;
    }

    var $ul = $('<ul>').css({
        'list-style': 'none',
        'padding': '0',
        'margin': '0'
    });

    var categoryMap = {
        'HOST': '행사 주최측',
        'AGENCY': '유관기관',
        'MEDICAL': '의료 인프라'
    };

    filteredList.forEach(function(item) {
        var categoryName = categoryMap[item.category] || item.category;

        var $li = $('<li>').css({
            'background': 'rgba(255, 255, 255, 0.05)',
            'border': '1px solid rgba(255, 255, 255, 0.1)',
            'border-radius': '8px',
            'padding': '10px 12px',
            'margin-bottom': '8px',
            'position': 'relative'
        });

        var html = 
            '<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">' +
                '<span style="font-size: 11px; color: #38bdf8; background: rgba(56, 189, 248, 0.1); padding: 2px 6px; border-radius: 4px;">' +
                    categoryName +
                '</span>' +
                '<div>' +
                    '<button type="button" onclick="openEmergencyContactModal(' + item.contactId + ', \'' + item.category + '\', \'' + item.title + '\', \'' + item.phone + '\', ' + item.sortOrder + ')" ' +
                            'style="background: none; border: none; color: #a0aec0; font-size: 11px; cursor: pointer; margin-right: 4px;">수정</button>' +
                    '<button type="button" onclick="deleteEmergencyContact(' + item.contactId + ')" ' +
                            'style="background: none; border: none; color: #f87171; font-size: 11px; cursor: pointer;">삭제</button>' +
                '</div>' +
            '</div>' +
            '<div style="color: #fff; font-size: 13px; font-weight: bold; margin-bottom: 2px;">' + item.title + '</div>' +
            '<div style="color: #a0aec0; font-size: 12px;">' + item.phone + '</div>';

        $li.html(html);
        $ul.append($li);
    });

    $container.append($ul);
}

//모달 열기 (등록/수정 공용)
function openEmergencyContactModal(id, category, title, phone, sortOrder) {
    if (id) {
        // 수정 모드
        $('#emergencyModalTitle').text('비상연락처 수정');
        $('#emgContactId').val(id);
        $('#emgCategory').val(category);
        $('#emgTitle').val(title);
        $('#emgPhone').val(phone);
        $('#emgSortOrder').val(sortOrder);
    } else {
        // 신규 등록 모드
        $('#emergencyModalTitle').text('비상연락처 등록');
        $('#emgContactId').val('');
        $('#emgCategory').val('HOST');
        $('#emgTitle').val('');
        $('#emgPhone').val('');
        $('#emgSortOrder').val(1);
    }
    $('#emergencyContactModal').css('display', 'flex');
}

// 모달 닫기
function closeEmergencyContactModal() {
    $('#emergencyContactModal').hide();
}

// 저장 (등록/수정 처리)
function saveEmergencyContact() {
    var ctx = window.contextPath || '';
    var id = $('#emgContactId').val();
    var category = $('#emgCategory').val();
    var title = $.trim($('#emgTitle').val());
    var phone = $.trim($('#emgPhone').val());
    var sortOrder = $('#emgSortOrder').val() || 0;

    if (!title) {
        alert('구분 / 기관명을 입력해 주세요.');
        return;
    }
    if (!phone) {
        alert('연락처 / 채널을 입력해 주세요.');
        return;
    }

    var data = {
        contactId: id ? parseInt(id) : null,
        category: category,
        title: title,
        phone: phone,
        sortOrder: parseInt(sortOrder)
    };

    var url = id ? '/api/emergency/modify' : '/api/emergency/add';

    $.ajax({
        url: ctx + url,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function(res) {
            if (res) {
                alert(id ? '수정되었습니다.' : '등록되었습니다.');
                closeEmergencyContactModal();
                renderEmergencyContactList(); // 목록 다시 뿌리기
            } else {
                alert('처리에 실패했습니다.');
            }
        },
        error: function() {
            alert('서버통신 오류가 발생했습니다.');
        }
    });
}

// 삭제 처리
function deleteEmergencyContact(id) {
    if (!confirm('이 연락처를 삭제하시겠습니까?')) return;

    var ctx = window.contextPath || '';

    $.ajax({
        url: ctx + '/api/emergency/remove',
        type: 'POST',
        data: { contactId: id },
        success: function(res) {
            if (res) {
                renderEmergencyContactList(); // 목록 다시 뿌리기
            } else {
                alert('삭제 실패했습니다.');
            }
        },
        error: function() {
            alert('서버통신 오류가 발생했습니다.');
        }
    });
}


</script>

