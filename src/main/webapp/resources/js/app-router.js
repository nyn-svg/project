// app-router.js

// 💡 1. 초기화 함수는 $(document).ready 바깥 전역 스코프에 정의
window.initAreaManagement = function() {
    // 1) 기존 SSE 연결이 남아있다면 종료
    if (window.eventSource) {
        window.eventSource.close();
        window.eventSource = null;
    }

    // 2) 백엔드 SSE 구독
    window.eventSource = new EventSource('/admin/area/sse');

    // 3) 백엔드에서 Controller가 쏘는 정확한 이벤트명(MAP_UPDATED) 등록
    window.eventSource.addEventListener('MAP_UPDATED', function(e) {
        console.log('⚡ [SSE] 실시간 지도/구역 변경 신호 수신!');
        if (typeof loadSavedAreaConfig === 'function') {
            loadSavedAreaConfig();
        }
    });

    // 4) 백엔드에서 이벤트명 없이 일반 send()로 쐈을 경우 대비
    window.eventSource.onmessage = function(e) {
        console.log('⚡ [SSE] 실시간 메시지 수신:', e.data);
        if (typeof loadSavedAreaConfig === 'function') {
            loadSavedAreaConfig();
        }
    };

    // 5) 최초 진입 시 DB 데이터 불러오기
    if (typeof loadSavedAreaConfig === 'function') {
        loadSavedAreaConfig();
    }
};

// 현재 URL 경로를 기준으로 헤더 메뉴 active 클래스 동기화 (전역 선언)
function updateHeaderActiveByUrl() {
	$('.header-nav .nav-link').removeClass('active');
	var currentPath = window.location.pathname;

	if (currentPath === '/' || currentPath === '${pageContext.request.contextPath}/') {
	    $('.header-nav .nav-link[href$="/"]').addClass('active');
	} else if (currentPath.includes('/main')) {
	    $('.header-nav .nav-link[href*="main"]').addClass('active');
	} else if (currentPath.includes('/realtime') || currentPath.includes('/stream')) {
		$('.header-nav .nav-link[href*="realtime"]').addClass('active');
	} else if (currentPath.includes('/detection')) {
		$('.header-nav .nav-link[href*="detection"]').addClass('active');
	}  else if (currentPath.includes('/cooperation')) {
		$('.header-nav .nav-link[href*="cooperation"]').addClass('active');
	} else if (currentPath.includes('/actionLog')) {
		$('.header-nav .nav-link[href*="actionLog"]').addClass('active');
	}
}

// 최초 진입 시 실행
$(document).ready(function() {
    // 페이지 새로고침 (F5 / 주소창 입력) 시, 헤더 매뉴 활성화
	updateHeaderActiveByUrl();
	
	// 페이지 새로고침 (F5 / 주소창 입력) 시, 최초 1회 콘텐츠 및 초기화 함수 실행
	const currentPath = window.location.pathname;
	if (currentPath.includes('/realtime')) {
		if (typeof window.initRealtimePage === 'function') {
			 window.initRealtimePage();
		}
	}
	if (currentPath.includes('/stream')) {
		if (typeof window.initStreamPage === 'function') {
			window.initStreamPage();
		}
	}
	
	// 사이드 바 비동기(AJAX) 이동 이벤트
    $(document).on('click', '.sidebar-link', function(e) {
        e.preventDefault();
        $('.header-nav .nav-link').removeClass('active');
        const targetUrl = $(this).attr('href');

        if (targetUrl && targetUrl !== '#') {
            loadContent(targetUrl);
        }
    });

    function loadContent(url) {
		// 다른 페이지로 이동하기 전에 기존 스트리밍 자원 및 타이머 정리
		if (typeof window.destroyStreamPage === 'function') {
			window.destroyStreamPage();
			window.destroyStreamPage = null; // 사용 후 함수 초기화
		}
		
		// 다른 페이지로 이동하기 전에 Lock 해제 (추가 예정)
		
        $.ajax({
            url: url,
            type: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            },
            success: function(response) {
				// 💡 응답받은 전체 HTML에서 #main-container 내부 알맹이만 추출
				var $parsed = $('<div>').html(response);
				var newContent = $parsed.find('#main-container').html();
				
				if (newContent) {
					$('#main-container').html(newContent);
				} else {
					$('#main-container').html(response);
				}
				
				// 서버 요청 없이 주소창의 URL만 바꾸는 기능
                history.pushState(null, null, url);
				
				// 페이지 내 비동기(AJAX) 이동 시, 헤더 메뉴 활성화
				updateHeaderActiveByUrl();

                // 비동기 이동 후 페이지별 초기화 함수 실행
                if (typeof initAreaManagement === 'function') {
                    initAreaManagement();
                }
				
                if (typeof initDetectionPage === 'function') {
                    initDetectionPage();
                }
				
				if (typeof initRealtimePage === 'function') {
					initRealtimePage();
				}
				
				if (typeof initStreamPage === 'function') {
					initStreamPage();
				}
              
            },
            error: function(xhr, status, error) {
                console.error('페이지 로드 에러:', status, error);
                alert('화면을 불러오는데 실패했습니다.');
            }
        });
    }

    // 상단 헤더 메뉴 비동기(AJAX) 이동 이벤트
    $(document).on('click', '.header-link', function(e) {
        e.preventDefault();

        var targetUrl = $(this).attr('href');
        var $this = $(this);

        $('.header-nav .nav-link').removeClass('active');

        if ($this.hasClass('header-logo') || targetUrl === '${pageContext.request.contextPath}/' || targetUrl === '/') {
            $('.header-nav .nav-link[href$="/"]').addClass('active');
        } else {
            $this.addClass('active');
        }
		
		// 다른 페이지로 이동하기 전에 기존 스트리밍 자원 및 타이머 정리
		if (typeof window.destroyStreamPage === 'function') {
			window.destroyStreamPage();
			window.destroyStreamPage = null; // 사용 후 함수 초기화
		}
		
		// 다른 페이지로 이동하기 전에 Lock 해제 (추가 예정)

        $.ajax({
            url: targetUrl,
            type: 'GET',
            dataType: 'html',
            success: function(response) {
                var newContent = $(response).find('#main-container').html();
				
                if (newContent) {
                    $('#main-container').html(newContent);
                } else {
                    $('#main-container').html(response);
                }
				
				// 서버 요청 없이 주소창의 URL만 바꾸는 기능
				history.pushState(null, '', targetUrl);
				
				if (typeof initAreaManagement === 'function') {
					initAreaManagement();
				}

                if (typeof initDetectionPage === 'function') {
                    initDetectionPage();
                }
				
				if (typeof initRealtimePage === 'function') {
				    initRealtimePage();
				}

            },
            error: function(xhr, status, error) {
                console.error('페이지를 불러오는 중 오류가 발생했습니다:', error);
            }
        });
    });
	
	// 브라우저 뒤로가기 및 앞으로가기 처리
	$(window).on('popstate', function() {
		// 현재 변경된 URL의 화면을 비동기로 다시 로드
		loadContent(location.pathname);
	});
});