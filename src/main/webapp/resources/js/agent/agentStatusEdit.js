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