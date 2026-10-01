// 전역 페이징 변수
let currentPage = 1;
const pageSize = 5; // 한 페이지에 표시할 알림 카드 수 (원하는 숫자로 변경 가능)

document.addEventListener("DOMContentLoaded", function() {
    renderAlarmList();

    // 🚨 [핵심 기능] 버튼을 누르지 않고 카드 외부의 빈 공간을 터치하면 다시 요약 상태로 접기
    document.addEventListener("click", function(event) {
        const openedCard = document.querySelector(".report-card.active");
        if (openedCard) {
            // 클릭된 대상이 열려있는 카드 영역(.report-card) 내부가 아니라면 접기
            if (!openedCard.contains(event.target)) {
                openedCard.classList.remove("active");
                console.log("카드가 아닌 외부 영역이 터치되어 요약 상태로 되돌립니다.");
            }
        }
    });
});

// 전역 contextPath 가져오기
const contextPath = window.contextPath || "";

// 보관함 목록 렌더링 함수 (페이징 적용)
function renderAlarmList() {
    const container = document.getElementById("report-list-container");
    const paginationContainer = document.getElementById("paginationContainer");
    if (!container) return;
    
    let savedList = JSON.parse(sessionStorage.getItem("alarmStorageList")) || [];

    // 데이터가 없는 경우 처리
    if (savedList.length === 0) {
        container.innerHTML = 
            '<div class="empty-msg">' +
            '    <i class="fa-solid fa-bell-slash"></i>' +
            '    <p>보관된 실시간 위험 알림이 없습니다.</p>' +
            '</div>';
        if (paginationContainer) paginationContainer.innerHTML = "";
        return;
    }

    // 1. 최신 알림이 제일 위로 오도록 역순 정렬
    const reversedList = [...savedList].reverse();

    // 2. 페이징 계산
    const totalPages = Math.ceil(reversedList.length / pageSize) || 1;
    if (currentPage > totalPages) currentPage = totalPages;
    if (currentPage < 1) currentPage = 1;

    const startIndex = (currentPage - 1) * pageSize;
    const pageData = reversedList.slice(startIndex, startIndex + pageSize);

    // 3. 카드 HTML 생성
    let html = "";
    pageData.forEach((item) => {
        html += 
            '<div class="report-card" onclick="toggleCardDetail(event, this)">' +
            '    <div class="card-top">' +
            '        <span class="badge-type">' + (item.dngrType || '알림') + '</span>' +
            '        <div class="card-summary-title">' + (item.situContent || '') + '</div>' +
            '        <span class="report-time">' + (item.saveTime || '') + '</span>' +
            '    </div>' +
            '    <div class="card-detail-area" onclick="event.stopPropagation();">' +
            '        <div class="card-body">' +
            '            <strong>상황 세부 내용:</strong><br>' + (item.situContent || '') +
            '        </div>' +
            '        <div class="card-actions">' +
            '            <button class="btn-action-delete" onclick="deleteStorageItem(\'' + item.situNo + '\')">삭제</button>' +
            '            <button class="btn-action-confirm" onclick="acceptStorageItem(\'' + item.situNo + '\')">확인</button>' +
            '        </div>' +
            '    </div>' +
            '</div>';
    });
    container.innerHTML = html;

    // 4. 하단 페이징 버튼 생성
    renderPagination(totalPages);
}

// 하단 페이징 버튼 렌더링 함수
function renderPagination(totalPages) {
    const container = document.getElementById("paginationContainer");
    if (!container) return;
    container.innerHTML = "";

    if (totalPages <= 1) return; // 1페이지 이하일 경우 페이징 버튼 생략

    let navHtml = "";

    // 이전 버튼
    const isPrevDisabled = currentPage <= 1;
    navHtml += '<button type="button" class="page-btn" ' + (isPrevDisabled ? 'disabled' : '') + ' onclick="changePage(' + (currentPage - 1) + ')"><i class="fa-solid fa-chevron-left"></i></button>';

    // 페이지 번호 버튼
    for (let i = 1; i <= totalPages; i++) {
        const activeClass = (i === currentPage) ? ' active' : '';
        navHtml += '<button type="button" class="page-btn' + activeClass + '" onclick="changePage(' + i + ')">' + i + '</button>';
    }

    // 다음 버튼
    const isNextDisabled = currentPage >= totalPages;
    navHtml += '<button type="button" class="page-btn" ' + (isNextDisabled ? 'disabled' : '') + ' onclick="changePage(' + (currentPage + 1) + ')"><i class="fa-solid fa-chevron-right"></i></button>';

    container.innerHTML = navHtml;
}

// 페이지 이동 함수
function changePage(page) {
    currentPage = page;
    renderAlarmList();
    window.scrollTo({ top: 0, behavior: 'smooth' }); // 페이지 변경 시 맨 위로 스크롤
}

// 카드 아코디언 토글 (이벤트 버블링 방지 유지)
function toggleCardDetail(event, cardElement) {
    event.stopPropagation(); // 외부 문서 클릭 이벤트로 전달되는 것을 방지
    
    const isActive = cardElement.classList.contains("active");
    
    // 다른 카드가 열려있다면 먼저 접기
    document.querySelectorAll(".report-card").forEach(card => card.classList.remove("active"));
    
    // 상태에 따라 토글
    if (!isActive) {
        cardElement.classList.add("active");
    } else {
        cardElement.classList.remove("active");
    }
}

// [삭제] 버튼 액션
function deleteStorageItem(situNo) {
    if(!confirm("이 알림 이력을 보관함에서 삭제하시겠습니까?")) return;
    
    let savedList = JSON.parse(sessionStorage.getItem("alarmStorageList")) || [];
    savedList = savedList.filter(item => item.situNo !== situNo);
    sessionStorage.setItem("alarmStorageList", JSON.stringify(savedList));
    
    renderAlarmList(); // 삭제 후 목록 및 페이징 재계산
}

// [확인] 버튼 액션
function acceptStorageItem(situNo) {
    fetch(contextPath + "/agent/situation/accept?situNo=" + situNo, { method: 'POST' })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                let savedList = JSON.parse(sessionStorage.getItem("alarmStorageList")) || [];
                savedList = savedList.filter(item => item.situNo !== situNo);
                sessionStorage.setItem("alarmStorageList", JSON.stringify(savedList));
                
                location.href = contextPath + "/agent/history";
            } else {
                alert(result.message);
            }
        })
        .catch(err => console.error("API 연동 에러:", err));
}