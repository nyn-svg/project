<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<!-- fragments/festival_map.jsp -->
<div class="bg-white p-6 rounded-3xl shadow-lg border border-gray-100">
    <h2 class="text-xl font-bold mb-4">실시간 현장 관제 지도</h2>
    <div id="map" style="width:100%; height:600px;" class="rounded-2xl"></div>
</div>

<script>
    // 비동기로 이 조각이 불러와질 때 카카오 지도 스크립트 실행
    initKakaoMap(); 
</script>