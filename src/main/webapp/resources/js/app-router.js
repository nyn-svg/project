// app-router.js
$(document).ready(function() {
	updateHeaderActiveByUrl();
    $(document).on('click', '.sidebar-link', function(e) {
        e.preventDefault();
		$('.header-nav .nav-link').removeClass('active');
        // 클릭한 링크의 href 주소 그대로 사용 (/drone/stream?id=B)
        const targetUrl = $(this).attr('href');

        if (targetUrl && targetUrl !== '#') {
            loadContent(targetUrl);
        }
    });
	

    function loadContent(url) {
        $.ajax({
            url: url,
            type: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            },
            success: function(response) {
                $('#main-container').html(response);
                history.pushState(null, null, url);
            },
            error: function(xhr, status, error) {
                console.error('페이지 로드 에러:', status, error);
                alert('화면을 불러오는데 실패했습니다.');
            }
        });
    }

    window.onpopstate = function() {
        loadContent(location.href);
    };
	
	// 상단 헤더 메뉴 비동기(AJAX) 이동 이벤트
	$(document).on('click', '.header-link', function(e) {
	    e.preventDefault(); // 동기식 페이지 이동 방지

	    var targetUrl = $(this).attr('href');
	    var $this = $(this);
		
		// 모든 헤더 메뉴의 active 제거
		    $('.header-nav .nav-link').removeClass('active');

		// ★ 로고를 누르거나 홈 버튼을 누른 경우 -> 홈 버튼에 active 불빛 켜기
				if ($this.hasClass('header-logo') || targetUrl === '${pageContext.request.contextPath}/' || targetUrl === '/') {
			        $('.header-nav .nav-link[href$="/"]').addClass('active');
			    } else {
			        // 그 외 메뉴(감지 조회, 위험 이력 등) 클릭 시 해당 메뉴에 active 불빛 켜기
			        $this.addClass('active');
			    }

	    // 2. 비동기로 메인 영역 컨텐츠만 수신
		$.ajax({
		    url: targetUrl,
		    type: 'GET',
		    dataType: 'html',
		    success: function(response) {
		        // 가져온 HTML에서 #main-container 내부 알맹이만 추출하여 교체
		        var newContent = $(response).find('#main-container').html();
		        
		        if (newContent) {
		            $('#main-container').html(newContent);
		        } else {
		            // #main-container 구조가 아닐 경우 전체 응답을 메인 영역에 주입
		            $('#main-container').html(response);
		        }

		        // ★ [추가된 코드] 감지 이력 페이지 로드 시 더미 데이터 렌더링 함수 실행
		        if (typeof initDetectionPage === 'function') {
		            initDetectionPage();
		        }

		        // 3. 브라우저 주소창 URL 변경 (뒤로가기 지원)
		        history.pushState(null, '', targetUrl);
		    },
		    error: function(xhr, status, error) {
		        console.error('페이지를 불러오는 중 오류가 발생했습니다:', error);
		    }
		});
	});

	// 브라우저 뒤로가기 / 앞으로가기 버튼 대응
	window.onpopstate = function() {
	    location.reload();
	};
	
	function updateHeaderActiveByUrl() {
	    // 1. 모든 헤더 active 불빛 제거
	    $('.header-nav .nav-link').removeClass('active');

	    // 2. 현재 브라우저의 URL 경로 가져오기 (예: "/detection", "/realtime", "/actionLog", "/")
	    var currentPath = window.location.pathname;

	    // 3. 경로 비교 후 해당되는 메뉴에만 active 추가
	    if (currentPath === '/' || currentPath === '${pageContext.request.contextPath}/') {
	        $('.header-nav .nav-link[href$="/"]').addClass('active');
	    } else if (currentPath.includes('/detection')) {
	        $('.header-nav .nav-link[href*="detection"]').addClass('active');
	    } else if (currentPath.includes('/realtime')) {
	        $('.header-nav .nav-link[href*="realtime"]').addClass('active');
	    } else if (currentPath.includes('/actionLog')) {
	        $('.header-nav .nav-link[href*="actionLog"]').addClass('active');
	    } else if (currentPath.includes('/history')) {
	        $('.header-nav .nav-link[href*="history"]').addClass('active');
	    }
	}
	
});

