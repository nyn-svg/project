<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>긴급상황 조치 보고</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/agent/agentEmergency.css">
</head>
<body>

	<div class="mobile-container">
		<!-- 상단 헤더 -->
		<header class="mobile-header">
			<button type="button" class="btn-back" onclick="history.back()">
				<i class="fa-solid fa-chevron-left"></i>
			</button>
			<h1 class="header-title">긴급상황 조치 보고</h1>
			<div class="header-dummy"></div>
		</header>

		<!-- 메인 콘텐츠 -->
		<main class="mobile-content">
			<div class="alert-banner">
				<i class="fa-solid fa-circle-exclamation alert-icon"></i> 
				<span>긴급 상황 발생 시 신속하게 조치 한 후 상황 보고해주세요.</span>
			</div>

			<!-- AJAX 비동기 통신 폼 -->
			<form id="emergencyForm" class="report-form">

				<!-- 비즈니스 약속 고정 데이터 정의 (hidden) -->
				<input type="hidden" name="situType" value="긴급보고"> 
				<input type="hidden" name="situStatus" value="감지">


				<!-- [우선순위 1] 위험 유형 (보고 유형) -->
				<div class="form-group">
				    <label class="form-label">보고 유형 (위험 유형)<span class="required-star">*</span></label> 
				    <!-- 기존 select는 개발 편의(Form 전송)를 위해 유지하되 스타일로 숨김 -->
				    <select id="dngrType" name="dngrType" style="display:none;">
				        <option value="인파위험" selected>인파위험</option>
				        <option value="야생동물">야생동물</option>
				        <option value="인명사고">인명사고</option>
				        <option value="시설고장/파손">시설고장/파손</option>
				        <option value="연계필요">연계필요</option>
				        <option value="기타">기타</option>
				    </select>
				    
				    <!-- 실질적으로 눈에 보이는 버튼 선택형(2열 배치) -->
				    <div class="chip-container grid-2col" id="dngrTypeChips">
				        <button type="button" class="btn-chip active" data-value="인파위험">🔥 인파위험</button>
				        <button type="button" class="btn-chip" data-value="야생동물">🐻 야생동물</button>
				        <button type="button" class="btn-chip" data-value="인명사고">🚨 인명사고</button>
				        <button type="button" class="btn-chip" data-value="시설고장/파손">🛠️ 시설고장/파손</button>
				        <button type="button" class="btn-chip" data-value="연계필요">🔗 연계필요</button>
				        <button type="button" class="btn-chip" data-value="기타">❓ 기타</button>
				    </div>
				</div>


				<!-- [우선순위 2] 상황 내용 (조치 내용) ➡️ 100% 선택 칩으로 변경 -->
				<div class="form-group">
				    <label class="form-label">상황 내용 (조치 내용)<span class="required-star">*</span></label>
				    
				    <!-- 기존 백엔드 전송을 안전하게 유지하기 위해 hidden input으로 교체 -->
				    <input type="hidden" id="situContent" name="situContent" value="">

				    <div class="template-guide-banner">
				        <i class="fa-solid fa-hand-pointer"></i> 현장 상황 내용을 선택해 주세요.
				    </div>

				    <!-- JS에서 선택한 '보고 유형'에 맞춰 동적으로 버튼 칩들이 라디오 버튼처럼 생성되는 영역 -->
				    <div class="template-container" id="situTemplateChips"></div>
				</div>


				<!-- [우선순위 3] 위험 단계 -->
				<div class="form-group">
				    <label class="form-label">위험 단계<span class="required-star">*</span></label> 
				    <select id="dngrLevel" name="dngrLevel" style="display:none;">
				        <option value="심각" selected>심각 (즉시 통제)</option>
				        <option value="경계">경계 (준-심각 상황)</option>
				        <option value="주의">주의 (집중 모니터링)</option>
				    </select>
				    
				    <!-- 2열 및 가로 압축 형태로 배치될 위험도 선택 버튼 컨테이너 -->
				    <div class="chip-container" id="dngrLevelChips">
				        <button type="button" class="btn-chip-level lvl-danger active" data-value="심각">🔴 심각 (즉시 통제)</button>
				        <button type="button" class="btn-chip-level lvl-warning" data-value="경계">🟠 경계 (심각 상황)</button>
				        <button type="button" class="btn-chip-level lvl-caution" data-value="주의">🟡 주의 (집중 모니터링)</button>
				    </div>
				</div>


				<!-- [우선순위 하향] 발생 구역 -->
				<div class="form-group">
					<label class="form-label">발생 구역</label>
					<div class="location-toggle-row bg-disabled-light">
						<div class="location-text">
							<i class="fa-solid fa-map-marker-alt icon-disabled-lead"></i>
							<span class="text-disabled-title">${user.workArea}</span>
						</div>
						<span class="badge-status badge-gray">구역</span>
					</div>
				</div>

				<!-- [우선순위 하향] 발견인 -->
				<div class="form-group">
					<label class="form-label">발견인 (보고 요원)</label>
					<div class="location-toggle-row bg-disabled-light">
						<div class="location-text">
							<i class="fa-solid fa-user-shield icon-disabled-lead"></i>
							<span class="text-disabled-title">${user.userName}</span>
						</div>
						<span class="badge-status badge-gray">안전요원</span>
					</div>
				</div>

				<!-- 첨부사진 -->
				<div class="form-group">
					<label class="form-label">첨부 사진 (선택)</label>
					<div class="photo-upload-area">
						<input type="file" id="photoInput" name="photo" accept="image/*">
						<button type="button" class="btn-photo-add" onclick="document.getElementById('photoInput').click()">
							<i class="fa-solid fa-camera camera-icon"></i> <span>사진 추가</span>
						</button>
					</div>
				</div>


				<!-- 하단 버튼 그룹 -->
				<div class="form-btn-group">
					<button type="button" class="btn-cancel" onclick="history.back()">취소</button>
					<button type="submit" id="btnSubmitEmergency" class="btn-submit btn-emergency-submit">긴급 등록</button>
				</div>
			</form>
		</main>
	</div>


	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/agent/agentEmergency.js"></script>
	<!-- 감지 알림(토스트 알림) -->
	<jsp:include page="/WEB-INF/views/common/agentAlarm.jsp" />

</body>
</html>