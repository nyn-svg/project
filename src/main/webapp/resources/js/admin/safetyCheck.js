// 동기/비동기 페이지 이동 모두를 지원하는 초기화 함수
function initSafetyCheckPage() {
    // 카운터 엘리먼트 참조
    const countTotalEl = document.getElementById('count-total');
    const countDoneEl = document.getElementById('count-done');
    const countNormalEl = document.getElementById('count-normal');
    const countWarningEl = document.getElementById('count-warning');
    const countDangerEl = document.getElementById('count-danger');
	
	// 🎯 오늘 날짜 자동 입력 (YYYY-MM-DD)
	    const checkDateInput = document.getElementById('checkDate');
	    if (checkDateInput && !checkDateInput.value) {
	        const today = new Date();
	        const year = today.getFullYear();
	        const month = String(today.getMonth() + 1).padStart(2, '0');
	        const day = String(today.getDate()).padStart(2, '0');
	        
	        checkDateInput.value = `${year}-${month}-${day}`;
	    }

    // 엘리먼트가 존재하지 않으면 (페이지가 아직 로드되지 않은 상태) 실행 중단
    if (!countTotalEl) return;

    // 1. 전체 점검 항목 수 계산
    function calculateTotalItems() {
        const radioNames = new Set();
        document.querySelectorAll('input[type="radio"]').forEach(radio => {
            radioNames.add(radio.name);
        });
        return radioNames.size;
    }

    const totalItems = calculateTotalItems();
    countTotalEl.textContent = totalItems;

    // 2. 선택 상태별 실시간 요약 집계
    function updateSummaryCounters() {
        let doneCount = 0;
        let normalCount = 0;
        let warningCount = 0;
        let dangerCount = 0;

        const radioNames = new Set();
        document.querySelectorAll('input[type="radio"]').forEach(radio => radioNames.add(radio.name));

        radioNames.forEach(name => {
            const checkedRadio = document.querySelector(`input[name="${name}"]:checked`);
            if (checkedRadio) {
                doneCount++;
                const val = checkedRadio.value;
                if (val === 'NORMAL') normalCount++;
                else if (val === 'WARN') warningCount++;
                else if (val === 'DANGER') dangerCount++;
            }
        });

        if (countDoneEl) countDoneEl.textContent = doneCount;
        if (countNormalEl) countNormalEl.textContent = normalCount;
        if (countWarningEl) countWarningEl.textContent = warningCount;
        if (countDangerEl) countDangerEl.textContent = dangerCount;
    }

    // 3. 이벤트 리스너 등록
    document.querySelectorAll('input[type="radio"]').forEach(radio => {
        radio.addEventListener('change', updateSummaryCounters);
    });

    // 4. 저장 버튼 이벤트
    const btnSave = document.getElementById('btn-save');
    if (btnSave) {
        btnSave.onclick = function () {
            const doneCount = parseInt(countDoneEl ? countDoneEl.textContent : '0', 10);
            
            if (doneCount < totalItems) {
                if (!confirm(`총 ${totalItems}개 항목 중 ${doneCount}개만 점검되었습니다. 이대로 저장하시겠습니까?`)) {
                    return;
                }
            } else {
                if (!confirm('안전점검 결과를 저장하시겠습니까?')) {
                    return;
                }
            }

            const masterData = {
                checkDate: document.getElementById('checkDate').value,
                checkRound: document.getElementById('checkRound').value,
                inspector: document.getElementById('inspector').value,
                detailList: []
            };

            const radioNames = new Set();
            document.querySelectorAll('input[type="radio"]').forEach(radio => radioNames.add(radio.name));

            radioNames.forEach(name => {
                const checkedRadio = document.querySelector(`input[name="${name}"]:checked`);
                const inputEl = document.querySelector(`input[name="${name}"]`);
                const rowEl = inputEl ? inputEl.closest('tr') : null;
                const remarkInput = rowEl ? rowEl.querySelector('.input-remark') : null;

                if (checkedRadio) {
                    masterData.detailList.push({
                        itemNo: name,
                        statusCode: checkedRadio.value,
                        remark: remarkInput ? remarkInput.value : ''
                    });
                }
            });

            const basePath = (typeof contextPath !== 'undefined' && contextPath !== null) ? contextPath : '';
            const saveUrl = basePath + '/admin/safetyCheck/save';

            fetch(saveUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(masterData)
            })
            .then(response => {
                if (!response.ok) throw new Error('HTTP 에러: ' + response.status);
                return response.text();
            })
            .then(result => {
                if (result === 'SUCCESS') {
                    alert('안전점검 결과가 DB에 성공적으로 저장되었습니다.');
                    location.reload();
                } else {
                    alert('저장에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 통신 오류가 발생했습니다.');
            });
        };
    }

    // 5. AI 법적 보고서 생성 버튼 이벤트 (초기화 함수 내부로 이동)
    const btnGenerateReport = document.getElementById('btn-generate-report');
    if (btnGenerateReport) {
        btnGenerateReport.onclick = function () {
            if (!confirm('최근 점검 내역을 바탕으로 AI 법적 보고서를 생성하시겠습니까?\n(약 10~20초 정도 소요될 수 있습니다.)')) {
                return;
            }

            btnGenerateReport.disabled = true;
            btnGenerateReport.innerHTML = '<i class="fas fa-spinner fa-spin"></i> AI 보고서 작성 중...';

            const basePath = (typeof contextPath !== 'undefined' && contextPath !== null) ? contextPath : '';
            const reportUrl = basePath + '/admin/safetyCheck/generateReport';

            fetch(reportUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) throw new Error('HTTP 에러: ' + response.status);
                return response.text();
            })
            .then(reportContent => {
                const contentEl = document.getElementById('aiReportContent');
                if (contentEl) {
                    contentEl.textContent = reportContent;
                }

                const modalEl = document.getElementById('aiReportModal');
                if (modalEl) {
                    modalEl.style.display = 'flex';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('보고서 생성 중 오류가 발생했습니다.');
            })
            .finally(() => {
                btnGenerateReport.disabled = false;
                btnGenerateReport.innerHTML = '<i class="fas fa-robot"></i> AI 법적 보고서 생성';
            });
        };
    }
}

// [핵심] 새로고침(동기)과 메뉴 이동(비동기) 모두를 감지하여 실행
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initSafetyCheckPage);
} else {
    initSafetyCheckPage();
}

// ==========================================
// 전역 모달 핸들러 (HTML onclick 바인딩용)
// ==========================================

// 1. 메일 발송 영역 토글
window.toggleEmailArea = function() {
    const area = document.getElementById('emailFormArea');
    if (!area) return;

    if (area.style.display === 'none' || area.style.display === '') {
        area.style.display = 'flex';
        const input = document.getElementById('targetEmailInput');
        if (input) input.focus();
    } else {
        area.style.display = 'none';
    }
};

// 2. 유관기관 선택 시 이메일 자동 입력
window.onSelectAgency = function(val) {
    const input = document.getElementById('targetEmailInput');
    if (!input) return;

    if (val === 'direct' || val === '') {
        input.value = '';
        input.focus();
    } else {
        input.value = val;
    }
};

// 3. 메일 전송 요청 (Pure Vanilla JS fetch 적용)
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

    if (!confirm(email + ' 주소로 보고서를 발송하시겠습니까?')) {
        return;
    }

    const basePath = (typeof contextPath !== 'undefined' && contextPath !== null) ? contextPath : '';

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

// 4. AI 보고서 모달 닫기
window.closeAiReportModal = function() {
    const modalEl = document.getElementById('aiReportModal');
    if (modalEl) {
        modalEl.style.display = 'none';
    }
};