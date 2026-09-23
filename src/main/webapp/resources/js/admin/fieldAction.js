/**
 * 현장 조치 승인 및 관리 (fieldAction.js)
 */
function initFieldActionPage() {
    const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';
    const actionDetailModal = document.getElementById('actionDetailModal');

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

	// 전역 캐시 및 페이징 상태 변수
	let pendingCache = [];
	let currentPendingPage = 1;

	let historyCache = [];
	let currentHistoryPage = 1;

	const PAGE_SIZE = 8; // 🎯 한 페이지 당 8개 고정

	// 3. 미결 조치 목록 AJAX 조회
	function loadPendingList() {
	    fetch(basePath + '/admin/fieldAction/api/list?statusType=PENDING')
	        .then(res => res.json())
	        .then(data => {
	            pendingCache = data || [];
	            currentPendingPage = 1; // 로드 시 1페이지로 초기화

	            const countBadge = document.getElementById('pendingCount');
	            if (countBadge) countBadge.textContent = pendingCache.length;

	            renderPendingTable();
	        })
	        .catch(err => console.error('미결 목록 로드 실패:', err));
	}

	// 3. 미결 조치 목록 렌더링
	function renderPendingTable() {
	    const tbody = document.getElementById('pendingTbody');
	    if (!tbody) return;
	    tbody.innerHTML = '';

	    if (!pendingCache || pendingCache.length === 0) {
	        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding: 30px 0; color: #a0aec0;">검토 대기 중인 조치 건이 없습니다.</td></tr>';
	        renderPaginationControls('pendingPagination', tbody, 1, 1, changePendingPage);
	        return;
	    }

	    const totalPages = Math.ceil(pendingCache.length / PAGE_SIZE) || 1;
	    if (currentPendingPage > totalPages) currentPendingPage = totalPages;
	    if (currentPendingPage < 1) currentPendingPage = 1;

	    const startIndex = (currentPendingPage - 1) * PAGE_SIZE;
	    const pageList = pendingCache.slice(startIndex, startIndex + PAGE_SIZE);

	    pageList.forEach(item => {
	        const tr = document.createElement('tr');
	        tr.innerHTML = `
	            <td>${item.situNo || ''}</td>
	            <td>${item.dngrType || ''}</td>
	            <td>${item.situType || ''}</td>
	            <td>${item.finder || '안전요원'}</td>
	            <td>${item.situContent || ''}</td>
	            <td>${formatDate(item.situDate)}</td>
	            <td><span class="status-badge status-pending">검토 대기</span></td>
	            <td>
	                <button type="button" class="btn btn-primary" onclick="openFieldActionDetailModal('${item.situNo}')">상세 검토</button>
	            </td>
	        `;
	        tbody.appendChild(tr);
	    });

	    // 🎯 [핵심 수정] 더미 행에도 동일한 버튼/뱃지 구조를 넣어 높이를 100% 일치시킵니다.
	    for (let i = pageList.length; i < PAGE_SIZE; i++) {
	        const dummyTr = document.createElement('tr');
	        dummyTr.style.visibility = 'hidden';
	        dummyTr.style.pointerEvents = 'none';
	        dummyTr.innerHTML = `
	            <td>&nbsp;</td>
	            <td>&nbsp;</td>
	            <td>&nbsp;</td>
	            <td>&nbsp;</td>
	            <td>${pendingCache[0] ? pendingCache[0].situContent || '&nbsp;' : '&nbsp;'}</td>
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
	            currentHistoryPage = 1; // 로드 시 1페이지로 초기화

	            renderHistoryTable();
	        })
	        .catch(err => console.error('이력 목록 로드 실패:', err));
	}

	// 4. 완료 이력 목록 렌더링
	function renderHistoryTable() {
	    const tbody = document.getElementById('historyTbody');
	    if (!tbody) return;
	    tbody.innerHTML = '';

	    if (!historyCache || historyCache.length === 0) {
	        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding: 30px 0; color: #a0aec0;">완료된 조치 이력이 없습니다.</td></tr>';
	        renderPaginationControls('historyPagination', tbody, 1, 1, changeHistoryPage);
	        return;
	    }

	    const totalPages = Math.ceil(historyCache.length / PAGE_SIZE) || 1;
	    if (currentHistoryPage > totalPages) currentHistoryPage = totalPages;
	    if (currentHistoryPage < 1) currentHistoryPage = 1;

	    const startIndex = (currentHistoryPage - 1) * PAGE_SIZE;
	    const pageList = historyCache.slice(startIndex, startIndex + PAGE_SIZE);

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

	    // 🎯 [핵심 수정] 더미 행에도 동일한 버튼/뱃지 구조를 넣어 높이를 100% 일치시킵니다.
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

	function changeHistoryPage(page) {
	    currentHistoryPage = page;
	    renderHistoryTable();
	}

	// 🎯 공통 페이징 버튼 UI 생성 함수
	function renderPaginationControls(containerId, tbodyElem, currentPage, totalPages, onPageChange) {
	    let container = document.getElementById(containerId);
	    
	    // 페이지네이션 영역이 없으면 테이블 바로 다음에 동적 생성
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

	// 날짜 포맷 함수 (기존 유구)
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

    // 5. 모달 열기 (고유 함수명 적용 및 ID 검증 추가)
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

                document.getElementById('mActionId').textContent = data.situNo || actionId;
                document.getElementById('mWorkerInfo').textContent = `${data.finder || '요원'}`;
                document.getElementById('mActionContent').textContent = data.situContent || '내용 없음';
                
                const adminCommentEl = document.getElementById('adminComment');
                if (adminCommentEl) {
                    adminCommentEl.value = data.workContent || data.adminComment || '';
                }

                const photoBox = document.getElementById('mPhotoBox');
                if (photoBox) {
                    if (data.situImage) {
                        photoBox.innerHTML = `<img src="${basePath}/resources/upload/situation/${data.situImage}" style="max-width:100%; max-height:200px; border-radius:6px;">`;
                    } else {
                        photoBox.innerHTML = '<span style="color:#64748b; font-size:12px;">첨부 사진 없음</span>';
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

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFieldActionPage);
} else {
    initFieldActionPage();
}