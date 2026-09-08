$(document).ready(function () {

    /* Context Path */
    const contextPath = window.contextPath || "";

    /* 알림 버튼 */
    $("#notificationBtn").on("click", function () {
        // 현재는 알림 기능 연결 전
        console.log("알림 버튼 클릭");
    });


    /* 근무 상태 변경 */
    $("#statusChangeBtn").on("click", function () {
        location.href = "status/edit";
    });


    /* 주요 알림 전체보기 */
    $("#noticeMoreBtn").on("click", function () {
        console.log("알림 전체보기");
        // 실제 알림 조회 화면 URL이 만들어지면 연결
        // location.href = contextPath + "/agent/notice";
    });


    /* 주요 알림 클릭 */
    $(".notice-item").on("click", function () {
        const type = $(this).data("type");
        console.log("알림 종류 : " + type);

        if (type === "danger") {
            // 위험 알림 상세
            // location.href = contextPath + "/agent/danger";
            alert("위험 알림 상세 화면");
        }
        else if (type === "request") {
            // 안전 요청 상세
            // location.href = contextPath + "/agent/request";
            alert("안전 요청 상세 화면");
        }
        else if (type === "notice") {
            // 공지사항 상세
            // location.href = contextPath + "/agent/notice";
            alert("공지사항 상세 화면");
        }
    });


    /* 바로가기 */
    // 위험 알림
    $(".quick-danger").on("click", function () {
        console.log("위험 알림");
        location.href = "/history/more";
    });

	
    // 안전 순찰
    $(".quick-patrol").on("click", function () {
        console.log("안전순찰");
        location.href = "patrol";
    });


    // 나의 구역
    $(".quick-area").on("click", function () {
        console.log("나의 구역");
        // 실제 담당구역 Controller URL 확인 후 연결
        alert("나의 구역 화면");
    });


    // 조치 보고
    $(".quick-report").on("click", function () {
        console.log("조치보고");
		location.href = "/history";
    });


    /* 하단 네비게이션 */
    // 안전순찰
    $("#navPatrol").on("click", function () {
        console.log("하단 메뉴 : 안전순찰");
        location.href = "patrol";
    });


    // 홈
    $("#navHome").on("click", function () {
        console.log("하단 메뉴 : 홈");
        location.href = contextPath + "/agent/main";
    });


    // 조치보고
    $("#navReport").on("click", function () {
        console.log("하단 메뉴 : 조치보고");
        location.href = contextPath + "/agent/history";
    });


    /* 로그아웃 */
    $("#logoutBtn").on("click", function () {
        const result = confirm("로그아웃 하시겠습니까?");

        if (!result) {
            return;
        }

        /* 실제 로그아웃 Controller URL 확인 후 연결 */
        location.href = contextPath + "/logout";
    });
});