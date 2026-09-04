<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Pretendard 고급 웹폰트 CDN 로드 -->
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<!-- 1. 우측 60px 고정 퀵바 (아이콘 전용) -->
<aside class="quick-sidebar">
    <div class="quick-top">
        <button id="toggle-drawer-btn" class="quick-btn toggle-btn" title="사이드바 열기/닫기">
            ❮❮
        </button>
    </div>

    <nav class="quick-nav">
        <button class="quick-nav-item" data-target="panel-festival">
            <span class="nav-icon"><i class="fa-solid fa-mask-ventilator"></i></span>
            <span class="nav-label">드론</span>
        </button>
        <button class="quick-nav-item" data-target="panel-agent" id="btn-nav-agent" style="position: relative;">
		    <span class="nav-icon"><i class="fa-solid fa-triangle-exclamation"></i></span>
		    <span class="nav-label">상황보고</span>
		    <span id="quick-agent-badge" class="quick-badge" style="display: none;">0</span>
		</button>
        <button class="quick-nav-item" data-target="panel-agent">
            <span class="nav-icon">(?)</span>
            <span class="nav-label">(?)</span>
        </button>
        <button class="quick-nav-item" data-target="panel-system">
            <span class="nav-icon">(?))</span>
            <span class="nav-label">(?)</span>
        </button>
    </nav>
</aside>

<!-- 2. 왼쪽으로 열리는 260px 서브 드로어 패널 -->
<div id="sub-drawer" class="sub-drawer collapsed">
    <!-- 드론 관제 패널 -->
<!-- 드론 관제 패널 -->
<div id="panel-festival" class="drawer-content active">
<!-- 헤더 전체 높이를 40px로 고정하고 flex 수직 중앙 정렬 -->
<div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
    <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">드론 목록</span>
    
    <!-- 버튼 우측 컨테이너 (높이 및 flex 유지) -->
    <div class="header-btn-group" style="display: flex; align-items: center; height: 100%;">
        <!-- 일반 모드 시 노출 -->
        <div id="mode-default-btns" style="display: flex; align-items: center;">
            <button id="btn-edit-mode" class="mini-btn">
            <i class="fa-solid fa-gear"></i>
            </button>
        </div>
        
        <!-- 편집 모드 전환 시 노출 -->
        <div id="mode-edit-btns" style="display: none; gap: 4px; align-items: center;">
            <button id="btn-open-add-modal" class="mini-btn primary">+ 신규</button>
            <button id="btn-cancel-edit" class="mini-btn danger">취소</button>
        </div>
    </div>
</div>

    <!-- 2. 드론 목록 영역 (JS가 여기에 dynamic하게 버튼을 뿌려줍니다) -->
    <div class="drawer-body">
        

        <div id="drone-list-container" style="display: flex; flex-direction: column; gap: 10px;">
            <!-- JavaScript로 드론 목록이 렌더링됩니다 -->
        </div>
    </div>
</div>


    <div id="panel-agent" class="drawer-content">
		    <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
		        <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">실시간 상황 보고</span>
		        <span id="situ-count-badge" style="color: #ff5252 !important; font-size: 13px !important; font-weight: 700 !important; -webkit-text-fill-color: #ff5252 !important;">(0건)</span>
		    </div>
		    
		    <div class="drawer-body">
		        <!-- 실시간 카드 리스트 컨테이너 -->
		        <div id="situation-list-container" style="display: flex; flex-direction: column; gap: 10px;">
		            <!-- JS가 SSE 이벤트를 받아 여기에 카드를 동적으로 추가합니다 -->
		        </div>
		    </div>
		</div>

    <div id="panel-aaa" class="drawer-content">
        <div class="drawer-header">(?)</div>
        <div class="drawer-body">
            <p>( 임시 )</p>
        </div>
    </div>


    <div id="panel-system" class="drawer-content">
        <div class="drawer-header">(?)</div>
        <div class="drawer-body">
            <p> ( 임시 )</p>
        </div>
    </div>
</div>

<!-- sidebar.jsp 최하단 위치 -->
<div id="drone-modal" class="modal-overlay">
    <div class="modal-content">
        <h3 id="modal-title" style="color: #ffffff; margin-bottom: 16px; font-size: 16px;">드론 추가</h3>
        
        <!-- 수정 대상 ID 저장을 위한 숨김 필드 -->
        <input type="hidden" id="modal-drone-id" value="" />
        
        <!-- 입력 창 -->
        <input type="text" id="modal-input-name" class="modal-input" placeholder="드론 이름을 입력하세요" />
        
        <div style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 20px;">
            <button id="btn-modal-save" class="mini-btn primary">저장</button>
            <button id="btn-modal-cancel" class="mini-btn">취소</button>
        </div>
    </div>
</div>





<!-- situation-modal: sidebar.jsp 최하단에 위치 -->
<div id="situation-modal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.7); z-index: 9999; justify-content: center; align-items: center;">
    <div class="modal-content" style="background: #1e222d; border: 1px solid #333; border-radius: 8px; padding: 20px; max-width: 420px; width: 90%; color: #fff; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
        
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #333; padding-bottom: 10px; margin-bottom: 15px;">
            <h3 id="situ-modal-title" style="color: #ffffff; font-size: 16px; margin: 0; font-weight: bold;">
                🚨 <span id="situ-modal-dngr-type">위험 상황</span>
            </h3>
            <button id="btn-situ-modal-close" type="button" style="background: none; border: none; color: #aaa; font-size: 22px; cursor: pointer; line-height: 1;">&times;</button>
        </div>
        
        <div style="display: flex; flex-direction: column; gap: 10px; font-size: 13px;">
            <div style="display: flex; justify-content: space-between;">
                <span><strong>발생 구역:</strong> <span id="situ-modal-zone" style="color: #e74c3c; font-weight: bold;">-</span></span>
                <span><strong>보고자:</strong> <span id="situ-modal-user" style="color: #3498db;">-</span></span>
            </div>
            <div><strong>보고 시각:</strong> <span id="situ-modal-time" style="color: #aaa;">-</span></div>
            
            <div style="margin-top: 5px;">
                <strong>상황 내용:</strong>
                <div id="situ-modal-content" style="background: #14161d; padding: 10px; border-radius: 4px; margin-top: 5px; min-height: 50px; white-space: pre-wrap; color: #ddd; border: 1px solid #2c303e;">-</div>
            </div>
            
            <!-- 첨부 사진 영역 -->
            <div id="situ-modal-img-wrapper" style="margin-top: 5px; display: none;">
                <strong>첨부 사진:</strong>
                <div style="margin-top: 5px; text-align: center; background: #000; border-radius: 4px; overflow: hidden;">
                    <img id="situ-modal-img" src="" alt="상황 사진" style="max-width: 100%; max-height: 250px; object-fit: contain;">
                </div>
            </div>
        </div>
        
        <div style="margin-top: 20px; text-align: right;">
            <button id="btn-situ-modal-confirm" type="button" class="mini-btn primary" style="padding: 6px 16px;">확인</button>
        </div>
    </div>
</div>



<style>
/* 뱃지 위치 및 디자인 */
.quick-badge {
    position: absolute;
    top: 2px;
    right: 4px;
    background-color: #e74c3c;
    color: #ffffff;
    font-size: 10px;
    font-weight: bold;
    padding: 2px 5px;
    border-radius: 8px;
    line-height: 1;
    z-index: 10;
}

/* 탭 버튼 붉은색 반짝임 효과 */
@keyframes blinkGlow {
    0% { background-color: transparent; }
    50% { background-color: rgba(231, 76, 60, 0.6); }
    100% { background-color: transparent; }
}

.blink-active {
    animation: blinkGlow 1s infinite !important;
    border-left: 3px solid #e74c3c !important;
}
</style>







<!-- 외부 스크립트에 contextPath 전달 및 JS 파일 로드 -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/resources/js/drone-sidebar.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/situation-sidebar.js"></script>


