/**
 * 현장 조치 승인 및 관리 (fieldAction.js)
 */
function initFieldActionPage() {
    const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';
    const actionDetailModal = document.getElementById('actionDetailModal');

    // 전역 캐시 및 페이징 상태 변수
    let pendingCache = [];
    let currentPendingPage = 1;

    let historyCache = [];
    let currentHistoryPage = 1;

    const PAGE_SIZE = 8; // 🎯 한 페이지 당 8개 고정

    // 1. 초기 데이터 로드 (페이지 열릴 때 미결 목록 조회)
    loadPendingList();

    // 2. 탭 전환
    window.switchTab = function (tabType) {
        const tabBtns = document.querySelectorAll('.tab-btn');
        tabBtns.forEach(btn => btn.classList.remove('active'));

        const pendingBox = document.getElementById('tab-pending');
        const historyBox = document.getElementById('tab-history');

        if (tabType === 'pending') {
            if (tabBtns[0]) tabBtns[0].classList.add('active');
            if (pendingBox) pendingBox.style.display = 'block';
            if (historyBox) historyBox.style.display = 'none';
            loadPendingList();
        } else if (tabType === 'history') {
            if (tabBtns[1]) tabBtns[1].classList.add('active');
            if (pendingBox) pendingBox.style.display = 'none';
            if (historyBox) historyBox.style.display = 'block';
            loadHistoryList();
        }
    };

    // 3. 미결 조치 목록 AJAX 조회
    function loadPendingList() {
        fetch(basePath + '/admin/fieldAction/api/list?statusType=ALL')
            .then(res => res.json())
            .then(data => {
                pendingCache = data || [];

                renderPendingTable();
            })
            .catch(err => console.error('미결 목록 로드 실패:', err));
    }

    // 3. 미결 조치 목록 렌더링
	function renderPendingTable() {
	    const tbody = document.getElementById('pendingTbody');
	    if (!tbody) return;
	    tbody.innerHTML = '';

	    // 1. WORKER가 'admin'으로 시작하는 항목을 목록에서 필터링
	    const filteredCache = (pendingCache || []).filter(item => {
	        const worker = item.worker ? String(item.worker).trim().toLowerCase() : '';
	        return !worker.startsWith('admin');
	    });

	    // ✨ [수정] admin 제외 후 실제 표시되는 개수로 탭 카운트 뱃지 업데이트
	    const countBadge = document.getElementById('pendingCount');
	    if (countBadge) {
	        countBadge.textContent = filteredCache.length;
	    }

	    // 필터링된 데이터가 없는 경우
	    if (filteredCache.length === 0) {
	        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding: 30px 0; color: #a0aec0;">검토 대상 조치 건이 없습니다.</td></tr>';
	        renderPaginationControls('pendingPagination', tbody, 1, 1, changePendingPage);
	        return;
	    }

	    // 💡 2. admin 제외 후 개수 기준으로 페이징 계산
	    const totalPages = Math.ceil(filteredCache.length / PAGE_SIZE) || 1;
	    if (currentPendingPage > totalPages) currentPendingPage = totalPages;
	    if (currentPendingPage < 1) currentPendingPage = 1;

	    const startIndex = (currentPendingPage - 1) * PAGE_SIZE;
	    const pageList = filteredCache.slice(startIndex, startIndex + PAGE_SIZE);

	    // 💡 3. 행 렌더링
	    pageList.forEach(item => {
	        const worker = item.worker ? String(item.worker).trim().toLowerCase() : '';
	        const finder = item.finder ? String(item.finder).trim().toLowerCase() : '';

	        let statusHtml = '';

	        // WORKER(또는 finder)가 'agent'로 시작하는 경우 -> '검토 대기'
	        if (worker.startsWith('agent') || finder.startsWith('agent')) {
	            statusHtml = `<span class="status-badge status-pending">검토 대기</span>`;
	        } 
	        // WORKER가 null이거나 빈 값인 경우 -> '조치중'
	        else if (!worker || worker === 'null') {
	            statusHtml = `<span class="status-badge" style="background-color: #2563eb; color: #ffffff; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600;">조치중</span>`;
	        } 
	        // 그 외 일반 작업자인 경우 -> '검토 대기'
	        else {
	            statusHtml = `<span class="status-badge status-pending">검토 대기</span>`;
	        }

	        const tr = document.createElement('tr');
	        tr.innerHTML = `
	            <td>${item.situNo || ''}</td>
	            <td>${item.dngrType || ''}</td>
	            <td>${item.situType || ''}</td>
	            <td>${item.finder || '안전요원'}</td>
	            <td>${item.situContent || ''}</td>
	            <td>${formatDate(item.situDate)}</td>
	            <td>${statusHtml}</td>
	            <td>
	                <button type="button" class="btn btn-primary" onclick="openFieldActionDetailModal('${item.situNo}')">상세 검토</button>
	            </td>
	        `;
	        tbody.appendChild(tr);
	    });

	    // 💡 4. 더미 행 추가 (테이블 높이 고정용)
	    for (let i = pageList.length; i < PAGE_SIZE; i++) {
	        const dummyTr = document.createElement('tr');
	        dummyTr.style.visibility = 'hidden';
	        dummyTr.style.pointerEvents = 'none';
	        dummyTr.innerHTML = `
	            <td>&nbsp;</td>
	            <td>&nbsp;</td>
	            <td>&nbsp;</td>
	            <td>&nbsp;</td>
	            <td>${filteredCache[0] ? filteredCache[0].situContent || '&nbsp;' : '&nbsp;'}</td>
	            <td>&nbsp;</td>
	            <td><span class="status-badge status-pending">&nbsp;</span></td>
	            <td><button type="button" class="btn btn-primary">&nbsp;</button></td>
	        `;
	        tbody.appendChild(dummyTr);
	    }

	    renderPaginationControls('pendingPagination', tbody, currentPendingPage, totalPages, changePendingPage);
	}

    function changePendingPage(page) {
        currentPendingPage = page;
        renderPendingTable();
    }

    // 4. 완료 이력 목록 AJAX 조회
    function loadHistoryList() {
        fetch(basePath + '/admin/fieldAction/api/list?statusType=HISTORY')
            .then(res => res.json())
            .then(data => {
                historyCache = data || [];

                renderHistoryTable();
            })
            .catch(err => console.error('이력 목록 로드 실패:', err));
    }

	// 🎯 4-1. 완료 이력 필터링 및 검색 함수
	function getFilteredHistoryList() {
	    const statusVal = document.getElementById('historyStatusFilter') ? document.getElementById('historyStatusFilter').value.trim() : '';
	    const dngrVal = document.getElementById('historyDngrFilter') ? document.getElementById('historyDngrFilter').value.trim() : '';
	    const situVal = document.getElementById('historySituFilter') ? document.getElementById('historySituFilter').value.trim() : '';
	    const keywordVal = document.getElementById('historyKeywordInput') ? document.getElementById('historyKeywordInput').value.trim().toLowerCase() : '';

	    return historyCache.filter(item => {
	        const status = item.situStatus || '';
	        const isApproved = (status === 'APPROVE' || status === '조치' || status === '종료' || status === '조치완료');

	        // 1) 상태 필터 (APPROVED / REJECTED)
	        if (statusVal === 'APPROVED' && !isApproved) return false;
	        if (statusVal === 'REJECTED' && isApproved) return false;

	        // 2) 위험유형 필터 (인파위험, 야생동물, 인명사고, 시설고장/파손, 연계필요, 기타)
	        if (dngrVal !== '' && !(item.dngrType || '').includes(dngrVal)) return false;

	        // 3) 감지유형 필터 (자동감지, 수동감지, 긴급보고)
	        if (situVal !== '' && !(item.situType || '').includes(situVal)) return false;

	        // 4) 키워드 검색 (요청ID, 제출자, 관리자, 조치내용)
	        if (keywordVal !== '') {
	            const idMatch = (item.situNo || '').toString().toLowerCase().includes(keywordVal);
	            const finderMatch = (item.finder || '').toLowerCase().includes(keywordVal);
	            const workerMatch = (item.worker || '').toLowerCase().includes(keywordVal);
	            const contentMatch = (item.situContent || '').toLowerCase().includes(keywordVal);

	            if (!idMatch && !finderMatch && !workerMatch && !contentMatch) {
	                return false;
	            }
	        }

	        return true;
	    });
	}

    // 4-2. 완료 이력 목록 렌더링
    function renderHistoryTable() {
        const tbody = document.getElementById('historyTbody');
        if (!tbody) return;
        tbody.innerHTML = '';

        const filteredList = getFilteredHistoryList();

        if (!filteredList || filteredList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding: 30px 0; color: #a0aec0;">조건에 해당하는 조치 이력이 없습니다.</td></tr>';
            renderPaginationControls('historyPagination', tbody, 1, 1, changeHistoryPage);
            return;
        }

        const totalPages = Math.ceil(filteredList.length / PAGE_SIZE) || 1;
        if (currentHistoryPage > totalPages) currentHistoryPage = totalPages;
        if (currentHistoryPage < 1) currentHistoryPage = 1;

        const startIndex = (currentHistoryPage - 1) * PAGE_SIZE;
        const pageList = filteredList.slice(startIndex, startIndex + PAGE_SIZE);

        pageList.forEach(item => {
            const status = item.situStatus || '';
            const isApproved = (status === 'APPROVE' || status === '조치' || status === '종료');
            const statusClass = isApproved ? 'status-approved' : 'status-rejected';
            const statusText = isApproved ? '조치 승인' : '조치 반려';

            const displayFinder = (!item.finder || item.finder === 'admin') ? '안전요원' : item.finder;

            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${item.situNo || ''}</td>
                <td>${item.dngrType || ''}</td>
                <td>${item.situType || ''}</td>
                <td>${displayFinder}</td>
                <td><span class="status-badge ${statusClass}">${statusText}</span></td>
                <td>${item.endDate || item.situDate || ''}</td>
                <td>${item.worker || '관리자'}</td>
                <td>
                    <button type="button" class="btn btn-secondary" onclick="openFieldActionDetailModal('${item.situNo}')">이력 조회</button>
                </td>
            `;
            tbody.appendChild(tr);
        });

        // 더미 행 추가 (높이 고정 유지)
        for (let i = pageList.length; i < PAGE_SIZE; i++) {
            const dummyTr = document.createElement('tr');
            dummyTr.style.visibility = 'hidden';
            dummyTr.style.pointerEvents = 'none';
            dummyTr.innerHTML = `
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><span class="status-badge status-approved">&nbsp;</span></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><button type="button" class="btn btn-secondary">&nbsp;</button></td>
            `;
            tbody.appendChild(dummyTr);
        }

        renderPaginationControls('historyPagination', tbody, currentHistoryPage, totalPages, changeHistoryPage);
    }
	
	// 🎯 현장 조치 관리 화면에 있을 때만 3초마다 자동 갱신 (폴링)
	setInterval(() => {
	    // 화면에 미결/완료 테이블 요소가 존재하는지 먼저 검사
	    const hasPendingTable = document.getElementById('pendingTbody');
	    const hasHistoryTable = document.getElementById('historyTbody');

	    // 현장 조치 페이지일 때만 API 호출 실행
	    if (hasPendingTable || hasHistoryTable) {
	        loadPendingList();
	        loadHistoryList();
	    }
	}, 3000);

    function changeHistoryPage(page) {
        currentHistoryPage = page;
        renderHistoryTable();
    }

    // 🎯 4-3. 전역 검색 실행 및 필터 초기화 함수 등록
    window.searchHistory = function () {
        currentHistoryPage = 1;
        renderHistoryTable();
    };

    window.resetHistoryFilter = function () {
        const statusFilter = document.getElementById('historyStatusFilter');
        const dngrFilter = document.getElementById('historyDngrFilter');
        const situFilter = document.getElementById('historySituFilter');
        const keywordInput = document.getElementById('historyKeywordInput');

        if (statusFilter) statusFilter.value = '';
        if (dngrFilter) dngrFilter.value = '';
        if (situFilter) situFilter.value = '';
        if (keywordInput) keywordInput.value = '';

        currentHistoryPage = 1;
        renderHistoryTable();
    };

    // 🎯 4-4. 이벤트 리스너 등록 (Select 변경 시 즉시 검색, Enter키 검색)
    const historyStatusFilter = document.getElementById('historyStatusFilter');
    const historyDngrFilter = document.getElementById('historyDngrFilter');
    const historySituFilter = document.getElementById('historySituFilter');
    const historyKeywordInput = document.getElementById('historyKeywordInput');

    if (historyStatusFilter) historyStatusFilter.addEventListener('change', window.searchHistory);
    if (historyDngrFilter) historyDngrFilter.addEventListener('change', window.searchHistory);
    if (historySituFilter) historySituFilter.addEventListener('change', window.searchHistory);
    if (historyKeywordInput) {
        historyKeywordInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                window.searchHistory();
            }
        });
    }

    // 🎯 공통 페이징 버튼 UI 생성 함수
    function renderPaginationControls(containerId, tbodyElem, currentPage, totalPages, onPageChange) {
        let container = document.getElementById(containerId);
        
        if (!container) {
            container = document.createElement('div');
            container.id = containerId;
            container.className = 'table-pagination';
            container.style.cssText = 'display: flex; justify-content: center; align-items: center; gap: 6px; margin-top: 16px; padding-top: 8px;';
            const table = tbodyElem.closest('table');
            if (table && table.parentNode) {
                table.parentNode.insertBefore(container, table.nextSibling);
            }
        }

        container.innerHTML = '';

        if (totalPages <= 1) return;

        // 이전 버튼 (<)
        const prevBtn = document.createElement('button');
        prevBtn.type = 'button';
        prevBtn.textContent = '<';
        prevBtn.disabled = (currentPage === 1);
        prevBtn.style.cssText = `background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); color: ${currentPage > 1 ? '#fff' : '#475569'}; padding: 4px 10px; border-radius: 6px; font-size: 12px; cursor: ${currentPage > 1 ? 'pointer' : 'default'};`;
        prevBtn.onclick = () => onPageChange(currentPage - 1);
        container.appendChild(prevBtn);

        // 페이지 번호 버튼 (1, 2, 3...)
        for (let p = 1; p <= totalPages; p++) {
            const pageBtn = document.createElement('button');
            pageBtn.type = 'button';
            pageBtn.textContent = p;
            const isCurrent = (p === currentPage);
            pageBtn.style.cssText = `background: ${isCurrent ? '#38bdf8' : 'rgba(255, 255, 255, 0.05)'}; border: 1px solid ${isCurrent ? '#38bdf8' : 'rgba(255, 255, 255, 0.1)'}; color: ${isCurrent ? '#fff' : '#a0aec0'}; font-weight: ${isCurrent ? 'bold' : 'normal'}; padding: 4px 10px; border-radius: 6px; font-size: 12px; cursor: pointer;`;
            pageBtn.onclick = () => onPageChange(p);
            container.appendChild(pageBtn);
        }

        // 다음 버튼 (>)
        const nextBtn = document.createElement('button');
        nextBtn.type = 'button';
        nextBtn.textContent = '>';
        nextBtn.disabled = (currentPage === totalPages);
        nextBtn.style.cssText = `background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); color: ${currentPage < totalPages ? '#fff' : '#475569'}; padding: 4px 10px; border-radius: 6px; font-size: 12px; cursor: ${currentPage < totalPages ? 'pointer' : 'default'};`;
        nextBtn.onclick = () => onPageChange(currentPage + 1);
        container.appendChild(nextBtn);
    }

    // 날짜 포맷 함수
    function formatDate(time) {
        if (!time) return '-';
        const date = new Date(Number(time));
        if (isNaN(date.getTime())) return time;
        
        const yyyy = date.getFullYear();
        const mm = String(date.getMonth() + 1).padStart(2, '0');
        const dd = String(date.getDate()).padStart(2, '0');
        const hh = String(date.getHours()).padStart(2, '0');
        const mi = String(date.getMinutes()).padStart(2, '0');
        
        return `${yyyy}-${mm}-${dd} ${hh}:${mi}`;
    }

	// 5. 모달 열기 (SITU_IMAGE 및 WORK_IMAGE 모두 표시)
	window.openFieldActionDetailModal = function (actionId) {
	    console.log("👉 [현장조치 모달 요청 id]:", actionId);
	    
	    if (!actionId) {
	        alert('올바른 요청 ID가 아닙니다.');
	        return;
	    }

	    fetch(basePath + '/admin/fieldAction/api/detail?actionId=' + actionId)
	        .then(res => {
	            if (!res.ok) {
	                throw new Error('서버 응답 오류 (' + res.status + ')');
	            }
	            return res.text();
	        })
	        .then(text => {
	            if (!text || text.trim() === '') {
	                throw new Error('DB에 해당 이력 정보가 존재하지 않습니다.');
	            }
	            const data = JSON.parse(text);

	            // 텍스트 데이터 복원
	            document.getElementById('mActionId').textContent = data.situNo || actionId;
	            
	            // ✨ [수정] 감지유형(situType)이 '긴급보고'인 경우 조치 요원을 '김이슬(agent01)'로 표시
	            if (data.situType === '긴급보고') {
	                document.getElementById('mWorkerInfo').textContent = 'agent01';
	            } else {
	                document.getElementById('mWorkerInfo').textContent = data.worker || '조치중';
	            }
	            
	            document.getElementById('mActionContent').textContent = data.workContent || data.situContent || '내용 없음';
	            
	            const adminCommentEl = document.getElementById('adminComment');
	            if (adminCommentEl) {
	                adminCommentEl.value = data.adminComment || '';
	            }

	            // 1. 현장 감지 사진 (SITU_IMAGE) 바인딩
	            const imgEl = document.getElementById('mActionImage');
	            const noImgTextEl = document.getElementById('noImageText');

	            if (imgEl && noImgTextEl) {
	                if (data.situImage && data.situImage.trim() !== '') {
	                    imgEl.src = basePath + '/upload/' + data.situImage;
	                    imgEl.style.display = 'block';
	                    noImgTextEl.style.display = 'none';
	                } else {
	                    imgEl.src = '';
	                    imgEl.style.display = 'none';
	                    noImgTextEl.style.display = 'inline';
	                }
	            }

	            // 2. 조치 완료 사진 (WORK_IMAGE) 바인딩
	            const workImgEl = document.getElementById('mWorkImage');
	            const noWorkImgTextEl = document.getElementById('noWorkImageText');

	            if (workImgEl && noWorkImgTextEl) {
	                if (data.workImage && data.workImage.trim() !== '') {
	                    workImgEl.src = basePath + '/upload/' + data.workImage;
	                    workImgEl.style.display = 'block';
	                    noWorkImgTextEl.style.display = 'none';
	                } else {
	                    workImgEl.src = '';
	                    workImgEl.style.display = 'none';
	                    noWorkImgTextEl.style.display = 'inline';
	                }
	            }

	            if (actionDetailModal) {
	                actionDetailModal.style.display = 'flex';
	            }
	        })
	        .catch(err => {
	            console.error('상세 정보 로드 실패:', err);
	            alert('상세 정보 로드 실패: ' + err.message);
	        });
	};

	// 6. 모달 닫기
	window.closeModal = function () {
	    if (actionDetailModal) actionDetailModal.style.display = 'none';
	};

	// ✨ [추가] ESC 키 입력 시 모달 닫기
	document.addEventListener('keydown', function (e) {
	    if (e.key === 'Escape' || e.key === 'Esc') {
	        // 모달이 열려있는 상태(display가 'none'이 아닌 경우)에만 닫기 실행
	        if (actionDetailModal && actionDetailModal.style.display === 'flex') {
	            closeModal();
	        }
	    }
	});

    // 7. 모달 배경 클릭 시 닫기
    if (actionDetailModal) {
        actionDetailModal.onclick = function (e) {
            if (e.target === actionDetailModal) window.closeModal();
        };
    }

    // 8. 승인 / 반려 처리 전송
    window.processAction = function (type) {
        const actionId = document.getElementById('mActionId').textContent.trim();
        const adminCommentEl = document.getElementById('adminComment');
        const adminComment = adminCommentEl ? adminCommentEl.value.trim() : '';
        const actionTypeName = (type === 'APPROVE') ? '승인' : '반려';

        if (type === 'REJECT' && !adminComment) {
            alert('반려 시에는 사유를 반드시 입력해주세요.');
            if (adminCommentEl) adminCommentEl.focus();
            return;
        }

        if (!confirm(`[${actionId}] 건을 최종 [${actionTypeName}] 처리하시겠습니까?`)) {
            return;
        }

        const formData = new URLSearchParams();
        formData.append('actionId', actionId);
        formData.append('status', type);
        formData.append('adminComment', adminComment);

        fetch(basePath + '/admin/fieldAction/process', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(res => {
            if (res && res.status === 'success') {
                alert(`성공적으로 ${actionTypeName} 처리되었습니다.`);
                window.closeModal();
                loadPendingList();
            } else {
                alert('처리 실패: ' + (res.message || '오류가 발생했습니다.'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('서버 통신 중 오류가 발생했습니다.');
        });
    };
}

// 🎯 AI 사후 종합 보고서 생성 요청
window.generateAiSituationReport = function () {
	if (!confirm('축제 기간 동안 발생한 전체 이력 데이터를 바탕으로\nAI 사후 종합 보고서를 생성하시겠습니까?')) {
	        return;
	    }
	
    // 💡 [수정] basePath 안전하게 정의
    const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';

    const modal = document.getElementById('aiReportModal');
    const loading = document.getElementById('aiReportLoading');
    const content = document.getElementById('aiReportContent');

    // 1. 모달 열기 및 로딩 상태 표시
    if (modal) modal.style.display = 'flex';
    if (loading) loading.style.display = 'block';
    if (content) {
        content.style.display = 'none';
        content.textContent = '';
    }

    // 2. 컨트롤러 API 비동기 호출
    fetch(basePath + '/admin/fieldAction/api/aiReport')
        .then(res => {
            if (!res.ok) throw new Error('서버 응답 오류 (' + res.status + ')');
            return res.json();
        })
        .then(res => {
            if (loading) loading.style.display = 'none';

            if (res && res.status === 'success') {
                if (content) {
                    content.textContent = res.report;
                    content.style.display = 'block';
                }
            } else {
                alert('보고서 생성 실패: ' + (res.message || '오류가 발생했습니다.'));
                if (modal) modal.style.display = 'none';
            }
        })
        .catch(err => {
            console.error('AI 보고서 요청 에러:', err);
            alert('AI 보고서 생성 처리 중 오류가 발생했습니다.');
            if (loading) loading.style.display = 'none';
            if (modal) modal.style.display = 'none';
        });
};

// 🎯 1. 메일 입력 폼 열기/닫기 토글
window.toggleEmailArea = function() {
    const formArea = document.getElementById('emailFormArea');
    if (formArea) {
        const isHidden = formArea.style.display === 'none' || formArea.style.display === '';
        formArea.style.display = isHidden ? 'flex' : 'none';
    }
};

// 🎯 2. 유관기관 선택 시 이메일 주소 자동 채우기
window.onSelectAgency = function(val) {
    const input = document.getElementById('targetEmailInput');
    if (!input) return;
    if (val === 'direct') {
        input.value = '';
        input.focus();
    } else {
        input.value = val;
    }
};

// 🎯 3. AI 사후 보고서 이메일 전송 요청
window.sendReportEmail = function() {
    const input = document.getElementById('targetEmailInput');
    const contentEl = document.getElementById('aiReportContent');
    const email = input ? input.value.trim() : '';
    const reportText = contentEl ? contentEl.textContent : '';

    if (!email) {
        alert('수신할 이메일 주소를 입력해 주세요.');
        if (input) input.focus();
        return;
    }

    if (!confirm(email + ' 주소로 사후 종합 보고서를 발송하시겠습니까?')) {
        return;
    }

    const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';

    fetch(basePath + '/admin/safetyCheck/sendEmail', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            email: email,
            content: reportText
        })
    })
    .then(response => {
        if (!response.ok) throw new Error('HTTP 에러: ' + response.status);
        return response.text();
    })
    .then(res => {
        alert('이메일이 성공적으로 전송되었습니다.');
        window.toggleEmailArea();
    })
    .catch(err => {
        console.error(err);
        alert('메일 전송 실패: 서버 연결 상태를 확인해 주세요.');
    });
};


// 🎯 AI 보고서 모달 닫기
window.closeAiReportModal = function () {
    const modal = document.getElementById('aiReportModal');
    if (modal) modal.style.display = 'none';
};

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFieldActionPage);
} else {
    initFieldActionPage();
}