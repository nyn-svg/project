$(document).ready(function() {

    // 폼 제출(submit) 이벤트 리스너 연결
    $('#safetyCheckForm').on('submit', function(e) {
        // 1. 브라우저 기본 form submit(페이지 새로고침) 방지
        e.preventDefault();

        let detailList = [];
        let isValid = true;

        // 2. JSP 문항 카드 클래스인 .check-item 기준으로 순회
        $('.check-item').each(function() {
            let itemId = $(this).data('item-id');
            let checkStatus = $(this).find('input[type="radio"]:checked').val();
            let remark = $(this).find('input.remark-input').val();

            // 라디오 버튼 미선택 시 검증 실패 처리
            if (!checkStatus) {
                isValid = false;
                return false; // each 루프 탈출
            }

            detailList.push({
                itemNo: String(itemId),
                statusCode: checkStatus,
                remark: remark
            });
        });

        if (!isValid) {
            alert("모든 점검 항목의 상태를 선택해주세요.");
            return;
        }

        // SafetyCheckMasterDTO 구조에 맞춘 객체 생성
        let masterDTO = {
            detailList: detailList
        };

        // 3. AJAX 데이터 전송
        $.ajax({
            url: contextPath + '/agent/safetyCheck/submit',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(masterDTO),
            success: function(res) {
                if (res.success) {
                    // 완료 페이지로 이동
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