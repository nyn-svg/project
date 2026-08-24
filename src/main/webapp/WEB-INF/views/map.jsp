<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>축제 관제 시스템</title>
    <!-- 카카오맵 API 로드 -->
    <script type="text/javascript" 
    src="http://dapi.kakao.com/v2/maps/sdk.js?appkey=893d42a705b8275bf35865b1d40e6d96&autoload=false">
    </script>
    <!-- Tailwind CSS 불러오기 -->
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body>

    <h2>전국 축제 관제 시스템</h2>
    <!-- 지도가 그려질 영역 -->
    <div id="map" style="width:100%; height:500px;"></div>

    <script>
    kakao.maps.load(function() {
        // 1. 지도 생성
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(36.5, 127.5),
            level: 12
        };

        var map = new kakao.maps.Map(container, options);

        // 2. 축제 데이터 (정확한 수치 대신 혼잡도 상태 활용)
        var festivalList = [
            {
                name: '서울 밤도깨비 야시장',
                lat: 37.5665,
                lng: 126.9780,
                status: '위험',
                color: 'red'
            },
            {
                name: '대전 0시 축제',
                lat: 36.3504,
                lng: 127.3845,
                status: '주의',
                color: 'orange'
            },
            {
                name: '부산 바다 축제',
                lat: 35.1795,
                lng: 129.0756,
                status: '정상',
                color: 'green'
            }
        ];

        // 3. 마커 생성 및 클릭 이벤트 (빨려들어가는 이동 + 확대)
        festivalList.forEach(function(festival) {
            var markerPosition = new kakao.maps.LatLng(festival.lat, festival.lng);

            var marker = new kakao.maps.Marker({
                position: markerPosition,
                map: map
            });

         // 현재 열려있는 팝업창을 저장할 변수 (이벤트 영역 밖에 선언되어 있어야 합니다)
            var currentOverlay = null;

            // 1. 마커 마우스 오버 시: 토스 스타일 팝업창 미리보기 출력
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                // 기존에 열려있던 팝업창이 있다면 제거
                if (currentOverlay) {
                    currentOverlay.setMap(null);
                }

                // 토스 스타일 팝업 HTML 구조
                var content = 
                    '<div class="bg-white/95 backdrop-blur-md p-5 rounded-3xl shadow-2xl border border-gray-100 min-w-[220px] transform transition-all duration-200 pointer-events-none" style="position:relative; bottom:65px;">' +
                    '   <!-- 상단 텍스트 -->' +
                    '   <div class="flex items-center justify-between mb-3 border-b border-gray-100 pb-2">' +
                    '       <span class="text-xs font-bold text-blue-600 tracking-wider">실시간 관제</span>' +
                    '       <span class="text-xs text-gray-400 font-medium">방금 갱신</span>' +
                    '   </div>' +
                    '   <!-- 축제 이름 -->' +
                    '   <h3 class="text-lg font-bold text-gray-800 mb-3">' + festival.name + '</h3>' +
                    '   <!-- 상태 바 (토스 알약 스타일) -->' +
                    '   <div class="flex items-center justify-between bg-gray-50 p-3 rounded-2xl">' +
                    '       <span class="text-sm font-semibold text-gray-600">혼잡도</span>' +
                    '       <span class="px-3 py-1 text-xs font-bold text-white rounded-full" style="background-color:' + festival.color + ';">' + festival.status + '</span>' +
                    '   </div>' +
                    '</div>';

                // CustomOverlay 생성 및 지도 표시
                var overlay = new kakao.maps.CustomOverlay({
                    content: content,
                    map: map,
                    position: markerPosition       
                });

                currentOverlay = overlay;
            });

            // 2. 마커 클릭 시: 비로소 지도가 해당 축제 장소로 빨려 들어가듯 확대
            kakao.maps.event.addListener(marker, 'click', function() {
                // A. 해당 위치로 부드럽게 이동
                map.panTo(markerPosition);
                
                // B. 시차를 두고 현장 수준(레벨 3)으로 확대
                setTimeout(function() {
                    map.setLevel(3, {animate: true});
                }, 300);
            });
        });
    });
		 
		 
    </script>

</body>
</html>