<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 1. 상단 알림창 디자인 (CSS) -->
<style>
.toast-popup-top {
    position: fixed;
    top: 16px;
    left: 5%;
    width: 90%;
    background-color: #1e222b;
    color: #ffffff;
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.35);
    padding: 16px;
    z-index: 99999;
    border-left: 5px solid #ff4d4d;
    animation: slideDown 0.3s ease-out;
}

@keyframes slideDown {
    from { transform: translateY(-100%); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}

.toast-header { font-size: 15px; font-weight: bold; margin-bottom: 8px; color: #ff4d4d; }
.toast-body p { margin: 4px 0; font-size: 14px; color: #e2e8f0; }
.toast-footer { display: flex; justify-content: space-between; margin-top: 14px; gap: 8px; }
.btn-close { background-color: #4a505e; color: #fff; border: none; border-radius: 6px; padding: 10px 20px; flex: 1; font-size: 13px; cursor: pointer; }
.btn-confirm { background-color: #ff4d4d; color: #fff; border: none; border-radius: 6px; padding: 10px 20px; flex: 1.5; font-size: 13px; font-weight: bold; cursor: pointer; }
</style>

<!-- 2. 알림창 UI 뼈대 (HTML) -->
<div id="realtime-toast" class="toast-popup-top" style="display: none;">
    <div class="toast-header">
        <span class="toast-title">🚨 실시간 위험 감지</span>
    </div>
    <div class="toast-body">
        <p><strong>유형:</strong> <span id="toast-type"></span> (<span id="toast-level"></span>)</p>
        <p><strong>내용:</strong> <span id="toast-content"></span></p>
    </div>
    <div class="toast-footer">
        <button id="btn-toast-close" class="btn-close">닫기</button>
        <button id="btn-toast-confirm" class="btn-confirm">확인 (조치하기)</button>
    </div>
</div>

<!-- 3. 실시간 SSE 통신 및 버튼 액션 (JavaScript) -->
<script>
document.addEventListener("DOMContentLoaded", function () {
    // 서버와 실시간 SSE 연결 개설
    const eventSource = new EventSource("${pageContext.request.contextPath}/agent/sse/connect");

    eventSource.addEventListener("connect", function (e) {
        console.log("상단 실시간 알림 서버 동기화 완료:", e.data);
    });

    // 자동감지, 수동감지 이벤트 발생 시 수신 리액션 (프론트엔드 필터링)
    eventSource.addEventListener("situation-alert", function (event) {
        const situation = JSON.parse(event.data);
        console.log("위험 감지 알림 수신:", situation);
        
        showTopToastNotification(situation);
    });
});

function showTopToastNotification(situation) {
    const toastWindow = document.getElementById("realtime-toast");
    if (!toastWindow) return;

    // 데이터 바인딩
    document.getElementById("toast-type").innerText = situation.dngrType;
    document.getElementById("toast-level").innerText = situation.dngrLevel;
    document.getElementById("toast-content").innerText = situation.situContent || "내용 없음";
    
    toastWindow.setAttribute("data-situ-no", situation.situNo);
    toastWindow.style.display = "block"; // 팝업 노출

    // [확인] 버튼 클릭 시 (조치중 상태 변환 후 조치보고 페이지 이동)
    document.getElementById("btn-toast-confirm").onclick = function () {
        const situNo = toastWindow.getAttribute("data-situ-no");

        fetch(`${pageContext.request.contextPath}/agent/situation/accept?situNo=` + situNo, { method: 'POST' })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    toastWindow.style.display = "none";
                    location.href = "${pageContext.request.contextPath}/agent/history";
                } else {
                    alert(result.message);
                }
            })
            .catch(err => console.error("상태 업데이트 실패:", err));
    };

    // [닫기] 버튼 클릭 시 (홈 화면 종 모양 배너 배지 카운트 누적)
    document.getElementById("btn-toast-close").onclick = function () {
        // ① 종 모양 배지 카운트 증가
        const badge = document.getElementById("badge-count");
        if (badge) {
            let currentCount = parseInt(badge.innerText) || 0;
            currentCount += 1;
            badge.innerText = currentCount;
            badge.style.display = "inline-block";
        }

        // ② 종 모양 클릭 시 열릴 알림 이력창 드롭다운에 리스트 적재
        const historyList = document.getElementById("noti-history-list");
        if (historyList) {
            const li = document.createElement("li");
            li.style.padding = "10px 6px";
            li.style.borderBottom = "1px solid #f1f5f9";
            li.innerHTML = `<strong>[\${situation.dngrType}]</strong> \${situation.situContent || '내용 없음'} <br><small style="color:#94a3b8;">이력번호: \${situation.situNo}</small>`;
            historyList.appendChild(li);
        }

        toastWindow.style.display = "none"; // 알림창 숨기기
    };
}
</script>
