<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

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

/* 💡 자동 정렬로 줄바꿈이 되어도 정상 작동하도록 문법 구조 보완 */
@keyframes slideDownMobile {
	0% { transform: translate(-50%, -120%); opacity: 0; }
	100% { transform: translate(-50%, 0); opacity: 1; }
}

@keyframes slideUpMobile {
	0% { transform: translate(-50%, 0); opacity: 1; }
	100% { transform: translate(-50%, -120%); opacity: 0; }
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

/* 💡 모바일 가독성을 위해 두께를 5px로 늘리고, 레이어를 최상단(z-index: 10)으로 배치 */
.toast-progress-container {
	position: absolute;
	bottom: 0;
	left: 0;
	width: 100%;
	height: 5px;
	background-color: #f1f5f9;
	z-index: 10;
}

.toast-progress-bar {
	width: 0%;
	height: 100%;
	background-color: #00B074;
}

/* 💡 줄바꿈 에러를 방지하기 위해 0%와 100% 구조로 전면 수정 */
@keyframes progressAnimation {
	0% { width: 0%; }
	100% { width: 100%; }
}

/* 💡 클래스와 ID 결합자를 모두 사용하여 브라우저가 애니메이션을 무조건 최우선 적용하도록 강제함 */
.toast-popup-top.activeProgress #toast-progress-bar {
	animation: progressAnimation 10s linear forwards !important;
}
</style>


<!-- 2. 알림창 UI 뼈대 -->
<div id="realtime-toast" class="toast-popup-top" style="display: none;">
	<div class="toast-header">
		<span class="toast-title">🚨 실시간 위험 감지</span>
	</div>
	<div class="toast-body">
		<p>
			<strong>유형:</strong> <span id="toast-type"></span> (<span
				id="toast-level"></span>)
		</p>
		<p>
			<span id="toast-content"></span>
		</p>
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
let currentSituation = null; // 현재 활성화된 알림 데이터를 전역 범위에서 관리

document.addEventListener("DOMContentLoaded", function () {
    // 1. SSE 연결
    const eventSource = new EventSource(window.location.origin + "/agent/sse/connect");

    eventSource.addEventListener("connect", function (e) {
        console.log("상단 실시간 알림 서버 동기화 완료:", e.data);
    });

    eventSource.addEventListener("situation-alert", function (event) {
        const situation = JSON.parse(event.data);
        console.log("위험 감지 알림 수신:", situation);
        
        showTopToastNotification(situation);
    });

    // 2. 페이지 로드 시점 보관함 데이터 기반 배지 카운트 복원 초기화
    updateBellCount();

    // 3. [확인] 및 [닫기] 버튼 이벤트 핸들러를 최초 1회만 고정 등록
    document.getElementById("btn-toast-confirm").onclick = function () {
        if (!currentSituation) return;
        if (toastAutoCloseTimer) clearTimeout(toastAutoCloseTimer); 

        const toastWindow = document.getElementById("realtime-toast");
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

    document.getElementById("btn-toast-close").onclick = function () {
        executeToastClose(); // 공통 닫기 및 보관함 저장 로직 실행
    };
});

// 💡 팝업 활성화 함수
function showTopToastNotification(situation) {
    const toastWindow = document.getElementById("realtime-toast");
    if (!toastWindow) return;

    if (toastAutoCloseTimer) clearTimeout(toastAutoCloseTimer);
    toastWindow.classList.remove("hide", "activeProgress");
    void toastWindow.offsetWidth; // 애니메이션 리셋용 트릭

    // 현재 수신한 알림 데이터를 상위 변수에 명확히 바인딩
    currentSituation = situation;

    // 데이터 렌더링
    document.getElementById("toast-type").innerText = situation.dngrType;
    document.getElementById("toast-level").innerText = situation.dngrLevel;
    document.getElementById("toast-content").innerText = situation.situContent || "내용 없음";
    
    toastWindow.setAttribute("data-situ-no", situation.situNo);
    toastWindow.style.display = "block"; 
    toastWindow.classList.add("activeProgress");

    // 💡 10초 자동 타임아웃 -> 가짜 클릭 대신 공통 함수 직접 실행
    toastAutoCloseTimer = setTimeout(function() {
        console.log("10초 타임아웃 완료 - 자동 닫기 실행");
        executeToastClose(); 
    }, 10000);
}

// 💡 [공통] 토스트를 닫고 보관함에 저장하는 핵심 함수 (타이밍 이슈 완벽 보완)
function executeToastClose() {
    if (toastAutoCloseTimer) {
        clearTimeout(toastAutoCloseTimer); 
        toastAutoCloseTimer = null;
    }

    const toastWindow = document.getElementById("realtime-toast");
    if (!toastWindow || toastWindow.style.display === "none") return;

    // ✨ [순서 변경] 애니메이션이 실행되어 화면에서 사라지기 전에 세션 스토리지에 미리 데이터를 적립합니다.
    if (currentSituation) {
        let savedList = JSON.parse(sessionStorage.getItem("alarmStorageList")) || [];
        
        const isDuplicate = savedList.some(item => item.situNo === currentSituation.situNo);
        if (!isDuplicate) {
            savedList.push({
                situNo: currentSituation.situNo,
                dngrType: currentSituation.dngrType,
                dngrLevel: currentSituation.dngrLevel,
                situContent: currentSituation.situContent || "내용 없음",
                saveTime: new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' })
            });
            sessionStorage.setItem("alarmStorageList", JSON.stringify(savedList));
            console.log("보관함에 성공적으로 알림 적립 완료:", currentSituation.situNo);
        }
    }

    // 종 배지 카운트는 데이터가 저장된 직후 바로 반영하여 반응성을 높입니다.
    updateBellCount();

    // 데이터를 안전하게 다 대피시켰으므로 서서히 사라지는 애니메이션(400ms) 실행
    toastWindow.classList.add("hide");

    setTimeout(() => {
        toastWindow.style.display = "none"; 
        currentSituation = null; // 모든 작업이 완벽히 끝난 뒤 변수 리셋
    }, 400); 
}

// 💡 배지 카운트 업데이트 공통화
function updateBellCount() {
    let savedList = JSON.parse(sessionStorage.getItem("alarmStorageList")) || [];
    const badge = document.querySelector(".bell-count");
    if (badge) {
        badge.innerText = savedList.length;
    }
}
</script>