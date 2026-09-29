<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 관리자 전용 상단 헤더 -->
<header class="app-header admin-header">
    <a href="${pageContext.request.contextPath}/admin/main" class="header-logo header-link">
        <div class="logo-icon"><i class="fa-solid fa-display"></i></div>
		<span>2TEAM <span class="admin-badge">ADMIN</span></span>
    </a>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/admin/main" class="nav-link header-link">홈</a>
        <a href="${pageContext.request.contextPath}/admin/areaManagement" class="nav-link header-link">행사장 관리</a>
        <a href="${pageContext.request.contextPath}/admin/userManagement" class="nav-link header-link">사용자 관리</a>
    	<a href="${pageContext.request.contextPath}/admin/checklist" class="nav-link header-link">점검 관리</a>
    	<a href="${pageContext.request.contextPath}/admin/fieldAction" class="nav-link header-link">위험 감지 관리</a>
    </nav>
</header>

<script>
// 🎯 [필수] 전역 contextPath 설정
window.contextPath = '${pageContext.request.contextPath}';

/**
 * 백그라운드 SSE 수신 및 sessionStorage 저장 스크립트 (모든 페이지 공통 적용)
 */
(function initSseReceiver() {
    const MAX_LOG_COUNT = 100;
    const basePath = window.contextPath || '';
    const STORAGE_KEY = 'admin_terminal_logs';
    let activeEventSource = null;

    // 🎯 전역 로그 추가 및 sessionStorage 적재
    window.addTerminalLog = function(type, message) {
        const now = new Date();
        const hh = String(now.getHours()).padStart(2, '0');
        const mm = String(now.getMinutes()).padStart(2, '0');
        const ss = String(now.getSeconds()).padStart(2, '0');
        const timeStr = '[' + hh + ':' + mm + ':' + ss + ']';

        const logObj = { type: type, message: message, timeStr: timeStr };

        // 1. sessionStorage 저장
        try {
            let logs = JSON.parse(sessionStorage.getItem(STORAGE_KEY) || '[]');
            logs.push(logObj);
            if (logs.length > MAX_LOG_COUNT) logs.shift();
            sessionStorage.setItem(STORAGE_KEY, JSON.stringify(logs));
        } catch (e) {
            console.error('sessionStorage 저장 오류:', e);
        }

        // 2. 현재 메인 홈 페이지에 머무르고 있다면 UI 실시간 업데이트 함수 호출
        if (typeof window.onNewTerminalLog === 'function') {
            window.onNewTerminalLog(logObj);
        }
    };

    // 🎯 SSE 백그라운드 스트림 연결
    function connectSseStream() {
        if (activeEventSource) {
            activeEventSource.close();
            activeEventSource = null;
        }

        const sseUrl = basePath + '/api/sse/subscribe';
        const eventSource = new EventSource(sseUrl);
        activeEventSource = eventSource;

        eventSource.addEventListener('terminal-log', function(e) {
            try {
                const data = JSON.parse(e.data);
                window.addTerminalLog(data.type || 'INFO', data.message || '');
            } catch (err) {}
        });

        eventSource.addEventListener('situation-report', function(e) {
            try {
                const data = JSON.parse(e.data);
                const msg = '[긴급보고] ' + (data.situContent || '현장 긴급 상황이 접수되었습니다.');
                window.addTerminalLog('DANGER', msg);
            } catch (err) {}
        });

        eventSource.addEventListener('situation-alert', function(e) {
            try {
                const data = JSON.parse(e.data);
                const dngrType = data.dngrType || '위험';
                const msg = '[' + dngrType + '] ' + (data.situContent || '새로운 위험 요소가 감지되었습니다.');
                window.addTerminalLog('WARN', msg);
            } catch (err) {}
        });

        eventSource.addEventListener('situation-update', function(e) {
            try {
                const data = JSON.parse(e.data);
                const msg = '상황 정보 업데이트 (요청No.' + (data.situNo || '-') + ')';
                window.addTerminalLog('INFO', msg);
            } catch (err) {}
        });

        eventSource.onerror = function() {
            eventSource.close();
            activeEventSource = null;
            setTimeout(connectSseStream, 5000);
        };
    }

    window.closeTerminalSse = function() {
        if (activeEventSource) {
            activeEventSource.close();
            activeEventSource = null;
        }
    };

    window.addEventListener('beforeunload', window.closeTerminalSse);
    window.addEventListener('pagehide', window.closeTerminalSse);

    // 헤더가 로드되는 모든 페이지에서 SSE 백그라운드 수신 시작
    connectSseStream();
})();
</script>

<!-- Chart.js 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>