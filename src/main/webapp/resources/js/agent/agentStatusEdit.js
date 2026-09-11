document.addEventListener('DOMContentLoaded', function() {
			// 업무 내용 글자 수 초기화 및 카운트
			var taskContent = document.getElementById('taskContent');
			var charCount = document.getElementById('charCount');

			if (taskContent && charCount) {
				// 기존 텍스트 길이 초기 반영
				charCount.innerText = taskContent.value.length;

				taskContent.addEventListener('input', function() {
					charCount.innerText = this.value.length;
				});
			}

			// 💡 폼 전송 이벤트 (e.preventDefault 삭제하여 컨트롤러로 정상 POST 제출)
			var taskUpdateForm = document.getElementById('taskUpdateForm');
			if (taskUpdateForm) {
				taskUpdateForm.addEventListener('submit', function(e) {
					// 검증 로직이 필요한 경우 여기에 작성
				});
			}
		});
		
$(document).ready(function() {
    
    // 동일 상태 선택 여부 유효성 검사
    $("form").on("submit", function(e) {
        // 사용자가 새로 선택한 상태값 가져오기
        const selectedStatus = $("input[name='workStatus']:checked").val();
   
        if (currentStatus === selectedStatus) {
            alert("현재 상태가 '" + currentStatus + "'입니다.\n다른 상태를 선택 후 변경해주세요.");
            // 서버로의 Form 전송(Submit) 강제 차단
            e.preventDefault(); 
            return false;
        }
    });
});