let offset = 0;       
let limit = 6;  // 💡 기존 4에서 6으로 늘려 스크롤 바가 확실히 생기도록 조정
let isLoading = false; 
let isEnd = false;    
let currentStatus = "ALL";

document.addEventListener("DOMContentLoaded", function() {
    
    // 1. 첫 데이터 조회
    loadMoreTasks();

    // 2. 스크롤 이벤트 타겟 수정 (.mobile-content 감지)
    const scrollContainer = document.querySelector(".mobile-content");
    if (scrollContainer) {
        scrollContainer.addEventListener("scroll", handleScroll);
    }
    
    // 3. 카드 클릭 시 상세 페이지 이동
    const historyList = document.getElementById("historyList");
    if (historyList) {
        historyList.addEventListener("click", function(e) {
            var card = e.target.closest(".history-card");
            if (card) {
                var taskId = card.getAttribute("data-id");
                if (taskId) {
                    location.href = contextPath + "/agent/taskEdit?id=" + taskId;
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

// 💡 .mobile-content 스크롤 감지 로직 수정
function handleScroll() {
    if (isLoading || isEnd) return;

    const scrollContainer = document.querySelector(".mobile-content");
    if (!scrollContainer) return;

    // 내부 스크롤 바닥 감지 (바닥 50px 전에 추가 로딩 실행)
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

// 데이터 Fetch
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

// 카드 HTML 생성
function createCardHtml(task) {
    var rawType = task.taskType || task.TASK_TYPE || '';
    var taskTypeText = rawType;
    var badgeClass = "badge-patrol";

    if (rawType === 'EMERGENCY' || rawType === '긴급') {
        taskTypeText = '긴급'; badgeClass = "badge-emergency";
    } else if (rawType === 'REPORT' || rawType === '상황') {
        taskTypeText = '상황'; badgeClass = "badge-report";
    } else if (rawType === 'PATROL' || rawType === '순찰') {
        taskTypeText = '순찰'; badgeClass = "badge-patrol";
    } else if (rawType === 'INSPECTION' || rawType === '점검') {
        taskTypeText = '점검'; badgeClass = "badge-check";
    } else if (rawType === 'SUPPORT' || rawType === '지원') {
        taskTypeText = '지원'; badgeClass = "badge-support";
    } else if (rawType === 'OTHER' || rawType === '기타') {
        taskTypeText = '기타'; badgeClass = "badge-other";
    }

    var actionStatus = task.actionStatus || task.ACTION_STATUS || '';
    var statusText = '미조치';
    var statusClass = 'status-end';
    
    // 1. 조치중/조치대기
    if (actionStatus === 'PENDING' || actionStatus === '조치중' || actionStatus === '조치대기') {
        statusText = '조치중';
        statusClass = 'status-progress';
    } 
    // 2. 조치완료/완료
    else if (actionStatus === 'COMPLETED' || actionStatus === '조치완료' || actionStatus === '완료') {
        statusText = '완료';
        statusClass = 'status-complete';
    }
    // 3. 미조치종결/미조치 (텍스트는 '미조치' 그대로 보존)
    else {
        statusText = '미조치';
        statusClass = 'status-end';
    }

    var taskTitle = task.taskTitle || task.TASK_TITLE || '제목 없음';
    var taskArea = task.taskArea || task.TASK_AREA || '';
    var startTime = task.startTime || task.START_TIME || '';
    if(startTime && startTime.includes('T')) {
        startTime = startTime.substring(0, 16).replace('T', ' '); 
    }

    var taskId = task.taskId || task.TASK_ID || task.id || '';

    return '<div class="history-card" data-id="' + taskId + '">' +
                '<div class="card-main">' +
                    '<div class="title-row">' +
                        '<span class="badge ' + badgeClass + '">' + taskTypeText + '</span>' +
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