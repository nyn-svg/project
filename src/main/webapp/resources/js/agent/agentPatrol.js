$(document).ready(function() {

    /* 본문 메뉴 */
    // 사전 점검
    $("#btnPreCheck").on("click", function() {
        console.log("사전 점검 페이지 이동 요청");
        location.href = "safetyCheck"; 
    });

    // 긴급 처리보고
    $("#btnEmergencyReport").on("click", function() {
        console.log("긴급 처리보고 페이지 이동 요청");
		location.href = "emergency"; 
    });

    // 유관기관 대형 카드 영역 클릭 시 피드백
    $("#btnOrgReport").on("click", function() {
        alert("하단의 119 또는 112 배지 버튼을 터치하시면 즉시 전화 다이얼 연동이 수행됩니다.");
    });

    // 다이얼 그룹의 [기타] 버튼 클릭 시
    $("#btnDialEtc").on("click", function() {
        alert("기타 관할 유관기관 비상 연락망 명단을 조회합니다.");
    });
	
	/* 하단 메뉴 */
	 // 안전순찰
	    $("#navPatrol").on("click", function() {
	        console.log("하단 메뉴 : 안전순찰");
	        location.href = "patrol";
	    });

	    // 홈
	    $("#navHome").on("click", function() {
	        console.log("하단 메뉴 : 홈");
	        location.href = "main";
	    });

	    // 조치보고
	    $("#navReport").on("click", function() {
	        console.log("하단 메뉴 : 조치보고");
	        location.href = "history";
	    });
	});