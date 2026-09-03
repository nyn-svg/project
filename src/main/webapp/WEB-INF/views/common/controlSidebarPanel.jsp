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
        <button class="quick-nav-item" data-target="panel-map">
            <span class="nav-icon">(?)</span>
            <span class="nav-label">(?)</span>
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


    <!-- 통합 관제 지도 패널 -->
    <div id="panel-map" class="drawer-content">
        <div class="drawer-header">(?)</div>
        <div class="drawer-body">
            <p> ( 임시 )</p>
        </div>
    </div>

    <!-- 현장 요원 지시 패널 -->
    <div id="panel-agent" class="drawer-content">
        <div class="drawer-header">(?)</div>
        <div class="drawer-body">
            <p>( 임시 )</p>
        </div>
    </div>

    <!-- 시스템 관리 패널 -->
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


<!-- 외부 스크립트에 contextPath 전달 및 JS 파일 로드 -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/resources/js/drone-sidebar.js"></script>


