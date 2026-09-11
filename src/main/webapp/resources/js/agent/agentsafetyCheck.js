$(document).ready(function() {

    // 라디오 버튼 선택 시 해당 문항의 빨간 에러 스타일 즉시 제거
    $(document).on('change', '.check-item input[type="radio"]', function() {
        $(this).closest('.check-item').removeClass('error');
    });

    // 폼 제출(submit) 이벤트
    $('#safetyCheckForm').on('submit', function(e) {
        e.preventDefault();

        let detailList = [];
        let isValid = true;
        let $firstErrorItem = null;

        // 기존 에러 스타일 초기화
        $('.check-item').removeClass('error');

        // 모든 점검 문항 순회
        $('.check-item').each(function() {
            let $item = $(this);
            let itemId = $item.data('item-id');
            let checkStatus = $item.find('input[type="radio"]:checked').val();
            let remark = $item.find('input.remark-input').val();

            // 라디오 버튼 미선택 시
            if (!checkStatus) {
                isValid = false;
                $item.addClass('error'); // 빨간 테두리 적용

                // 제일 첫 번째 미선택 문항 저장 (스크롤 이동용)
                if (!$firstErrorItem) {
                    $firstErrorItem = $item;
                }
            } else {
                detailList.push({
                    itemNo: String(itemId),
                    statusCode: checkStatus,
                    remark: remark
                });
            }
        });

        // 미선택 항목이 있는 경우
        if (!isValid) {
            alert("선택하지 않은 점검 항목이 있습니다. 다시 확인해주세요.");

            // 첫 번째 미선택 항목 위치로 스크롤
            if ($firstErrorItem && $firstErrorItem.length) {
                const container = document.querySelector('.safety-check-page');
                if (container) {
                    container.scrollTo({
                        top: $firstErrorItem[0].offsetTop - 70,
                        behavior: 'smooth'
                    });
                } else {
                    $firstErrorItem[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
            return;
        }

        // 정상 제출 처리
        let masterDTO = {
            detailList: detailList
        };

        $.ajax({
            url: contextPath + '/agent/safetyCheck/submit',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(masterDTO),
            success: function(res) {
                if (res.success) {
                    location.href = contextPath + '/agent/safetyCheck/complete';
                } else {
                    alert("저장 실패: " + res.message);
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX Error:", error);
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    });

});