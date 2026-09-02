<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<!-- Litepicker CSS & JS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/litepicker/dist/css/litepicker.css"/>
<script src="https://cdn.jsdelivr.net/npm/litepicker/dist/litepicker.umd.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>업무 이력 조회</title>
    <!-- FontAwesome 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 커스텀 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentHistory.css">
</head>
<body>

    <div class="mobile-container">
        <!-- 상단 헤더 -->
        <header class="mobile-header">
            <button type="button" class="btn-back" onclick="history.back()">
                <i class="fa-solid fa-chevron-left"></i>
            </button>
            <h1 class="header-title">업무 이력 조회</h1>
            <div class="header-dummy"></div>
        </header>

        <!-- 메인 콘텐츠 -->
        <main class="mobile-content">
            <!-- 검색 필터 영역 -->
            <div class="filter-card">
                <div class="filter-row">
				    <label class="filter-label"></label>
				    <div class="date-input-wrapper" style="display: flex; align-items: center; gap: 5px;">
				        <input type="date" id="startDate" class="filter-input" value="2026-05-01" style="flex: 1;">
				        <span>~</span>
				        <input type="date" id="endDate" class="filter-input" value="2026-09-30" style="flex: 1;">
				    </div>
				</div>

                <div class="filter-row">
                    <label class="filter-label">구역 선택</label>
                    <select id="filterArea" class="filter-select">
                        <option value="ALL">전체</option>
                        <option value="A">A구역</option>
                        <option value="B">B구역</option>
                        <option value="C">C구역</option>
                        <option value="D">D구역</option>
                    </select>
                </div>

                <div class="filter-row">
                    <label class="filter-label">업무 유형</label>
                    <select id="filterType" class="filter-select">
                        <option value="ALL">전체</option>
                        <option value="순찰">순찰</option>
                        <option value="점검">점검</option>
                        <option value="지원">지원</option>
                        <option value="기타">기타</option>
                    </select>
                </div>

                <div class="filter-row">
                    <label class="filter-label">검색어</label>
                    <input type="text" id="filterKeyword" class="filter-input" placeholder="업무 내용을 입력하세요.">
                </div>

                <button type="button" id="btnSearch" class="btn-search">검색</button>
            </div>

            <!-- 이력 목록 헤더 -->
            <div class="list-count-header">
                <div class="count-text">
                    총 <span class="count" id="totalCount">${not empty taskList ? taskList.size() : 0}</span>건
                </div>
                <button type="button" class="btn-task-register" onclick="location.href='${pageContext.request.contextPath}/agent/task/register'">
                    <i class="fa-solid fa-plus"></i> 업무 등록
                </button>
            </div>
            
            <!-- 이력 리스트 영역 -->
            <div class="history-list" id="historyList" style="height: 290px; overflow-y: auto;">
                <!-- 자바스크립트 카드가 여기에 생성됨 -->
            </div>
            
            <!-- 로딩 표시 -->
            <div id="loading" style="display:none; text-align:center; padding: 15px; color: #888;">
                <i class="fa-solid fa-spinner fa-spin"></i> 로딩 중...
            </div>

        </main>

        <!-- 하단 탭 바 -->
        <nav class="bottom-nav">
            <a href="${pageContext.request.contextPath}/agent/main" class="nav-item">
                <i class="fa-solid fa-house"></i>
                <span>홈</span>
            </a>
            <a href="${pageContext.request.contextPath}/agent/history" class="nav-item active">
                <i class="fa-solid fa-clipboard-list"></i>
                <span>업무</span>
            </a>
            <a href="${pageContext.request.contextPath}/agent/info" class="nav-item">
                <i class="fa-solid fa-user"></i>
                <span>정보</span>
            </a>
        </nav>
    </div>

</body>

<script>
const contextPath = "${pageContext.request.contextPath}";
let offset = 0;       
const limit = 4;      
let isLoading = false; 
let isEnd = false;    

document.addEventListener("DOMContentLoaded", function() {
    
    // 1. Litepicker 연동 (오류 방지를 위해 닫는 괄호 ); 추가 정돈)
    if (typeof Litepicker !== 'undefined' && document.getElementById('filterDate')) {
        new Litepicker({
            element: document.getElementById('filterDate'),
            singleMode: false,
            numberOfMonths: 1,
            numberOfColumns: 1,
            format: 'YYYY.MM.DD',
            delimiter: ' ~ ',
            autoApply: true
        });
    }

    // 2. 첫 로딩 시 목록 가져오기
    loadMoreTasks();

    // 3. 스크롤 이벤트 등록
    const historyList = document.getElementById("historyList");
    if (historyList) {
        historyList.addEventListener("scroll", handleScroll);
    }
    window.addEventListener("scroll", handleScroll);
    
 	// 클릭 이벤트 (독립적으로 실행)
    if (historyList) {
        historyList.addEventListener("click", function(e) {
            var card = e.target.closest(".history-card");
            if (card) {
                var taskId = card.getAttribute("data-id");
                if (taskId) {
                    var contextPath = "${pageContext.request.contextPath}";
                    location.href = contextPath + "/agent/taskEdit?id=" + taskId;
                }
            }
        });
    }
    // 4. 검색 버튼 클릭 이벤트
    const btnSearch = document.getElementById("btnSearch");
    if (btnSearch) {
        btnSearch.addEventListener("click", function(e) {
            e.preventDefault();
            e.stopPropagation();
            searchTasks();
        });
    }
});

function handleScroll() {
    if (isLoading || isEnd) return;

    const historyList = document.getElementById("historyList");
    let isListBottom = false;
    if (historyList) {
        isListBottom = historyList.scrollTop + historyList.clientHeight >= historyList.scrollHeight - 30;
    }

    const isWindowBottom = window.innerHeight + window.scrollY >= document.documentElement.scrollHeight - 50;

    if (isListBottom || isWindowBottom) {
        loadMoreTasks();
    }
}

// 검색 실행 함수 (상태 강제 초기화 후 데이터 재요청)
function searchTasks() {
    isLoading = false;
    isEnd = false;
    offset = 0;
    
    const container = document.getElementById("historyList");
    if (container) container.innerHTML = "";
    
    loadMoreTasks();
}

function loadMoreTasks() {
    if (isLoading || isEnd) return;
    isLoading = true;

    const loadingEl = document.getElementById("loading");
    if (loadingEl) loadingEl.style.display = "block";

    // 검색 조건 값 가져오기
    const taskArea = document.getElementById("filterArea") ? document.getElementById("filterArea").value : "ALL";
    const taskType = document.getElementById("filterType") ? document.getElementById("filterType").value : "ALL";
    const keyword = document.getElementById("filterKeyword") ? document.getElementById("filterKeyword").value : "";
    
    // 날짜 분리 (YYYY.MM.DD ~ YYYY.MM.DD 형태)
    const dateRange = document.getElementById("filterDate") ? document.getElementById("filterDate").value : "";
    let startDate = "";
    let endDate = "";
    if (dateRange && dateRange.includes("~")) {
        const dates = dateRange.split("~");
        startDate = dates[0].trim();
        endDate = dates[1].trim();
    }

    // URL 생성 (모든 검색 조건 포함)
    const url = contextPath + "/agent/history/more"
              + "?offset=" + offset 
              + "&limit=" + limit
              + "&taskArea=" + encodeURIComponent(taskArea)
              + "&taskType=" + encodeURIComponent(taskType)
              + "&keyword=" + encodeURIComponent(keyword)
              + "&startDate=" + encodeURIComponent(startDate)
              + "&endDate=" + encodeURIComponent(endDate);

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("Network response error");
            return response.json();
        })
        .then(data => {
		    const container = document.getElementById("historyList");
		    const countEl = document.getElementById("totalCount");
		
		    // 💡 DB에서 받아온 검색 조건별 전체 개수로 상단 텍스트 갱신!
		    if (countEl && data.totalCount !== undefined) {
		        countEl.textContent = data.totalCount;
		    }
		
		    const taskList = data.tasks; // 목록 데이터 추출
		
		    if (!taskList || taskList.length === 0) {
		        isEnd = true;
		        if (offset === 0 && container) {
		            container.innerHTML = '<div style="text-align: center; padding: 40px; color: #888;">조회된 업무 이력이 없습니다.</div>';
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

function createCardHtml(task) {
    var rawType = task.taskType || '';
    
    var taskTypeText = rawType;
    var badgeClass = "badge-patrol";

    if (rawType === 'EMERGENCY' || rawType === '긴급') {
        taskTypeText = '긴급';
        badgeClass = "badge-emergency";
    } else if (rawType === 'REPORT' || rawType === '상황') {
        taskTypeText = '상황';
        badgeClass = "badge-report";
    } else if (rawType === 'PATROL' || rawType === '순찰') {
        taskTypeText = '순찰';
        badgeClass = "badge-patrol";
    } else if (rawType === 'INSPECTION' || rawType === '점검') {
        taskTypeText = '점검';
        badgeClass = "badge-check";
    } else if (rawType === 'SUPPORT' || rawType === '지원') {
        taskTypeText = '지원';
        badgeClass = "badge-support";
    } else if (rawType === 'OTHER' || rawType === '기타') {
        taskTypeText = '기타';
        badgeClass = "badge-other";
    }

    var statusText = task.actionStatus || '';
    if (task.actionStatus === 'PENDING') statusText = '조치중';
    else if (task.actionStatus === 'PENDING_CLOSED') statusText = '미조치 종결';
    else if (task.actionStatus === 'COMPLETED') statusText = '조치완료';

    var taskTitle = task.taskTitle || '';
    var taskArea = task.taskArea || '';
    var startTime = task.startTime || '';
    startTime = startTime.replace('T', ' '); // '2026-09-01 17:22' 로 변환

    var taskId = task.taskId || task.id || ''; // task 객체의 ID 필드명 사용
    return '<div class="history-card" data-id="' + taskId + '" style="cursor: pointer;">' +
			    '<div class="card-main">' +
			        '<div class="title-row">' +
			            '<span class="badge ' + badgeClass + '">' + taskTypeText + '</span>' +
			            '<span class="history-title">' + taskTitle + '</span>' +
			        '</div>' +
			        '<div class="info-meta">' +
			            '<span>' + taskArea + '구역</span>' +
			            '<span>' + startTime + '</span>' +
			        '</div>' +
			    '</div>' +
			    '<span class="badge-status">' + statusText + '</span>' +
			'</div>';
}
</script>
</html>