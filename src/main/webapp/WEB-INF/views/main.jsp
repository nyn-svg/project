<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- main.jsp -->
<!DOCTYPE html>
<html>
<head>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="bg-gray-50">
    <!-- 상단 고정 네비게이션 (새로고침 안 됨) -->
    <nav class="flex gap-4 p-4 bg-white shadow-sm">
        <button onclick="loadPage('/festival/map')" class="font-bold text-blue-600">축제 관제 지도</button>
        <button onclick="loadPage('/agent/list')" class="font-bold text-gray-600">요원 현황</button>
    </nav>

    <!-- 실시간으로 내용물이 바뀌는 동적 컨테이너 -->
    <main id="app-content" class="p-6 transition-all duration-300">
        <!-- 처음에 지도 화면 자동 로드 -->
    </main>

    <script>
    // 비동기 화면 전환 핵심 함수
    function loadPage(url) {
    var $content = $('#app-content');

    // 1. [트랜지션] 기존 화면을 0.15초 동안 투명하게 만들고 살짝 아래로 내림
    $content.removeClass('opacity-100 translate-y-0').addClass('opacity-0 translate-y-2');

    setTimeout(function() {
        // 2. 비동기 HTML 요청
        $.ajax({
            url: url,
            type: 'GET',
            success: function(htmlData) {
                // 내용 교체
                $content.html(htmlData);

                // 3. [History API] 새로고침 없이 브라우저 주소창만 변경
                history.pushState({ path: url }, '', url);

                // 4. [트랜지션] 새 화면을 스르륵 위로 올리면서 선명하게 등장 (토스 모션)
                setTimeout(function() {
                    $content.removeClass('opacity-0 translate-y-2').addClass('opacity-100 translate-y-0');
                }, 50);
            }
        });
    }, 150);
}

// 브라우저 뒤로가기/앞으로가기 버튼을 눌렀을 때 처리
window.onpopstate = function(event) {
    if (event.state && event.state.path) {
        // 뒤로가기 시 해당 주소의 화면을 비동기로 다시 로드
        loadPage(event.state.path);
    }
};

    // 첫 진입 시 지도 로드
    $(document).ready(function() {
        loadPage('/festival/map');
    });
    </script>
</body>
</html>