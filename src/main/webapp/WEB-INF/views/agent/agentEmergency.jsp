<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>긴급 보고</title>

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
			<h1 class="header-title">긴급 보고</h1>
			<div class="header-dummy"></div>
		</header>

		<!-- 메인 콘텐츠 -->
		<main class="mobile-content">
			<div class="alert-banner">
				<i class="fa-solid fa-circle-exclamation alert-icon"></i> 
				<span>긴급 상황 발생 시 신속하게 보고해주세요.</span>
			</div>

			<!-- AJAX 비동기 통신 폼 -->
			<form id="emergencyForm" class="report-form">

				<!-- 비즈니스 약속 고정 데이터 정의 (hidden) -->
				<input type="hidden" name="situType" value="긴급보고"> 
				<input type="hidden" name="situStatus" value="감지">


				<!-- 위험 유형 -->
				<div class="form-group">
					<label class="form-label" for="dngrType">보고 유형 (위험 유형)<span class="required-star">*</span></label> 
					<select id="dngrType" name="dngrType" class="form-select">
						<option value="인파위험">인파위험</option>
						<option value="야생동물">야생동물</option>
						<option value="인명사고">인명사고</option>
						<option value="시설고장/파손">시설고장/파손</option>
						<option value="연계필요">연계필요</option>
						<option value="기타">기타</option>
					</select>
				</div>

				<!-- 위험 단계 -->
				<div class="form-group">
					<label class="form-label" for="dngrLevel">위험 단계<span class="required-star">*</span></label> 
					<select id="dngrLevel" name="dngrLevel" class="form-select">
						<option value="심각">심각 (즉시 통제)</option>
						<option value="경계">경계 (준-심각 상황)</option>
						<option value="주의">주의 (집중 모니터링)</option>
						<option value="관심">관심 (경미한 사항)</option>
						<option value="판단불가">판단불가</option>
					</select>
				</div>

				<!-- 구역명 -->
				<div class="form-group">
					<label class="form-label" for="zoneName">발생 구역<span class="required-star">*</span></label> 
					<select id="zoneName" name="zoneName" class="form-select">
						<option value="A구역">A구역</option>
						<option value="B구역">B구역</option>
						<option value="C구역">C구역</option>
						<option value="D구역">D구역</option>
					</select>
				</div>

				<!-- 발견인 -->
				<div class="form-group">
					<label class="form-label">발견인 (보고 요원)</label>
					<div class="location-toggle-row">
						<div class="location-text">
							<i class="fa-solid fa-user-shield icon-disabled-lead"></i>
							<span class="text-disabled-title">${user.userName}</span>
						</div>
						<span class="badge-status badge-gray">안전요원</span>
					</div>
				</div>

				<!-- 감지내용 -->
				<div class="form-group">
					<label class="form-label" for="situContent">상황 내용 (감지 내용)<span class="required-star">*</span></label>
					<div class="textarea-wrapper">
						<textarea id="situContent" name="situContent" class="form-textarea" maxlength="300" placeholder="상황에 대해 상세히 입력해주세요."></textarea>
						<div class="char-count">
							<span id="charCount">0</span>/300
						</div>
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