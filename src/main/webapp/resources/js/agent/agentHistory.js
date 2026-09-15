let offset = 0;       
let limit = 6;  
let isLoading = false; 
let isEnd = false;    
let currentStatus = "ALL";

document.addEventListener("DOMContentLoaded", function() {
    
    // 1. 첫 데이터 조회
    loadMoreTasks();

    // 2. 스크롤 이벤트 타겟 감지 (.mobile-content 스크롤 유지)
    const scrollContainer = document.querySelector(".mobile-content");
    if (scrollContainer) {
        scrollContainer.addEventListener("scroll", handleScroll);
    }
    
    // 3. 카드 클릭 시 상세 조치보고서 작성/편집 페이지로 이동
    const historyList = document.getElementById("historyList");
    if (historyList) {
        historyList.addEventListener("click", function(e) {
            var card = e.target.closest(".history-card");
            if (card) {
                // 💡 중요: AGENT_TASK의 id 대신 SITUATIONS의 PK인 situNo를 가로챕니다.
                var situNo = card.getAttribute("data-id");
                if (situNo) {
                    location.href = contextPath + "/agent/taskEdit?situNo=" + situNo;
                }
            }
        });
    }

    // 4. 서브 메뉴바 탭 클릭 이벤트
    const tabButtons = document.querySelectorAll(".sub-menu-bar .tab-btn");
    tabButtons.forEach(button => {
        button.addEventListener("click", function() {
            if (this.classList.contains("active")) return;

            tabButtons.forEach(btn => btn.classList.remove("active"));
            this.classList.add("active");

            currentStatus = this.getAttribute("data-status");
            resetAndReload();
        });
    });

    /* 하단 메뉴 바인딩 */
    $("#navPatrol").on("click", function() { location.href = "patrol"; });
    $("#navHome").on("click", function() { location.href = "main"; });
    $("#navReport").on("click", function() { location.href = "history"; });
});

// 스크롤 감지 로직
function handleScroll() {
    if (isLoading || isEnd) return;

    const scrollContainer = document.querySelector(".mobile-content");
    if (!scrollContainer) return;

    const isBottom = scrollContainer.scrollTop + scrollContainer.clientHeight >= scrollContainer.scrollHeight - 50;

    if (isBottom) {
        loadMoreTasks();
    }
}

// 탭 변경 시 초기화
function resetAndReload() {
    isLoading = false;
    isEnd = false;
    offset = 0;
    
    const container = document.getElementById("historyList");
    if (container) container.innerHTML = "";
    
    loadMoreTasks();
}

// 데이터 Fetch (SituationDTO 반환 구조 대응)
function loadMoreTasks() {
    if (isLoading || isEnd) return;
    isLoading = true;

    const loadingEl = document.getElementById("loading");
    if (loadingEl) loadingEl.style.display = "block";

    const url = contextPath + "/agent/history/more"
              + "?offset=" + offset 
              + "&limit=" + limit
              + "&actionStatus=" + encodeURIComponent(currentStatus);

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("네트워크 응답 오류");
            return response.json();
        })
        .then(data => {
            const container = document.getElementById("historyList");
            const countEl = document.getElementById("totalCount");
        
            if (countEl && data.totalCount !== undefined) {
                countEl.textContent = data.totalCount;
            }
        
            const taskList = data.tasks; 
        
            if (!taskList || taskList.length === 0) {
                isEnd = true;
                if (offset === 0 && container) {
                    container.innerHTML = '<div style="text-align: center; padding: 40px; color: #888;">조회된 조치 내역이 없습니다.</div>';
                }
                return;
            }
        
            if (container) {
                taskList.forEach(task => {
                    const cardHtml = createCardHtml(task);
                    container.insertAdjacentHTML('beforeend', cardHtml);
                });
            }
        
            offset += taskList.length;
            if (taskList.length < limit) {
                isEnd = true;
            }
        })
        .catch(error => {
            console.error("데이터 로딩 중 에러 발생:", error);
        })
        .finally(() => {
            isLoading = false;
            if (loadingEl) loadingEl.style.display = "none";
        });
}

// 💳 SituationDTO 구조 기반 카드 HTML 동적 렌더링
function createCardHtml(task) {
    // 1. 유형 배지 설정: 위험유형(task.dngrType) 기준 파스텔 배징 매핑
    var rawType = task.dngrType || task.DNGR_TYPE || '기타';
    var badgeClass = "badge-patrol";

    if (rawType.includes('위험') || rawType.includes('인파') || rawType.includes('사고')) {
        badgeClass = "badge-emergency"; // 긴급/위험은 레드 칩
    } else if (rawType.includes('점검')) {
        badgeClass = "badge-check";     // 점검은 그린 칩
    } else if (rawType.includes('지원')) {
        badgeClass = "badge-support";   // 지원은 퍼플 칩
    } else {
        badgeClass = "badge-other";     // 기타는 그레이 칩
    }

    // 2. 조치 상태 칩 제어 (SITU_STATUS 분기)
    var situStatus = task.situStatus || task.SITU_STATUS || '';
    var statusText = '조치중';
    var statusClass = 'status-progress';
    
    if (situStatus === '완료' || situStatus === '조치완료') {
        statusText = '완료';
        statusClass = 'status-complete';
    } else {
        statusText = '조치중';
        statusClass = 'status-progress'; // 알림창 수락 직후 기본 상태
    }

    // 3. 텍스트 바인딩 규칙 변환
    var taskTitle = task.situContent || task.SITU_CONTENT || '내용 없음'; // 감지 내용 출력
    var taskArea = task.zoneName || task.ZONE_NAME || '';                // 구역명 추출
    
    // 4. 시간 데이터 정돈 및 타입 변환 에러 안전 조치 (START_DATE 적용)
    var startTime = task.startDate || task.START_DATE || '';
    if (startTime) {
        if (typeof startTime === 'number' || startTime instanceof Date) {
            var d = new Date(startTime);
            var pad = function(n) { return n < 10 ? '0' + n : n; };
            startTime = d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
        } else {
            startTime = String(startTime);
            if (startTime.includes('T')) {
                startTime = startTime.substring(0, 16).replace('T', ' '); 
            }
        }
    } else {
        startTime = '';
    }

    // 고유 식별 PK 키 변환
    var situNo = task.situNo || task.SITU_NO || '';

    // 💡 [버그 수정] 깨짐 방지를 위해 history-title의 인라인 고정 너비 속성을 완전히 제거했습니다.
    return '<div class="history-card" data-id="' + situNo + '">' +
                '<div class="card-main">' +
                    '<div class="title-row">' +
                        '<span class="badge ' + badgeClass + '">' + rawType + '</span>' +
                        '<span class="history-title">' + taskTitle + '</span>' +
                    '</div>' +
                    '<div class="info-meta">' +
                        '<span>' + (taskArea ? taskArea + '구역' : '') + '</span>' +
                        '<span>' + startTime + '</span>' +
                    '</div>' +
                '</div>' +
                '<span class="badge-status ' + statusClass + '">' + statusText + '</span>' +
            '</div>';
}