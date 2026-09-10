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

$(document).ready(function() {
    updateHeaderActiveByUrl();


    $(document).on('click', '.sidebar-link', function(e) {
        e.preventDefault();
        $('.header-nav .nav-link').removeClass('active');
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

                // 비동기 이동 후 페이지별 초기화 함수 실행
                if (typeof initAreaManagement === 'function') {
                    initAreaManagement();
                }
                if (typeof initDetectionPage === 'function') {
                    initDetectionPage();
                }
				
				// 💡 비동기 이동 완료 후 stream 페이지의 로드 함수가 존재하면 강제 실행
				if (typeof window.initStreamPage === 'function') {
					window.initStreamPage();
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

                if (typeof initDetectionPage === 'function') {
                    initDetectionPage();
                }

                if (typeof initAreaManagement === 'function') {
                    initAreaManagement();
                }


                history.pushState(null, '', targetUrl);
            },
            error: function(xhr, status, error) {
                console.error('페이지를 불러오는 중 오류가 발생했습니다:', error);
            }
        });
    });

    // 브라우저 뒤로가기 / 앞으로가기 대응
    window.onpopstate = function() {
        location.reload();
    };

    function updateHeaderActiveByUrl() {
        $('.header-nav .nav-link').removeClass('active');
        var currentPath = window.location.pathname;

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