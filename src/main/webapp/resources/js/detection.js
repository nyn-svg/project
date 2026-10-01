// ==========================================
// 1. 상태 변수 설정
// ==========================================
let currentTab = 'danger'; // danger, instruction, close, report
let currentPage = 1;

// ==========================================
// 2. 이벤트 리스너 및 초기화
// ==========================================
document.addEventListener('DOMContentLoaded', function() {
    initTabEvents();
    initSearchForm();
    loadDashboardSummary();
    loadData(currentTab, 1);
});

// 전역 탭 전환 함수 (onclick에서 직접 호출)
window.switchTab = function(targetTab, btnElement) {
    if (!targetTab) return;

    currentTab = targetTab;
    currentPage = 1;

    // 탭 이동 시 기존 검색 조건 전체 초기화
    resetSearchForm(false);

    // 1. 탭 버튼 활성화 상태 변경
    document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
    if (btnElement) {
        btnElement.classList.add('active');
    } else {
        const activeBtn = document.querySelector(`.tab-btn[data-tab="${targetTab}"]`);
        if (activeBtn) activeBtn.classList.add('active');
    }

    // 2. 대시보드, 검색폼, 리스트 패널 전환
    document.querySelectorAll('.dashboard-panel').forEach(panel => {
        panel.classList.toggle('active', panel.getAttribute('data-tab-panel') === targetTab);
    });
    document.querySelectorAll('.search-panel').forEach(panel => {
        panel.classList.toggle('active', panel.getAttribute('data-tab-panel') === targetTab);
    });
    document.querySelectorAll('.list-panel').forEach(panel => {
        panel.classList.toggle('active', panel.getAttribute('data-tab-panel') === targetTab);
    });

    // 3. 조치인/조치상태 검색 필드 동적 표시/숨김
    toggleWorkerSearchField(targetTab);

    // ✨ 4개 탭 전체 대시보드 요약 로드 분기
    if (targetTab === 'danger') {
        loadDashboardSummary();
    } else if (targetTab === 'instruction') {
        loadInstructionDashboardSummary();
    } else if (targetTab === 'report') {
        loadReportDashboardSummary();
    }

    // 4. 데이터 로드
    loadData(currentTab, 1);
};

// 탭별 검색 필드(조치인, 조치상태) 제어 함수
function toggleWorkerSearchField(tab) {
    const finderItem = document.getElementById('search-finder-item');
    const workerItem = document.getElementById('search-worker-item');
    const statusItem = document.getElementById('search-status-item');

    function toggleItemWithEmpty(item, show, emptyId) {
        if (!item) return;
        let emptyItem = document.getElementById(emptyId);

        if (show) {
            item.style.display = 'flex';
            if (emptyItem) emptyItem.style.display = 'none';
        } else {
            item.style.display = 'none';
            // 입력값 초기화
            const input = item.querySelector('input, select');
            if (input) input.value = '';

            // 빈 박스 없으면 생성, 있으면 표시
            if (!emptyItem) {
                emptyItem = document.createElement('div');
                emptyItem.id = emptyId;
                emptyItem.className = 'search-item empty-item';
                item.parentNode.insertBefore(emptyItem, item);
            } else {
                emptyItem.style.display = 'block';
            }
        }
    }

    // 1. 드론/발견인 제어 (종료 이력(close) 탭일 때 숨김)
    toggleItemWithEmpty(finderItem, tab !== 'close', 'search-finder-empty-item');

    // 2. 조치인 제어 (조치 현황(instruction) 탭에서만 보이기)
    //    종료 이력(close) 및 긴급상황(report) 탭일 때 숨김
    toggleItemWithEmpty(workerItem, tab === 'instruction', 'search-worker-empty-item');

    // 3. 조치상태 제어 (감지 이력(danger) 탭일 때 숨김)
    toggleItemWithEmpty(statusItem, tab !== 'danger', 'search-status-empty-item');
}

// 검색 폼 이벤트 및 버튼 클릭 처리 함수
function initSearchForm() {
    const searchForm = document.getElementById('search-form');

    // 1. 검색 버튼(#btn-search) 클릭 이벤트 연결
    const btnSearch = document.getElementById('btn-search');
    if (btnSearch) {

        btnSearch.addEventListener('click', function(e) {
            e.preventDefault();
            loadData(currentTab, 1);
        });
    } else {
        console.error("btn-search ID를 가진 버튼을 찾을 수 없습니다.");
    }

    // 2. Input 입력창에서 엔터(Enter)키 눌렀을 때 검색 실행
    if (searchForm) {
        searchForm.querySelectorAll('input, select').forEach(element => {
            element.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    loadData(currentTab, 1);
                }
            });
        });
    }
}

// 검색 조건 초기화 함수
function resetSearchForm(shouldReload = true) {
    const searchForm = document.getElementById('search-form') || document.getElementById('searchForm');
    if (searchForm) {
        searchForm.reset(); // 입력 값 초기화
    }

    // 초기화 후 바로 데이터 재조회가 필요한 경우 (초기화 버튼 클릭 시)
    if (shouldReload) {
        loadData(currentTab, 1);
    }
}

// ==========================================
// 3. 백엔드 API 연동 데이터 로딩
// ==========================================

// 상단 감지 이력 대시보드 요약 카운트 로드
function loadDashboardSummary() {
    const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';

    fetch(basePath + '/detection/api/dashboard-summary')
        .then(res => res.json())
        .then(data => {
            const totalEl = document.getElementById('danger-total-count');
            const autoEl = document.getElementById('danger-auto-count');
            const manualEl = document.getElementById('danger-manual-count');
            const emerEl = document.getElementById('danger-emer-count');

            if (totalEl) totalEl.textContent = data.totalCount || 0;
            if (autoEl) autoEl.textContent = data.autoCount || 0;
            if (manualEl) manualEl.textContent = data.manualCount || 0;
            if (emerEl) emerEl.textContent = data.emerCount || 0;
        })
        .catch(err => console.error("대시보드 요약 로드 실패:", err));
}

// 상단 조치 현황 대시보드 요약 로드
function loadInstructionDashboardSummary() {
    const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';

    fetch(basePath + '/detection/api/instruction-dashboard-summary')
        .then(res => res.json())
        .then(data => {
            const totalEl = document.getElementById('instruction-dash-total');
            const progressEl = document.getElementById('instruction-dash-progress');
            const completeEl = document.getElementById('instruction-dash-complete');
            const unresolvedEl = document.getElementById('instruction-dash-unresolved');

            if (totalEl) totalEl.textContent = data.totalCount || 0;
            if (progressEl) progressEl.textContent = data.progressCount || 0;
            if (completeEl) completeEl.textContent = data.completeCount || 0;
            if (unresolvedEl) unresolvedEl.textContent = data.unresolvedCount || 0;
        })
        .catch(err => console.error("조치현황 대시보드 로드 실패:", err));
}

// 상단 긴급상황 대시보드 요약 로드
function loadReportDashboardSummary() {
    const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';

    fetch(basePath + '/detection/api/report-dashboard-summary')
        .then(res => res.json())
        .then(data => {
            const totalEl = document.getElementById('report-dash-total');
            const pendingEl = document.getElementById('report-dash-pending');
            const progressEl = document.getElementById('report-dash-progress');
            const completeEl = document.getElementById('report-dash-complete');

            if (totalEl) totalEl.textContent = data.totalCount || 0;
            if (pendingEl) pendingEl.textContent = data.pendingCount || 0;
            if (progressEl) progressEl.textContent = data.progressCount || 0;
            if (completeEl) completeEl.textContent = data.completeCount || 0;
        })
        .catch(err => console.error("긴급상황 대시보드 로드 실패:", err));
}

function updateDashboardCount(tab, count) {
    const el = document.querySelector(`.dashboard-panel[data-tab-panel="${tab}"] .count-val`)
        || document.querySelector(`[data-tab-panel="${tab}"] .total-count-badge`);
    if (el) el.textContent = count || 0;
}

function loadData(tab, page) {
    currentPage = page;

    // 1. 폼 파라미터 생성 (id="searchForm" 및 id="search-form" 모두 대응)
    const searchForm = document.getElementById('searchForm') || document.getElementById('search-form');
    
    // searchForm이 존재하는 경우에만 FormData를 생성하여 안전하게 파라미터 추출
    const queryParams = (searchForm && searchForm.tagName === 'FORM') 
        ? new URLSearchParams(new FormData(searchForm)) 
        : new URLSearchParams();

    // 2. 필수 기본 파라미터 설정
    queryParams.set('tabType', tab);
    queryParams.set('page', page);
    queryParams.set('limit', 5);

    fetch(`/detection/api/list?${queryParams.toString()}`)
        .then(res => res.json())
        .then(data => {
            renderTable(tab, data.list);
            renderPagination(tab, data.totalPages, page);

            // 3. JSP 상의 ID와 1:1로 정확하게 매핑
            let targetId = `${tab}-total-count`;
            if (tab === 'danger') {
                targetId = 'danger-list-total-count'; // JSP의 danger-list-total-count 매핑
            } else if (tab === 'close') {
                targetId = 'closed-total-count';      // JSP의 closed-total-count 매핑
            }

            // 하단 목록 헤더의 총 건수 뱃지 업데이트
            const totalCountEl = document.getElementById(targetId);
            if (totalCountEl) {
                totalCountEl.textContent = `총 ${data.totalCount || 0}건`;
            }
        })
        .catch(err => console.error(`${tab} 목록 로드 실패:`, err));
}

// ==========================================
// 4. 동적 테이블 렌더링
// ==========================================

/**
 * 1. 감지 이력 (총 8개 컬럼)
 */
function renderDangerList(list) {
    const tbody = document.getElementById('detection-list-tbody');
    if (!list || list.length === 0) {
        tbody.innerHTML = `<tr><td colspan="8">조회된 이력이 없습니다.</td></tr>`;
        return;
    }

    let html = '';
    list.forEach(item => {
        // 백엔드 API에서 넘어오는 키(Key) 값에 맞춰 변경해 주세요.
        html += `
            <tr>
                <td>${item.situNo || '-'}</td>
                <td>${item.situType || '-'}</td>
                <td>${formatDate(item.situDate) || '-'}</td>
                <td><span class="badge-risk ${item.dngrLevel}">${item.dngrLevel || '-'}</span></td>
                <td>${item.dngrType || '-'}</td>
                <td>${item.zoneName || '-'}</td>
                <td>${item.finder || item.droneId}</td>
                <td>${formatStatusBadge(item.situStatus)}</td>
                <td>
                    <button type="button" class="btn-detail" onclick="openDetail('${item.situNo}')">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </td>
            </tr>
        `;
    });
    tbody.innerHTML = html;
}

/**
 * 2. 조치 현황 (총 11개 컬럼)
 * 컬럼: NO | 발견인 | 발생 일시 | 위험 단계 | 위험 유형 | 구역명 | 조치인 | 조치 상태 | 조치 시작 일시 | 조치 종료 일시 | 상세
 */
function renderInstructionList(list) {
    const tbody = document.getElementById('instruction-list-tbody');
    if (!list || list.length === 0) {
        tbody.innerHTML = `<tr><td colspan="11">조회된 이력이 없습니다.</td></tr>`;
        return;
    }

    let html = '';
    list.forEach(item => {
        html += `
            <tr>
                <td>${item.situNo || '-'}</td>
                <td>${item.finder || item.droneId}</td>
                <td>${formatDate(item.situDate) || '-'}</td>
                <td><span class="badge-risk ${item.dngrLevel}">${item.dngrLevel || '-'}</span></td>
                <td>${item.dngrType || '-'}</td>
                <td>${item.zoneName || '-'}</td>
                <td>${item.worker || '-'}</td>
                <td>${formatStatusBadge(item.situStatus)}</td>
                <td>${formatDate(item.startDate) || '-'}</td>
                <td>${formatDate(item.endDate) || '-'}</td>
                <td>
                    <button type="button" class="btn-detail" onclick="openDetail('${item.situNo}')">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </td>
            </tr>
        `;
    });
    tbody.innerHTML = html;
}

/**
 * 3. 종료 이력 (총 11개 컬럼)
 * 컬럼: NO | 감지 유형 | 감지 일시 | 종료 일시 | 위험 단계 | 위험 유형 | 구역명 | 발견인 | 조치인 | 조치 상태 | 상세
 */
function renderClosedList(list) {
    const tbody = document.getElementById('closed-list-tbody');
    if (!list || list.length === 0) {
        tbody.innerHTML = `<tr><td colspan="11">조회된 이력이 없습니다.</td></tr>`;
        return;
    }

    let html = '';
    list.forEach(item => {
        html += `
            <tr>
                <td>${item.situNo || '-'}</td>
                <td>${item.situType || '-'}</td>
                <td><span class="badge-risk ${item.dngrLevel}">${item.dngrLevel || '-'}</span></td>
                <td>${item.dngrType || '-'}</td>
                <td>${item.zoneName || '-'}</td>
                <td>${formatDate(item.situDate) || '-'}</td>
				<td>${formatDate(item.startDate) || '-'}</td>
				<td>${formatDate(item.endDate) || '-'}</td>
                <td>${formatStatusBadge(item.situStatus)}</td>
                <td>
                    <button type="button" class="btn-detail" onclick="openDetail('${item.situNo}')">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </td>
            </tr>
        `;
    });
    tbody.innerHTML = html;
}

/**
 * 4. 긴급상황 조치 이력 (총 8개 컬럼)
 * 컬럼: NO | 감지 유형 | 감지 일시 | 위험 단계 | 위험 유형 | 구역명 | 조치 상태 | 상세
 */
function renderReportList(list) {
    const tbody = document.getElementById('report-list-tbody');
    if (!list || list.length === 0) {
        tbody.innerHTML = `<tr><td colspan="8">조회된 이력이 없습니다.</td></tr>`;
        return;
    }

    let html = '';
    list.forEach(item => {
        html += `
            <tr>
                <td>${item.situNo || '-'}</td>
                <td>${item.situType || '-'}</td>
                <td>${formatDate(item.situDate) || '-'}</td>
                <td><span class="badge-risk ${item.dngrLevel}">${item.dngrLevel || '-'}</span></td>
                <td>${item.dngrType || '-'}</td>
                <td>${item.zoneName || '-'}</td>
				<td>${item.finder || item.droneId}</td>
                <td>${formatStatusBadge(item.situStatus)}</td>
                <td>
                    <button type="button" class="btn-detail" onclick="openDetail('${item.situNo}')">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </td>
            </tr>
        `;
    });
    tbody.innerHTML = html;
}

function renderTable(tab, list) {
    switch (tab) {
        case 'danger':
            renderDangerList(list);
            break;
        case 'instruction':
            renderInstructionList(list);
            break;
        case 'close':
            renderClosedList(list);
            break;
        case 'report':
            renderReportList(list);
            break;
    }
}

// 위험 등급 클래스 매핑 함수 추가
function getDangerLevelClass(level) {
    switch (level) {
        case '심각': return 'danger-severe';
        case '경계': return 'danger-caution';
        case '주의': return 'danger-attention';
        default: return 'danger-interest';
    }
}

// ==========================================
// 5. 유틸리티 함수 (날짜, 뱃지, 상세보기)
// ==========================================
function formatDate(dateStr) {
    if (!dateStr) return '-';
    const d = new Date(dateStr);
    if (isNaN(d.getTime())) return dateStr;

    const pad = n => String(n).padStart(2, '0');
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
}

function formatStatusBadge(status) {
    if (!status) return '-';

    let displayStatus = status;

    // APPROVE / REJECT 인 경우 텍스트 변환
    if (status === 'APPROVE') {
        displayStatus = '승인';
    } else if (status === 'REJECT') {
        displayStatus = '반려';
    }

    // CSS 클래스로는 원본 status(APPROVE/REJECT)를 포함하여 스타일이 정확히 매칭되도록 처리
    return `<span class="badge-status ${status}">${displayStatus}</span>`;
}

function openDetail(situNo) {
    if (!situNo || situNo === '-') return;

    const width = 630;
    const height = 830;

    // 1. 메인 컨테이너 영역 위치 및 크기 구하기
    const mainArea = document.getElementById('main-container') || document.querySelector('.app-left-area');

    let left, top;

    if (mainArea) {
        const rect = mainArea.getBoundingClientRect();

        // 브라우저 화면(screen) 기준 메인 영역 중앙 좌표 계산
        left = window.screenX + rect.left + (rect.width - width) / 2;
        top = window.screenY + rect.top + (rect.height - height) / 2;
    } else {
        // 메인 영역을 찾지 못할 경우 기본 브라우저 중앙 처리
        left = window.screenX + (window.innerWidth - width) / 2;
        top = window.screenY + (window.innerHeight - height) / 2;
    }

    // 화면 밖으로 벗어나지 않도록 방어 코드 적용
    left = Math.max(0, left);
    top = Math.max(0, top);

    const url = (window.contextPath || '') + '/detection/detail?no=' + situNo;
    const options = `width=${width},height=${height},left=${left},top=${top},scrollbars=yes,resizable=yes`;

    // 팝업 창 열기
    window.open(url, 'Detail_' + situNo, options);
}

// ==========================================
// 6. 하단 동적 페이징 바 생성
// ==========================================
function renderPagination(tab, totalPages, currentPage) {
    const paginationEl = document.getElementById(`${tab}-pagination`) || document.getElementById('pagination');
    if (!paginationEl) return;

    if (totalPages <= 1) {
        paginationEl.innerHTML = '';
        return;
    }

    let html = '<div class="table-pagination">';

    // 1. 이전 버튼 (<)
    const isPrevDisabled = (currentPage === 1);
    if (!isPrevDisabled) {
        html += `<button type="button" class="page-btn nav-btn" onclick="loadData('${tab}', ${currentPage - 1})">&lt;</button>`;
    } else {
        html += `<button type="button" class="page-btn nav-btn" disabled>&lt;</button>`;
    }

    // 2. 페이지 번호 버튼 (1, 2, 3...)
    for (let p = 1;p <= totalPages;p++) {
        const activeClass = (p === currentPage) ? 'active' : '';
        html += `<button type="button" class="page-btn ${activeClass}" onclick="loadData('${tab}', ${p})">${p}</button>`;
    }

    // 3. 다음 버튼 (>)
    const isNextDisabled = (currentPage === totalPages);
    if (!isNextDisabled) {
        html += `<button type="button" class="page-btn nav-btn" onclick="loadData('${tab}', ${currentPage + 1})">&gt;</button>`;
    } else {
        html += `<button type="button" class="page-btn nav-btn" disabled>&gt;</button>`;
    }

    html += '</div>';
    paginationEl.innerHTML = html;
}

// ==========================================
// 7. 전역 초기화 함수
// ==========================================
// SPA 페이지 비동기 진입 시 실행될 초기화 전역 함수
window.initDetectionPage = function() {
    currentTab = 'danger';
    currentPage = 1;
    toggleWorkerSearchField(currentTab);
    loadDashboardSummary();
    loadInstructionDashboardSummary();
    loadReportDashboardSummary();
    loadData(currentTab, 1);
};

// 기존 DOMContentLoaded 유지 (F5 새로고침용)
document.addEventListener('DOMContentLoaded', function() {
    initTabEvents();
    initSearchForm();
    if (typeof window.initDetectionPage === 'function') {
        window.initDetectionPage();
    }
});