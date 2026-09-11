$(document).ready(function() {

    /* Context Path */
    const contextPath = window.contextPath || "";

    /* 알림 버튼 */
    $("#notificationBtn").on("click", function() {
        // 현재는 알림 기능 연결 전
        console.log("알림 버튼 클릭");
    });


    /* 근무 상태 변경 */
    $("#statusChangeBtn").on("click", function() {
        location.href = "status/edit";
    });


    /* 안전 수칙 */
	/* 안전 수칙 클릭 핸들러 */
	$(".rule-item").on("click", function () {
	    const title = $(this).data("title");
	    const rawRule = $(this).data("rule");

	    const ruleArray = rawRule.split("|");
	    
	    let htmlContent = "<ol class='modal-rule-list'>";
	    ruleArray.forEach(function(sentence) {
	        htmlContent += "<li>" + sentence + "</li>";
	    });
	    htmlContent += "</ol>";

	    $("#modalTitle").text(title);
	    $("#modalBodyText").html(htmlContent);

	    $("#ruleModal").css("display", "flex");
	});

    // 상단 우측 X 버튼 누를 때 팝업 닫기
    $("#btnCloseModal").on("click", function() {
        $("#ruleModal").css("display", "none");
    });

    // 하단 검은색 [확인] 버튼 누를 때 팝업 닫기
    $("#btnConfirmModal").on("click", function() {
        $("#ruleModal").css("display", "none");
    });

    // 팝업 창 바깥 어두운 배경 영역을 터치해도 자연스럽게 닫히도록 예외 처리
    $("#ruleModal").on("click", function(e) {
        if ($(e.target).hasClass("custom-modal-overlay")) {
            $(this).css("display", "none");
        }
    });


    /* 바로가기 */
    // 위험 알림
    $(".quick-danger").on("click", function() {
        console.log("긴급보고");
        location.href = "emergency";
    });


    // 안전 순찰
    $(".quick-patrol").on("click", function() {
        console.log("안전순찰");
        location.href = "safetyCheck";
    });


    // 나의 구역
    $(".quick-area").on("click", function() {
        console.log("나의 구역");
        // 실제 담당구역 Controller URL 확인 후 연결
        alert("나의 구역 화면");
    });


    // 조치 보고
    $(".quick-report").on("click", function() {
        console.log("조치보고");
        location.href = "history";
    });


    /* 하단 네비게이션 */
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


    /* 로그아웃 */
    $("#logoutBtn").on("click", function() {
        const result = confirm("로그아웃 하시겠습니까?");

        if (!result) {
            return;
        }

        /* 실제 로그아웃 Controller URL 확인 후 연결 */
        location.href = "logout";
    });
});