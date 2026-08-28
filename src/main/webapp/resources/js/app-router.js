// app-router.js
$(document).ready(function() {
    $(document).on('click', '.sidebar-link', function(e) {
        e.preventDefault();
        
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
});