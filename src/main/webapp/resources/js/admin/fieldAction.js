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

    // 3. 미결 조치 목록 AJAX 조회
    function loadPendingList() {
        fetch(basePath + '/admin/fieldAction/api/list?statusType=PENDING')
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('pendingTbody');
                const countBadge = document.getElementById('pendingCount');
                if (countBadge) countBadge.textContent = data.length;

                if (!tbody) return;
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" style="text-align:center;">검토 대기 중인 조치 건이 없습니다.</td></tr>';
                    return;
                }

                data.forEach(item => {
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
                            <!-- 💡 고유 함수명(openFieldActionDetailModal)으로 변경 -->
                            <button type="button" class="btn btn-primary" onclick="openFieldActionDetailModal('${item.situNo}')">상세 검토</button>
                        </td>
                    `;
                    tbody.appendChild(tr);
                });
            })
            .catch(err => console.error('미결 목록 로드 실패:', err));
    }

    // 4. 완료 이력 목록 AJAX 조회
    function loadHistoryList() {
        fetch(basePath + '/admin/fieldAction/api/list?statusType=HISTORY')
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById('historyTbody');
                if (!tbody) return;
                tbody.innerHTML = '';

                if (data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" style="text-align:center;">완료된 조치 이력이 없습니다.</td></tr>';
                    return;
                }

                data.forEach(item => {
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
                            <!-- 💡 고유 함수명(openFieldActionDetailModal)으로 변경 -->
                            <button type="button" class="btn btn-secondary" onclick="openFieldActionDetailModal('${item.situNo}')">이력 조회</button>
                        </td>
                    `;
                    tbody.appendChild(tr);
                });
            })
            .catch(err => console.error('이력 목록 로드 실패:', err));
    }
    
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