/**
 * 현장 조치 승인 및 관리 (fieldAction.js)
 * Pure JavaScript (Vanilla JS) & Fetch API 기반
 */

function initFieldActionPage() {
    const tabPendingBox = document.getElementById('tab-pending');
    const tabHistoryBox = document.getElementById('tab-history');
    const actionDetailModal = document.getElementById('actionDetailModal');

    if (!tabPendingBox && !tabHistoryBox) return;

    // 1. 탭 전환 함수
    window.switchTab = function (tabType) {
        const tabBtns = document.querySelectorAll('.tab-btn');
        tabBtns.forEach(btn => btn.classList.remove('active'));

        if (tabType === 'pending') {
            if (tabBtns[0]) tabBtns[0].classList.add('active');
            if (tabPendingBox) tabPendingBox.style.display = 'block';
            if (tabHistoryBox) tabHistoryBox.style.display = 'none';
        } else if (tabType === 'history') {
            if (tabBtns[1]) tabBtns[1].classList.add('active');
            if (tabPendingBox) tabPendingBox.style.display = 'none';
            if (tabHistoryBox) tabHistoryBox.style.display = 'block';
        }
    };

    // 2. 모달 열기 함수
    window.openDetailModal = function (actionId) {
        const mActionId = document.getElementById('mActionId');
        const adminComment = document.getElementById('adminComment');

        if (mActionId) mActionId.textContent = actionId;
        if (adminComment) adminComment.value = '';

        if (actionDetailModal) {
            actionDetailModal.style.display = 'flex';
        }
    };

    // 3. 모달 닫기 함수
    window.closeModal = function () {
        if (actionDetailModal) {
            actionDetailModal.style.display = 'none';
        }
    };

    // 4. 모달 배경 클릭 시 닫기 (오버레이 이벤트 처리)
    if (actionDetailModal) {
        actionDetailModal.onclick = function (e) {
            if (e.target === actionDetailModal) {
                window.closeModal();
            }
        };
    }

    // 5. 승인 / 반려 처리 함수
    window.processAction = function (type) {
        const mActionId = document.getElementById('mActionId');
        const adminCommentEl = document.getElementById('adminComment');

        const actionId = mActionId ? mActionId.textContent.trim() : '';
        const adminComment = adminCommentEl ? adminCommentEl.value.trim() : '';
        const actionTypeName = (type === 'APPROVE') ? '승인' : '반려';

        if (type === 'REJECT' && !adminComment) {
            alert('반려 시에는 사유를 반드시 입력해주세요.');
            if (adminCommentEl) adminCommentEl.focus();
            return;
        }

        if (!confirm(`${actionId} 건을 최종 [${actionTypeName}] 처리하시겠습니까?`)) {
            return;
        }

        const basePath = (typeof contextPath !== 'undefined' && contextPath !== null) 
            ? contextPath 
            : ((typeof window.contextPath !== 'undefined') ? window.contextPath : '');
        
        const processUrl = basePath + '/admin/fieldAction/process';

        const formData = new URLSearchParams();
        formData.append('actionId', actionId);
        formData.append('status', type);
        formData.append('adminComment', adminComment);

        fetch(processUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: formData.toString()
        })
        .then(response => {
            if (!response.ok) throw new Error('HTTP 에러: ' + response.status);
            return response.json();
        })
        .then(res => {
            if (res && res.status === 'success') {
                alert(`성공적으로 ${actionTypeName} 처리되었습니다.`);
                window.closeModal();
                location.reload();
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

// 동기/비동기 페이지 전환 감지
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFieldActionPage);
} else {
    initFieldActionPage();
}