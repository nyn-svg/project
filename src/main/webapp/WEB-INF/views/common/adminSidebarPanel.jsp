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
        <!-- 3)이력/보고서 -->
        <button class="quick-nav-item" data-target="panel-admin-reports">
            <span class="nav-icon"><i class="fa-solid fa-file-invoice"></i></span>
            <span class="nav-label">이력</span>
        </button>
        <!-- 4) 시스템 설정 -->
        <button class="quick-nav-item" data-target="panel-admin-system">
            <span class="nav-icon"><i class="fa-solid fa-sliders"></i></span>
            <span class="nav-label">설정</span>
        </button>
    </nav>
</aside>

<!-- 2. 왼쪽으로 열리는 260px 서브 드로어 패널 -->
<div id="sub-drawer" class="sub-drawer">
    
    <!-- 1) 대시보드 요약 패널 -->
    <div id="panel-admin-dashboard" class="drawer-content active">
        <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
            <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">드론</span>
        </div>
        <div class="drawer-body">
            <div style="padding: 10px 0; color: #a0aec0; font-size: 13px;">
                <p>실시간 모니터링 요약 정보, 클릭시 드론 영상 확인 가능</p>
            </div>
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

<!-- ========================================== -->
<!-- 4) 체크리스트 상세 보기 공통 모달 (Modal) -->
<!-- ========================================== -->
<div id="checklistDetailModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0, 0, 0, 0.7); z-index: 9999; justify-content: center; align-items: center;">
    <div class="modal-content" style="background: #1e1e2d; color: #fff; width: 680px; max-width: 90%; max-height: 85vh; border-radius: 12px; border: 1px solid #323248; display: flex; flex-direction: column; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
        
        <!-- 모달 헤더 -->
        <div class="modal-header" style="padding: 16px 20px; border-bottom: 1px solid #323248; display: flex; justify-content: space-between; align-items: center;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <h3 style="margin: 0; font-size: 18px; font-weight: 700;" id="modal-user-title">점검 상세 내역</h3>
                <span id="modal-target-badge" class="badge" style="padding: 4px 8px; border-radius: 4px; font-size: 12px;">요원</span>
            </div>
            <button type="button" class="btn-close-modal" style="background: transparent; border: none; color: #aaa; font-size: 20px; cursor: pointer;">&times;</button>
        </div>

        <!-- 모달 상단 정보 요약 바 -->
        <div class="modal-sub-header" style="background: #151521; padding: 12px 20px; display: flex; justify-content: space-between; font-size: 13px; color: #aaa; border-bottom: 1px solid #2b2b40;">
            <div><i class="fa-regular fa-clock"></i> 제출시간: <span id="modal-check-date" style="color: #fff;">-</span></div>
            <div id="modal-status-summary" style="display: flex; gap: 8px;">
                <!-- 정상 N, 주의 N, 위험 N 건수 표시 -->
            </div>
        </div>

        <!-- 모달 본문 (답변 리스트 스크롤 구역) -->
        <div class="modal-body" id="modal-detail-body" style="padding: 20px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 16px;">
            <!-- 카테고리 및 문항별 답변 상세 내용이 동적으로 생성됩니다 -->
        </div>

        <!-- 모달 푸터 -->
        <div class="modal-footer" style="padding: 12px 20px; border-top: 1px solid #323248; text-align: right;">
            <button type="button" class="btn-close-modal" style="background: #323248; color: #fff; border: none; padding: 8px 18px; border-radius: 6px; cursor: pointer;">닫기</button>
        </div>
    </div>
</div>



    <!-- 4) 시스템 설정 패널 -->
    <div id="panel-admin-system" class="drawer-content">
        <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
            <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">시스템 설정</span>
        </div>
        <div class="drawer-body">
            <div style="padding: 10px 0; color: #a0aec0; font-size: 13px;">
                <p></p>
            </div>
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











<!-- ContextPath 전달 -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/resources/js/drone-sidebar.js"></script>





<!-- ContextPath 전달 및 안전요원 목록 로드 스크립트 -->
<script>
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

// 5. SSE (Server-Sent Events) 실시간 수신 연결
function initAgentSseSubscriber() {
    if (window.agentEventSource) return;

    const sseUrl = window.contextPath + '/api/sse/subscribe';
    const eventSource = new EventSource(sseUrl);
    window.agentEventSource = eventSource;

    eventSource.addEventListener('connect', function(e) {
        console.log('[SSE] 사이드바 요원 모니터링 연결 완료');
    });

    // 서버에서 AGENT_STATUS_CHANGE 이벤트 감지 시 실행
    eventSource.addEventListener('AGENT_STATUS_CHANGE', function(e) {
        try {
            console.log('[SSE] 요원 계정 상태 변경 감지, 목록 동기화 진행');
            // 계정 활성/비활성화 시 최신 DB 기준으로 사이드바 목록 즉시 갱신
            loadAdminAgentList();
        } catch (err) {
            console.error('[SSE] 처리 중 오류:', err);
            loadAdminAgentList();
        }
    });

    eventSource.onerror = function(err) {
        console.warn('[SSE] 연결 재시도 중...');
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

    // 3. 실시간 SSE 구독 개시
    initAgentSseSubscriber();
});
</script>


<script>
$(document).ready(function() {

    // 패널 열릴 때 or 새로고침 클릭 시 이력 로드
    $('[data-target="panel-admin-reports"]').on('click', function() {
        loadChecklistHistory();
    });
    $('#btn-refresh-history').on('click', function(e) {
        e.stopPropagation();
        loadChecklistHistory();
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

        $.ajax({
            url: '${pageContext.request.contextPath}/admin/api/checklist/history/detail',
            type: 'GET',
            data: { userId: userId, checkDateStr: checkDateStr },
            success: function(details) {
                renderModalDetail(details);
                $('#checklistDetailModal').css('display', 'flex');
            },
            error: function() {
                alert('상세 정보를 불러오지 못했습니다.');
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

            if (!categoryMap[d.category]) {
                categoryMap[d.category] = [];
            }
            categoryMap[d.category].push(d);
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

                catHtml += '    <div style="padding: 10px; background: #1e1e2d; border-radius: 6px; border: 1px solid #2a2a3d;">';
                catHtml += '      <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 10px;">';
                catHtml += '        <div style="font-size: 13px; font-weight: 600; color: #ddd;">' + item.itemTitle + '</div>';
                catHtml += '        <span style="padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; white-space: nowrap; ' + statusStyle + '">' + item.checkStatus + '</span>';
                catHtml += '      </div>';
                catHtml += '      <div style="font-size: 12px; color: #888; margin-top: 4px;">' + item.question + '</div>';

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
</script>

