// ==========================================
// 1. 상태 변수 설정
// ==========================================
let currentTab = 'danger'; // danger, instruction, close, report
let currentPage = 1;

// ==========================================
// 2. 이벤트 리스너 및 초기화
// ==========================================
document.addEventListener('DOMContentLoaded', function () {
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

    // 3. 조치인 검색 필드 동적 표시/숨김
    toggleWorkerSearchField(targetTab);

    // ✨ 4개 탭 전체 대시보드 요약 로드 분기
    if (targetTab === 'danger') {
        loadDashboardSummary();
    } else if (targetTab === 'instruction') {
        loadInstructionDashboardSummary();
    }  else if (targetTab === 'report') {
        loadReportDashboardSummary();
    }

    // 4. 데이터 로드
    loadData(currentTab, 1);
};

// 조치인 필드 제어 함수
function toggleWorkerSearchField(tab) {
    const workerItem = document.getElementById('search-worker-item');
    if (!workerItem) return;

    if (tab === 'instruction' || tab === 'close' || tab === 'report') {
        workerItem.style.display = 'flex';
    } else {
        workerItem.style.display = 'none';
        const workerInput = document.getElementById('search-worker');
        if (workerInput) workerInput.value = '';
    }
}

// 검색 폼 전송 이벤트 핸들러
function initSearchForm() {
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        searchForm.addEventListener('submit', function (e) {
            e.preventDefault();
            loadData(currentTab, 1);
        });
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

// 탭별 목록 및 페이징 로드
function loadData(tab, page) {
    currentPage = page;

    const searchType = document.getElementById('search-type') ? document.getElementById('search-type').value : '';
    const keyword = document.getElementById('search-keyword') ? document.getElementById('search-keyword').value : '';

    const queryParams = new URLSearchParams({
        tabType: tab,
        page: page,
        limit: 5,
        searchType: searchType,
        keyword: keyword
    });

    fetch(`/detection/api/list?${queryParams.toString()}`)
        .then(res => res.json())
        .then(data => {
            renderTable(tab, data.list);
            renderPagination(tab, data.totalPages, page);
            
            // ✨ 상단 카드 ID(danger-total-count)와 절대 충돌하지 않게 하단 목록 전용 ID만 지정
            const totalCountEl = document.getElementById(`${tab}-list-total-count`) 
                               || document.getElementById(`${tab === 'close' ? 'closed' : tab}-list-total-count`);

            if (totalCountEl) {
                totalCountEl.textContent = `총 ${data.totalCount || 0}건`;
            }
        })
        .catch(err => console.error(`${tab} 목록 로드 실패:`, err));
}

// ==========================================
// 4. 동적 테이블 렌더링
// ==========================================
function renderTable(tab, list) {
    let tbodyId = 'detection-list-tbody';
    if (tab === 'instruction') tbodyId = 'instruction-list-tbody';
    if (tab === 'close') tbodyId = document.getElementById('closed-list-tbody') ? 'closed-list-tbody' : 'closed-instruction-list-tbody';
    if (tab === 'report') tbodyId = 'report-list-tbody';

    const tbody = document.getElementById(tbodyId);
    if (!tbody) return;

    tbody.innerHTML = '';

    if (!list || list.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" style="text-align:center; padding: 20px;">조회된 이력이 없습니다.</td></tr>';
        return;
    }

    let html = '';
    list.forEach(item => {
        const situNo = item.situNo || '-';
        const situType = item.situType || '-';
        const situDate = formatDate(item.situDate);
        const dngrLevel = item.dngrLevel || '관심';
        const dngrType = item.dngrType || '-';
        const zoneName = item.zoneName || '-';
        const finder = item.finder || item.situType || '-';

        // ✨ 조치인 무조건 '김이슬' 하드코딩
        const worker = '김이슬';

        // 조치상태 ('조치' -> '조치중' 치환)
        let status = (item.situStatus || '감지').trim();
        if (status === '조치') {
            status = '조치중';
        }

        // 조치 현황 탭
        if (tab === 'instruction') {
            html += `
                <tr>
                    <td>${situNo}</td>
                    <td>${finder}</td>
                    <td>${situDate}</td>
                    <td><span class="badge-risk ${dngrLevel}">${dngrLevel}</span></td>
                    <td>${dngrType}</td>
                    <td>${zoneName}</td>
                    <td>${worker}</td>
                    <td><span class="badge-status ${status}">${status}</span></td>
                    <td>
                        <button type="button" class="btn-detail" onclick="openDetail('${situNo}')">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                    </td>
                </tr>
            `;
        } else {
            // 기본 감지 이력 및 기타 탭
            html += `
                <tr>
                    <td>${situNo}</td>
                    <td>${situType}</td>
                    <td>${situDate}</td>
                    <td><span class="badge-risk ${dngrLevel}">${dngrLevel}</span></td>
                    <td>${dngrType}</td>
                    <td>${zoneName}</td>
                    <td><span class="badge-status ${status}">${status}</span></td>
                    <td>
                        <button type="button" class="btn-detail" onclick="openDetail('${situNo}')">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                    </td>
                </tr>
            `;
        }
    });

    tbody.innerHTML = html;
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

function getStatusClass(status) {
    switch (status) {
        case 'APPROVE':
        case '조치완료':
            return 'status-success';
        case 'REJECT':
        case '취소':
            return 'status-danger';
        case '조치':
            return 'status-warning';
        default:
            return 'status-info';
    }
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
    for (let p = 1; p <= totalPages; p++) {
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
document.addEventListener('DOMContentLoaded', function () {
    initTabEvents();
    initSearchForm();
    if (typeof window.initDetectionPage === 'function') {
        window.initDetectionPage();
    }
});