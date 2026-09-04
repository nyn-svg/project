// 비동기 로딩(AJAX Page Load) 환경을 위한 초기화 실행
(function initSafetyCheck() {

    // 카운터 엘리먼트 참조
    const countTotalEl = document.getElementById('count-total');
    const countDoneEl = document.getElementById('count-done');
    const countNormalEl = document.getElementById('count-normal');
    const countWarningEl = document.getElementById('count-warning');
    const countDangerEl = document.getElementById('count-danger');

    // 1. 전체 점검 항목 수 계산
    function calculateTotalItems() {
        const radioNames = new Set();
        document.querySelectorAll('input[type="radio"]').forEach(radio => {
            radioNames.add(radio.name);
        });
        return radioNames.size;
    }

    const totalItems = calculateTotalItems();
    if (countTotalEl) {
        countTotalEl.textContent = totalItems;
    }

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
                if (val === 'NORMAL') {
                    normalCount++;
                } else if (val === 'WARN') {
                    warningCount++;
                } else if (val === 'DANGER') {
                    dangerCount++;
                }
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
        btnSave.addEventListener('click', function () {
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
                if (!response.ok) {
                    throw new Error('HTTP 에러: ' + response.status);
                }
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
        });
    }

    // 5. 출력 버튼 이벤트
    const btnPrint = document.getElementById('btn-print');
    if (btnPrint) {
        btnPrint.addEventListener('click', function () {
            window.print();
        });
    }

})();