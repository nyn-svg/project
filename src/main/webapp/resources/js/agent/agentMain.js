$(document).ready(function() {

    /* Context Path */
    const contextPath = window.contextPath || "";

	/* 알림 버튼 */
	$("#notificationBtn").on("click", function() {
	    location.href = "report";
	});


    /* 근무 상태 변경 */
    $("#statusChangeBtn").on("click", function() {
        location.href = "status/edit";
    });


    /* 안전 수칙 */
    /* 안전 수칙 클릭 핸들러 */
    $(".rule-item").on("click", function() {
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


    // 조치 보고
    $(".quick-report").on("click", function() {
        console.log("조치보고");
        location.href = "history";
    });


    // 비상 연락망 클릭 핸들러
	// 비상 연락망 클릭 핸들러 (종류별 그룹화 적용 버전)
	$(".quick-area").on("click", function() {
	    $.ajax({
	        url: contextPath + "/agent/emergency-contacts",
	        type: "GET",
	        dataType: "json",
	        success: function(list) {
	            let htmlContent = "";
	            if (!list || list.length === 0) {
	                htmlContent = "<li style='text-align:center; padding:20px; color:#94a3b8;'>등록된 비상연락처가 없습니다.</li>";
	            } else {
	                
	                // 💡 [핵심 추가] 1. category(HOST, AGENCY 등) 기준으로 데이터를 그룹화합니다.
	                const groupedContacts = list.reduce(function(acc, item) {
	                    const category = item.category || "기타";
	                    if (!acc[category]) {
	                        acc[category] = [];
	                    }
	                    acc[category].push(item);
	                    return acc;
	                }, {});

	                // 💡 2. 그룹화된 데이터를 바탕으로 종류별 섹션을 묶어서 HTML을 생성합니다.
	                for (const category in groupedContacts) {
	                    // 카테고리 헤더 타이틀 추가 (UI 구분을 위한 구분선 역할)
	                    htmlContent += '<li class="contact-group-header" style="background: #f8fafc; padding: 8px 16px; font-weight: bold; color: #1e3a8a; border-bottom: 1px solid #e2e8f0; border-top: 1px solid #e2e8f0; font-size: 13px;">' + category + 
	                                   '</li>';

	                    // 해당 카테고리에 속한 연락처들만 반복 출력
	                    groupedContacts[category].forEach(function(item) {
	                        let rawPhone = item.phone.replace(/[^0-9]/g, ''); 
	                        let formattedPhone = rawPhone;

	                        if (rawPhone.length === 8) {
	                            formattedPhone = rawPhone.replace(/(\d{4})(\d{4})/, '$1-$2');
	                        } else if (rawPhone.startsWith('02')) {
	                            if (rawPhone.length === 9) formattedPhone = rawPhone.replace(/(\d{2})(\d{3})(\d{4})/, '$1-$2-$3');
	                            else if (rawPhone.length === 10) formattedPhone = rawPhone.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
	                        } else {
	                            if (rawPhone.length === 10) formattedPhone = rawPhone.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
	                            else if (rawPhone.length === 11) formattedPhone = rawPhone.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
	                        }

	                        htmlContent += '<li class="contact-item" style="border-bottom: 1px solid #f1f5f9;">' +
	                            '    <div class="contact-info">' +
	                            // 카테고리 뱃지는 숨기거나 작게 유지 (이미 상단 헤더로 묶였으므로 제거해도 무방합니다)
	                            '        <span class="contact-category" style="display:none;">' + item.category + '</span>' + 
	                            '        <strong class="contact-title" style="margin-left: 5px;">' + item.title + '</strong>' +
	                            '    </div>' +
	                            '    <a href="tel:' + rawPhone + '" class="call-btn" onclick="event.stopPropagation();">' +
	                            '        <i class="fa-solid fa-phone"></i> ' + formattedPhone +
	                            '    </a>' +
	                            '</li>';
	                    });
	                }
	            }
	            $("#contactListArea").html(htmlContent);
	            $("#contactModal").css("display", "flex");
	        },
	        error: function() {
	            alert("비상연락망을 불러오는 데 실패했습니다.");
	        }
	    });
	});



    // 비상연락망 모달 닫기 이벤트
    $("#btnCloseContactModal, #btnConfirmContactModal").on("click", function() {
        $("#contactModal").css("display", "none");
    });

    $("#contactModal").on("click", function(e) {
        if ($(e.target).hasClass("custom-modal-overlay")) {
            $(this).css("display", "none");
        }
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