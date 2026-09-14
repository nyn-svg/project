$(document).ready(function() {

    // 사전 점검 페이지 이동
    $("#btnPreCheck").on("click", function() {
        console.log("사전 점검 페이지 이동 요청");
        location.href = "safetyCheck"; 
    });

    /* 하단 메뉴 클릭 이벤트 */
    // 안전순찰
    $("#navPatrol").on("click", function() {
        location.href = "patrol";
    });

    // 홈
    $("#navHome").on("click", function() {
        location.href = "main";
    });

    // 조치보고
    $("#navReport").on("click", function() {
        location.href = "history";
    });
});