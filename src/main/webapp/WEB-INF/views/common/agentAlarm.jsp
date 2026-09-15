<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 1. 상단 알림창 디자인 (네이버페이 스타일 + 모바일 규격 최적화) -->
<style>
/* 💡 앱 고유의 [근무중] 그린 컬러와 완벽히 동기화된 상단 알림창 */
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
    padding: 18px;
    z-index: 999999;
    box-sizing: border-box;
    font-family: -apple-system, BlinkMacSystemFont, "Malgun Gothic", sans-serif;
    animation: slideDownMobile 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes slideDownMobile {
    from { transform: translate(-50%, -120%); opacity: 0; }
    to { transform: translate(-50%, 0); opacity: 1; }
}

/* 💡 헤더 영역 - 근무중 버튼 고유의 청량한 그린 컬러 적용 */
.toast-header {
    font-size: 15px;            
    font-weight: bold;           
    margin-bottom: 12px;
    color: rgb(0, 0, 30);            /* 💡 추출한 고유 색상 매칭 */
    display: flex;
    align-items: center;
    gap: 6px;
    letter-spacing: -0.5px;     
}

/* 본문 영역 */
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

/* 내용 박스 구역 */
#toast-content {
    display: block;
    margin-top: 8px;
    color: #008758;            /* 텍스트 가독성을 위해 본문 박스 글씨만 살짝 묵직하게 유지 */
    font-size: 13.5px;
    font-weight: 600;
    background-color: #f0fdf4; 
    padding: 12px 14px;
    border-radius: 12px;
    border: 1px solid #d1fae5; 
    line-height: 1.6;
}

/* 하단 버튼 영역 */
.toast-footer {
    display: flex;
    justify-content: space-between;
    margin-top: 18px;
    gap: 10px;
}

/* 닫기 버튼 */
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

/* 💡 확인 버튼 - 근무중 버튼 고유의 청량한 그린 컬러 적용 */
.btn-confirm {
    background-color: #00B074; /* 💡 추출한 고유 색상 매칭 */
    color: #ffffff;
    border: none;
    border-radius: 12px;
    padding: 11px 0;
    flex: 1.4;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
    box-shadow: 0 4px 14px rgba(0, 176, 116, 0.18); /* 그림자 색상 동기화 */
    transition: background 0.2s;
}
.btn-confirm:hover {
    background-color: #009663; /* 터치 시 정갈하게 딥해지는 컬러 밸런스 */
}
</style>

<!-- 2. 알림창 UI 뼈대 (HTML) -->
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
