// ==========================================
// 1. 이벤트 리스너 (중복 방지 및 위임)
// ==========================================
document.removeEventListener('click', handleTabClick);
document.addEventListener('click', handleTabClick);

function handleTabClick(e) {
    const button = e.target.closest('.tab-btn');
    if (!button) return;

    const targetTab = button.getAttribute('data-tab');
    if (!targetTab) return;

    const tabButtons = document.querySelectorAll('.tab-btn');
    const dashboardPanels = document.querySelectorAll('.dashboard-panel');
    const searchPanels = document.querySelectorAll('.search-panel');
    const listPanels = document.querySelectorAll('.list-panel');

    // 탭 버튼 활성화
    tabButtons.forEach(btn => btn.classList.remove('active'));
    button.classList.add('active');

    // 패널들 전환
    dashboardPanels.forEach(panel => {
        panel.classList.toggle('active', panel.getAttribute('data-tab-panel') === targetTab);
    });

    searchPanels.forEach(panel => {
        panel.classList.toggle('active', panel.getAttribute('data-tab-panel') === targetTab);
    });

    listPanels.forEach(panel => {
        panel.classList.toggle('active', panel.getAttribute('data-tab-panel') === targetTab);
    });
}


// ==========================================
// 2. 더미 데이터 및 렌더링 로직
// ==========================================
const sampleDetectionData = [
    {
        id: 1,
        author: 'AI',              // AI가 작성 -> '자동'
        detectedAt: '2026-08-30 14:22:10',
        riskLevel: '심각',
        riskType: '인구 밀집',
        zoneName: '광장',
        status: '미확인'
    },
    {
        id: 2,
        author: '관제사',           // 관제사가 작성 -> '수동'
        detectedAt: '2026-08-30 14:18:05',
        riskLevel: '경계',
        riskType: '야생 동물 출현',
        zoneName: '광장',
        status: '조치중'
    }
];

function renderDetectionList(dataList) {
    const tbody = document.getElementById('detection-list-tbody');
    const totalCountEl = document.getElementById('total-count');
    
    if (!tbody) return;

    if (totalCountEl) {
        totalCountEl.textContent = `총 ${dataList.length}건`;
    }

    if (!dataList || dataList.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding: 20px;">조회된 감지 이력이 없습니다.</td></tr>';
        return;
    }

    let html = '';
    dataList.forEach(item => {
        const regType = (item.author === 'AI') ? '자동' : '수동';
        const status = item.status || '미확인';

        html += `
            <tr>
                <td>${item.id}</td>
                <td>${regType}</td>
                <td>${item.detectedAt}</td>
                <td><span class="badge-risk ${item.riskLevel}">${item.riskLevel}</span></td>
                <td>${item.riskType}</td>
                <td>${item.zoneName}</td>
                <td><span class="badge-status ${status}">${status}</span></td>
                <td>
                    <button type="button" class="btn-detail" style="background:none; border:none; color:#94a3b8; cursor:pointer;" onclick="openDetail(${item.id})">
                        🔍
                    </button>
                </td>
            </tr>
        `;
    });

    tbody.innerHTML = html;
}

function openDetail(id) {
    console.log("상세 보기 클릭 ID:", id);
}

// ==========================================
// 1. 지시 현황 더미 데이터 (2건)
// ==========================================
const sampleInstructionData = [
    {
        id: 101,
        status: '처리대기',
        type: '안전 점검',
        zoneName: '광장',
        title: '광장 인구 밀집 지역 현장 확인 지시',
        author: '관제사A',
        createdAt: '2026-08-30 14:30:00'
    },
    {
        id: 102,
        status: '처리중',
        type: '장비 점검',
        zoneName: '관제실', // 구역명이 '관제실' -> 관리자가 관제사에게 하달한 지시
        title: 'CCTV 3번 모듈 상태 점검 건',
        author: '관리자',
        createdAt: '2026-08-30 13:10:15'
    }
];

// ==========================================
// 2. 지시 현황 목록 렌더링 함수
// ==========================================
function renderInstructionList(dataList) {
    const tbody = document.getElementById('instruction-list-tbody');
    const totalCountEl = document.getElementById('instruction-total-count');

    if (!tbody) return;

    if (totalCountEl) {
        totalCountEl.textContent = `총 ${dataList.length}건`;
    }

    if (!dataList || dataList.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding: 20px;">조회된 지시 현황이 없습니다.</td></tr>';
        return;
    }

    let html = '';
    dataList.forEach(item => {
        // 구역명이 '관제실'이면 관리자 하달 지시
        const isControlRoom = (item.zoneName === '관제실');
        const zoneBadgeClass = isControlRoom ? 'badge-control-room' : '';

        html += `
            <tr>
                <td>${item.id}</td>
                <td><span class="badge-status ${item.status}">${item.status}</span></td>
                <td>${item.type}</td>
                <td><span class="${zoneBadgeClass}">${item.zoneName}</span></td>
                <td style="text-align: left; padding-left: 12px;">${item.title}</td>
                <td>${item.author}</td>
                <td>${item.createdAt}</td>
                <td>
                    <button type="button" class="btn-detail" style="background:none; border:none; color:#94a3b8; cursor:pointer;" onclick="openInstructionDetail(${item.id})">
                        🔍
                    </button>
                </td>
            </tr>
        `;
    });

    tbody.innerHTML = html;
}

// 지시 현황 상세 보기 이벤트 (임시 함수)
function openInstructionDetail(id) {
    console.log("지시 현황 상세 보기 클릭 ID:", id);
}

// ==========================================
// 3. 기존 initDetectionPage 함수에 렌더링 추가
// ==========================================
// 기존 initDetectionPage 함수 내부나 호출 시점에 함께 실행되도록 추가합니다.
const originalInit = typeof initDetectionPage === 'function' ? initDetectionPage : null;

initDetectionPage = function() {
    if (originalInit) originalInit();
    renderInstructionList(sampleInstructionData);
};



// ==========================================
// 1. 종료 이력 더미 데이터
// ==========================================
const sampleClosedInstructionData = [
    {
        id: 201,
        status: '처리완료',
        type: '시설 보수',
        zoneName: '주차장',
        title: '주차장 차단기 동작 오류 점검 완료',
        author: '관제사B',
        createdAt: '2026-08-29 11:00:00'
    },
    {
        id: 202,
        status: '취소',
        type: '안전 점검',
        zoneName: '관제실',
        title: '야간 관제 모니터링 강화 지시',
        author: '관리자',
        createdAt: '2026-08-28 18:20:00'
    }
];

// ==========================================
// 2. 종료 이력 렌더링 함수
// ==========================================
function renderClosedInstructionList(dataList) {
    // JSP에 작성된 ID가 closed-list-tbody 또는 closed-instruction-list-tbody 일 수 있어 둘 다 대응
    const tbody = document.getElementById('closed-list-tbody') || document.getElementById('closed-instruction-list-tbody');
    const totalCountEl = document.getElementById('closed-total-count');

    if (!tbody) {
        console.error("종료 이력 tbody 요소를 찾을 수 없습니다.");
        return;
    }

    if (totalCountEl) {
        totalCountEl.textContent = `총 ${dataList.length}건`;
    }

    if (!dataList || dataList.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding: 20px;">조회된 종료 이력이 없습니다.</td></tr>';
        return;
    }

    let html = '';
    dataList.forEach(item => {
        const isControlRoom = (item.zoneName === '관제실');
        const zoneBadgeClass = isControlRoom ? 'badge-control-room' : '';

        html += `
            <tr>
                <td>${item.id}</td>
                <td><span class="badge-status ${item.status}">${item.status}</span></td>
                <td>${item.type}</td>
                <td><span class="${zoneBadgeClass}">${item.zoneName}</span></td>
                <td style="text-align: left; padding-left: 12px;">${item.title}</td>
                <td>${item.author}</td>
                <td>${item.createdAt}</td>
                <td>
                    <button type="button" class="btn-detail" style="background:none; border:none; color:#94a3b8; cursor:pointer;" onclick="openClosedDetail(${item.id})">
                        🔍
                    </button>
                </td>
            </tr>
        `;
    });

    tbody.innerHTML = html;
}

function openClosedDetail(id) {
    console.log("종료 이력 상세 보기 ID:", id);
}


// ==========================================
// 1. 보고 현황 더미 데이터 (2건)
// ==========================================
const sampleReportData = [
    {
        id: 301,
        status: '미확인',
        riskType: '화재 위험',
        zoneName: 'A구역 창고',
        title: 'A구역 창고 인근 연기 발생 보고',
        author: '안전요원A',
        createdAt: '2026-08-31 10:15:00'
    },
    {
        id: 302,
        status: '확인',
        riskType: '시설 파손',
        zoneName: 'B1 주차장',
        title: '비상벨 작동 및 소방함 파손 확인 요청',
        author: '관제사A',
        createdAt: '2026-08-31 09:30:00'
    }
];

// ==========================================
// 2. 보고 현황 목록 렌더링 함수
// ==========================================
function renderReportList(dataList) {
    const tbody = document.getElementById('report-list-tbody');
    const totalCountEl = document.getElementById('report-total-count');

    if (!tbody) return;

    if (totalCountEl) {
        totalCountEl.textContent = `총 ${dataList.length}건`;
    }

    if (!dataList || dataList.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding: 20px;">조회된 보고 현황이 없습니다.</td></tr>';
        return;
    }

    let html = '';
    dataList.forEach(item => {
        html += `
            <tr>
                <td>${item.id}</td>
                <td><span class="badge-status ${item.status}">${item.status}</span></td>
                <td>${item.riskType}</td>
                <td>${item.zoneName}</td>
                <td style="text-align: left; padding-left: 12px;">${item.title}</td>
                <td>${item.author}</td>
                <td>${item.createdAt}</td>
                <td>
                    <button type="button" class="btn-detail" style="background:none; border:none; color:#94a3b8; cursor:pointer;" onclick="openReportDetail(${item.id})">
                        🔍
                    </button>
                </td>
            </tr>
        `;
    });

    tbody.innerHTML = html;
}

function openReportDetail(id) {
    console.log("보고 현황 상세 보기 ID:", id);
}



// ==========================================
// 3. 페이지 통합 초기화 함수
// ==========================================
function initDetectionPage() {
    if (typeof renderDetectionList === 'function' && typeof sampleDetectionData !== 'undefined') {
        renderDetectionList(sampleDetectionData);
    }
    if (typeof renderInstructionList === 'function' && typeof sampleInstructionData !== 'undefined') {
        renderInstructionList(sampleInstructionData);
    }
	if (typeof renderClosedInstructionList === 'function' && typeof sampleClosedInstructionData !== 'undefined') {
	        renderClosedInstructionList(sampleClosedInstructionData);
	}
	if (typeof renderReportList === 'function' && typeof sampleReportData !== 'undefined') {
	        renderReportList(sampleReportData);
	}
}

// 자동 실행
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initDetectionPage);
} else {
    initDetectionPage();
}
