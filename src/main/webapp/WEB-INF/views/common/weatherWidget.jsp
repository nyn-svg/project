<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="weather-header-widget">
	<!-- 날씨 상태 (아이콘 + 한국어) -->
    <span class="weather-item main-status">
        <i id="wIcon" class="fa-solid fa-sun"></i> 
        <span id="wDesc">날씨</span>
    </span>
    <span class="weather-divider">|</span>
    
    <!-- 상세 기상 요소 -->
    <span class="weather-item"><i class="fa-solid fa-temperature-half"></i> <span id="wTemp">- °C</span></span>
    <span class="weather-item"><i class="fa-solid fa-wind"></i> <span id="wWind">- m/s</span></span>
    <span class="weather-item"><i class="fa-solid fa-droplet"></i> <span id="wHumidity">- %</span></span>
    
    <!-- 비행 상태 뱃지 -->
    <span class="weather-badge status-warning" id="wStatus">연결중</span>
</div>

<script>
	// OpenWeatherMap 무료 API
	const API_KEY = '단톡방 공지 댓글 참고'.trim();
	const LAT = 36.36072; // 유림공원 위도
	const LON = 127.35789; // 유림공원 경도
	const weatherUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=' + LAT + '&lon=' + LON + '&appid=' + API_KEY + '&units=metric&lang=kr';
	
	function fetchWeather() {
	    $.ajax({
	        // &lang=kr 추가 (한국어 설명 및 번역 데이터수신)
	        url: weatherUrl,
	        type: 'GET',
	        success: function(data) {
	            // 1. 데이터 추출
	            const temp = Math.round(data.main.temp);									// 기온
	            const wind = parseFloat(data.wind.speed.toFixed(1));						// 평균 풍속
	            const gust = data.wind.gust ? parseFloat(data.wind.gust.toFixed(1)) : wind;	// 순간 풍속 (돌풍)
	            const humidity = data.main.humidity;										// 습도
	            const weatherMain = data.weather[0].main;									// 날씨 분류
	            const weatherDesc = data.weather[0].description;							// 한국어 날씨 설명
	            const visibility = data.visibility || 10000;								// 가시거리 (m)

	            // 2. 텍스트 업데이트
	            $('#wTemp').text(temp + '°C');
	            $('#wWind').text(wind + ' m/s');
	            $('#wHumidity').text(humidity + '%');
	            $('#wDesc').text(weatherDesc);

	            // 3. 날씨 상태에 따른 FontAwesome 아이콘 변경
	            const $wIcon =$('#wIcon');
	            $wIcon.removeClass(); // 기존 클래스 제거
	            
	            switch(weatherMain) {
		            case 'Clear':
		                $wIcon.attr('class', 'fa-solid fa-sun').css('color', '#f59e0b');
		                break;
		            case 'Clouds':
		                $wIcon.attr('class', 'fa-solid fa-cloud').css('color', '#94a3b8');
		                break;
		            case 'Rain':
		            case 'Drizzle':
		                $wIcon.attr('class', 'fa-solid fa-cloud-showers-heavy').css('color', '#38bdf8');
		                break;
		            case 'Thunderstorm':
		                $wIcon.attr('class', 'fa-solid fa-bolt').css('color', '#facc15');
		                break;
		            case 'Snow':
		                $wIcon.attr('class', 'fa-regular fa-snowflake').css('color', '#e2e8f0');
		                break;
		            default:
		                $wIcon.attr('class', 'fa-solid fa-smog').css('color', '#cbd5e1');
		        }

	            // 4. 안전 지침 기준 세분화된 비행 가능 여부 판단
	            const $wStatus =$('#wStatus');

	            // [위험/비행금지 조건] 낙뢰, 비/눈, 돌풍(10m/s 이상), 평균풍속(7m/s 이상), 시야1km 미만
	            if (
	                weatherMain === 'Thunderstorm' || 
	                weatherMain === 'Rain' || 
	                weatherMain === 'Drizzle' || 
	                weatherMain === 'Snow' ||
	                gust >= 10.0 || 
	                wind >= 7.0 ||
	                visibility < 1000
	            ) {
	                let reason = '비행 금지 (악천후)';
	                if (weatherMain === 'Thunderstorm') reason = '비행 금지 (낙뢰 위험)';
	                else if (weatherMain === 'Rain' || weatherMain === 'Drizzle') reason = '비행 금지 (강우)';
	                else if (gust >= 10.0 || wind >= 7.0) reason = '비행 금지 (강풍/돌풍)';
	                else if (visibility < 1000) reason = '비행 금지 (시야 미확보)';

	                $wStatus.text(reason)
	                        .css({'background': '#dc2626', 'color': '#ffffff'})
	                        .attr('class', 'weather-badge status-danger');
	            } 
	            // [주의/감속비행 조건] 평균풍속 5~7m/s 또는 돌풍 7~10m/s, 안개/연무
	            else if (wind >= 5.0 || gust >= 7.0 || weatherMain === 'Squall' || weatherMain === 'Mist' || weatherMain === 'Fog') {
	                $wStatus.text('비행 주의 (풍속/안개)')
	                        .css({'background': '#d97706', 'color': '#ffffff'})
	                        .attr('class', 'weather-badge status-warning');
	            } 
	            // [양호 조건]
	            else {
	                $wStatus.text('비행 가능 (양호)')
	                        .css({'background': '#059669', 'color': '#ffffff'})
	                        .attr('class', 'weather-badge status-ok');
	            }
	        },
	        error: function(err) {
	            console.error('날씨 정보를 불러오지 못했습니다.', err);
	            $('#wStatus').text('연결 실패')
                			 .css({'background': '#6b7280', 'color': '#ffffff'});
	        }
	    });
	}

	// 페이지 로드 시 실행 및 5분마다 자동 갱신
	$(document).ready(function() {
	    fetchWeather();
	    setInterval(fetchWeather, 300000); 
	});
</script>