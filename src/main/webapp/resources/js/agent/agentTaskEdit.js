// 자바 Date 객체가 텍스트로 깨져서 넘어와도(예: Tue Sep 15...) 완벽하게 파싱하는 함수
function parseAndFormatDate(rawDate) {
    if (!rawDate || rawDate === "null" || rawDate === null) return "확인 불가 (기록 없음)";

    let str = String(rawDate).trim();
    if (!str) return "확인 불가 (기록 없음)";

    // 💡 브라우저 내장 파싱 엔진 가동 (영문 요일 텍스트 포맷 완벽 방어)
    let timestamp = Date.parse(str);
    if (!isNaN(timestamp)) {
        let d = new Date(timestamp);
        let pad = (n) => n < 10 ? '0' + n : n;
        return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
    }

    // 만약 순수 밀리초 숫자로 들어온 경우 방어
    if (!isNaN(str)) {
        let d = new Date(Number(str));
        let pad = (n) => n < 10 ? '0' + n : n;
        return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
    }

    return str.replace("T", " ").substring(0, 16);
}

// datetime-local 규격용 포맷터
function getNowDateTimeLocal() {
    const d = new Date();
    const pad = (n) => n < 10 ? '0' + n : n;
    return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + 'T' + pad(d.getHours()) + ':' + pad(d.getMinutes());
}

function convertToDateTimeLocalFormat(rawDate) {
    if (!rawDate || rawDate === "null" || rawDate === null) return "";
    let timestamp = Date.parse(String(rawDate).trim());
    if (!isNaN(timestamp)) {
        let d = new Date(timestamp);
        let pad = (n) => n < 10 ? '0' + n : n;
        return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + 'T' + pad(d.getHours()) + ':' + pad(d.getMinutes());
    }
    return getNowDateTimeLocal();
}

$(document).ready(function() {


    $(".img-responsive-view").on("click", function() {
        const imgSrc = $(this).attr("src"); 
        $("#modalTargetImg").attr("src", imgSrc); 
        $("#imageModal").css("display", "flex"); 
    });


    window.closeImageModal = function() {
        $("#imageModal").css("display", "none");
    };

    // 1. 조치 완료 시간 세팅
    const dbEndDate = $("#endDate").data("raw-date");
    const endVal = convertToDateTimeLocalFormat(dbEndDate);
    $("#endDate").val(endVal ? endVal : getNowDateTimeLocal());

    // 2. 실시간 글자수 카운팅
    const $textarea = $('#workContent');
    const $count = $('#charCount');
    if ($textarea.length) {
        $count.text($textarea.val().length);
        $textarea.on('input', function() {
            $count.text($(this).val().length);
        });
    }

    // 3. 커스텀 첨부파일 등록 파일명 노출
    $("#uploadFile").on("change", function() {
        let fileValue = $(this).val();
        if (fileValue) {
            let fileName = fileValue.split("\\").pop();
            $("#fileNameDisplay").text(fileName).css("color", "#2563eb");
        } else {
            $("#fileNameDisplay").text("선택된 파일이 없습니다.").css("color", "#94a3b8");
        }
    });

    // 4. 유효성 검사 서밋
    $('#taskUpdateForm').on('submit', function(e) {
        if (!$.trim($textarea.val())) {
            alert("현장 조치 내용을 반드시 작성해주세요.");
            $textarea.focus();
            return false;
        }
        return true;
    });
});
