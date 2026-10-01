let currentPage = 1;      // 현재 페이지 번호
const limit = 6;          // 한 페이지당 표시할 카드 수
let currentStatus = "ALL"; // 현재 선택된 탭 상태

document.addEventListener("DOMContentLoaded", function() {
    
    // 1. 첫 페이지 데이터 조회
    loadTasks(1);

    // 2. 카드 클릭 시 상세 조치보고서 작성/편집 페이지로 이동 (기존 로직 유지)
    const historyList = document.getElementById("historyList");
    if (historyList) {
        historyList.addEventListener("click", function(e) {
            var card = e.target.closest(".history-card");
            if (card) {
                var situNo = card.getAttribute("data-id");
                if (situNo) {
                    location.href = contextPath + "/agent/taskEdit?situNo=" + situNo;
                }
            }
        });
    }

    // 3. 서브 메뉴바 탭 클릭 이벤트 (기존 로직 유지)
    const tabButtons = document.querySelectorAll(".sub-menu-bar .tab-btn");
    tabButtons.forEach(button => {
        button.addEventListener("click", function() {
            if (this.classList.contains("active")) return;

            tabButtons.forEach(btn => btn.classList.remove("active"));
            this.classList.add("active");

            currentStatus = this.getAttribute("data-status");
            currentPage = 1; // 탭 전환 시 1페이지로 리셋
            loadTasks(1);
        });
    });

    /* 하단 메뉴 바인딩 */
    $("#navPatrol").on("click", function() { location.href = "patrol"; });
    $("#navHome").on("click", function() { location.href = "main"; });
    $("#navReport").on("click", function() { location.href = "history"; });
});

// 🎯 페이지 단위 데이터 Fetch (백엔드 API 연동)
function loadTasks(page) {
    currentPage = page;
    const offset = (currentPage - 1) * limit; // 백엔드 오프셋 계산

    const loadingEl = document.getElementById("loading");
    if (loadingEl) loadingEl.style.display = "block";

    const container = document.getElementById("historyList");
    if (container) container.innerHTML = ""; // 기존 카드 초기화

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
            const countEl = document.getElementById("totalCount");
            const totalCount = data.totalCount || 0;
        
            if (countEl) {
                countEl.textContent = totalCount;
            }
        
            const taskList = data.tasks; 
        
            // 데이터가 없는 경우
            if (!taskList || taskList.length === 0) {
                if (container) {
                    container.innerHTML = '<div style="text-align: center; padding: 40px; color: #888;">조회된 조치 내역이 없습니다.</div>';
                }
                renderPagination(0);
                return;
            }
        
            // 카드 렌더링
            if (container) {
                taskList.forEach(task => {
                    const cardHtml = createCardHtml(task);
                    container.insertAdjacentHTML('beforeend', cardHtml);
                });
            }

            // 하단 페이지 번호 버튼 렌더링
            renderPagination(totalCount);
        })
        .catch(error => {
            console.error("데이터 로딩 중 에러 발생:", error);
            if (container) {
                container.innerHTML = '<div style="text-align: center; padding: 40px; color: #e53e3e;">데이터를 불러오는 중 오류가 발생했습니다.</div>';
            }
        })
        .finally(() => {
            if (loadingEl) loadingEl.style.display = "none";
        });
}

// 🎯 하단 페이징 버튼 생성
function renderPagination(totalCount) {
    const paginationContainer = document.getElementById("paginationContainer");
    if (!paginationContainer) return;
    paginationContainer.innerHTML = "";

    const totalPages = Math.ceil(totalCount / limit) || 1;
    if (totalPages <= 1) return; // 1페이지 이하면 버튼 표시 안함

    let html = "";

    // 이전 버튼
    const isPrevDisabled = currentPage <= 1;
    html += '<button type="button" class="page-btn"' + (isPrevDisabled ? ' disabled' : '') + ' onclick="changePage(' + (currentPage - 1) + ')"><i class="fa-solid fa-chevron-left"></i></button>';

    // 페이지 번호 버튼
    for (let i = 1; i <= totalPages; i++) {
        const activeClass = (i === currentPage) ? ' active' : '';
        html += '<button type="button" class="page-btn' + activeClass + '" onclick="changePage(' + i + ')">' + i + '</button>';
    }

    // 다음 버튼
    const isNextDisabled = currentPage >= totalPages;
    html += '<button type="button" class="page-btn"' + (isNextDisabled ? ' disabled' : '') + ' onclick="changePage(' + (currentPage + 1) + ')"><i class="fa-solid fa-chevron-right"></i></button>';

    paginationContainer.innerHTML = html;
}

// 🎯 페이지 이동 및 스크롤 상단 이동
function changePage(page) {
    loadTasks(page);
    
    const scrollContainer = document.querySelector(".mobile-content");
    if (scrollContainer) {
        scrollContainer.scrollTo({ top: 0, behavior: 'smooth' });
    } else {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
}

// 💳 SituationDTO 구조 기반 카드 HTML 동적 렌더링 (기존 로직 100% 유지)
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

    return '<div class="history-card" data-id="' + situNo + '">' +
                '<div class="card-main">' +
                    '<div class="title-row">' +
                        '<span class="badge ' + badgeClass + '">' + rawType + '</span>' +
                        '<span class="history-title">' + taskTitle + '</span>' +
                    '</div>' +
                    '<div class="info-meta">' +
                        '<span>' + (taskArea ? taskArea : '') + '</span>' +
                        '<span>' + startTime + '</span>' +
                    '</div>' +
                '</div>' +
                '<span class="badge-status ' + statusClass + '">' + statusText + '</span>' +
            '</div>';
}