<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 1. 상단 알림창 디자인 (타임라인 게이지 바 추가) -->
<style>
.toast-popup-top {
    position: fixed;
    top: 16px;
    left: 50%;
    transform: translateX(-50%);
    width: 92%;
    max-width: 420px;
    background-color: #ffffff; 
    color: #1e293b;            
    border-radius: 20px;       
    border: 1px solid #e2f7ed; 
    box-shadow: 0 16px 36px rgba(15, 23, 42, 0.04), 0 4px 12px rgba(0, 0, 0, 0.02); 
    padding: 18px 18px 22px 18px; 
    z-index: 999999;
    box-sizing: border-box;
    font-family: -apple-system, BlinkMacSystemFont, "Malgun Gothic", sans-serif;
    animation: slideDownMobile 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    overflow: hidden; 
}

@keyframes slideDownMobile {
    from { transform: translate(-50%, -120%); opacity: 0; }
    to { transform: translate(-50%, 0); opacity: 1; }
}

@keyframes slideUpMobile {
    from { transform: translate(-50%, 0); opacity: 1; }
    to { transform: translate(-50%, -120%); opacity: 0; }
}

.toast-popup-top.hide {
    animation: slideUpMobile 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards !important;
}

.toast-header {
    font-size: 15px;            
    font-weight: bold;           
    margin-bottom: 12px;
    color: rgb(0, 0, 30);            
    display: flex;
    align-items: center;
    gap: 6px;
    letter-spacing: -0.5px;     
}

.toast-body p {
    margin: 6px 0;
    font-size: 13.5px;
    line-height: 1.5;
    color: #475569; 
}
.toast-body p strong {
    color: #0f172a;
    font-weight: 700;
    margin-right: 6px;
}

#toast-content {
    display: block;
    margin-top: 8px;
    color: #008758;            
    font-size: 13.5px;
    font-weight: 600;
    background-color: #f0fdf4; 
    padding: 12px 14px;
    border-radius: 12px;
    border: 1px solid #d1fae5; 
    line-height: 1.6;
}

.toast-footer {
    display: flex;
    justify-content: space-between;
    margin-top: 18px;
    gap: 10px;
}

.btn-close {
    background-color: #f1f5f9; 
    color: #64748b;
    border: none;
    border-radius: 12px;
    padding: 11px 0;
    flex: 1;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s;
}
.btn-close:hover {
    background-color: #e2e8f0;
}

.btn-confirm {
    background-color: #00B074; 
    color: #ffffff;
    border: none;
    border-radius: 12px;
    padding: 11px 0;
    flex: 1.4;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
    box-shadow: 0 4px 14px rgba(0, 176, 116, 0.18); 
    transition: background 0.2s;
}
.btn-confirm:hover {
    background-color: #009663; 
}

.toast-progress-container {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 4px;
    background-color: #f1f5f9;
}

.toast-progress-bar {
    width: 0%;
    height: 100%;
    background-color: #00B074; 
}

@keyframes progressAnimation {
    from { width: 0%; }
    to { width: 100%; }
}

.toast-popup-top.activeProgress .toast-progress-bar {
    animation: progressAnimation 30s linear forwards;
}
</style>

<!-- 2. 알림창 UI 뼈대 -->
<div id="realtime-toast" class="toast-popup-top" style="display: none;">
    <div class="toast-header">
        <span class="toast-title">🚨 실시간 위험 감지</span>
    </div>
    <div class="toast-body">
        <p><strong>유형:</strong> <span id="toast-type"></span> (<span id="toast-level"></span>)</p>
        <p><span id="toast-content"></span></p>
    </div>
    <div class="toast-footer">
        <button id="btn-toast-close" class="btn-close">닫기</button>
        <button id="btn-toast-confirm" class="btn-confirm">확인</button>
    </div>
    <div class="toast-progress-container">
        <div id="toast-progress-bar" class="toast-progress-bar"></div>
    </div>
</div>

<!-- 3. 실시간 SSE 통신 및 애니메이션 제어 스크립트 -->
<script>
let toastAutoCloseTimer = null;

document.addEventListener("DOMContentLoaded", function () {
	const eventSource = new EventSource(window.location.origin + "/agent/sse/connect");

    eventSource.addEventListener("connect", function (e) {
        console.log("상단 실시간 알림 서버 동기화 완료:", e.data);
    });

    eventSource.addEventListener("situation-alert", function (event) {
        const situation = JSON.parse(event.data);
        console.log("위험 감지 알림 수신:", situation);
        
        showTopToastNotification(situation);
    });
});

function showTopToastNotification(situation) {
    const toastWindow = document.getElementById("realtime-toast");
    if (!toastWindow) return;

    if (toastAutoCloseTimer) clearTimeout(toastAutoCloseTimer);
    toastWindow.classList.remove("hide", "activeProgress");
    void toastWindow.offsetWidth; 

    // 데이터 렌더링
    document.getElementById("toast-type").innerText = situation.dngrType;
    document.getElementById("toast-level").innerText = situation.dngrLevel;
    document.getElementById("toast-content").innerText = situation.situContent || "내용 없음";
    
    toastWindow.setAttribute("data-situ-no", situation.situNo);
    toastWindow.style.display = "block"; 
    toastWindow.classList.add("activeProgress");

    // 30초 자동 타임아웃 닫기
    toastAutoCloseTimer = setTimeout(function() {
        document.getElementById("btn-toast-close").click(); 
    }, 30000);

    // [확인] 버튼 클릭 핸들러
    document.getElementById("btn-toast-confirm").onclick = function () {
        if (toastAutoCloseTimer) clearTimeout(toastAutoCloseTimer); 
        const situNo = toastWindow.getAttribute("data-situ-no");

        fetch("${pageContext.request.contextPath}/agent/situation/accept?situNo=" + situNo, { method: 'POST' })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    toastWindow.classList.add("hide");
                    setTimeout(() => {
                        toastWindow.style.display = "none";
                        location.href = "${pageContext.request.contextPath}/agent/history";
                    }, 400); 
                } else {
                    alert(result.message);
                }
            })
            .catch(err => console.error("상태 업데이트 실패:", err));
    };

    // [닫기] 버튼 및 30초 자동 트리거 연동 핸들러
    document.getElementById("btn-toast-close").onclick = function () {
        if (toastAutoCloseTimer) clearTimeout(toastAutoCloseTimer); 

        toastWindow.classList.add("hide");

        setTimeout(() => {
            // ① 세션 스토리지(보관함)에 알림 이력 데이터 세이브
            let savedList = JSON.parse(sessionStorage.getItem("alarmStorageList")) || [];
            
            const isDuplicate = savedList.some(item => item.situNo === situation.situNo);
            if (!isDuplicate) {
                savedList.push({
                    situNo: situation.situNo,
                    dngrType: situation.dngrType,
                    dngrLevel: situation.dngrLevel,
                    situContent: situation.situContent || "내용 없음",
                    saveTime: new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' })
                });
                sessionStorage.setItem("alarmStorageList", JSON.stringify(savedList));
            }

            // 🚨 [동기화 수정] 메인화면 종의 .bell-count 클래스 텍스트 업데이트
            const badge = document.querySelector(".bell-count");
            if (badge) {
                badge.innerText = savedList.length;
            }
            
            toastWindow.style.display = "none"; 
        }, 400); 
    };
}

// 💡 페이지 로드 시점 보관함 데이터 기반 배지 카운트 복원 초기화
document.addEventListener("DOMContentLoaded", function() {
    let savedList = JSON.parse(sessionStorage.getItem("alarmStorageList")) || [];
    const badge = document.querySelector(".bell-count");
    if (badge) {
        badge.innerText = savedList.length;
    }
});
</script>
