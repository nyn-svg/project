<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>근무 상태 변경</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet"	href="${pageContext.request.contextPath}/resources/css/agent/agentStatusEdit.css">
</head>
<body>

	<div class="mobile-container">
		<!-- 헤더 -->
		<header class="mobile-header">
			<a href="javascript:history.back()" class="back-btn"> <i
				class="fa-solid fa-chevron-left"></i>
			</a>
			<h1>근무 상태 변경</h1>
			<div class="header-right-empty"></div>
		</header>

		<!-- 메인 -->
		<main class="mobile-content">
			<p class="page-title">현재 근무 상태를 선택해주세요.</p>

			<form action="${pageContext.request.contextPath}/agent/status/edit"
				method="post">
				<div class="status-options-list">

					<!-- 근무중 -->
					<label class="status-option-card type-active"> <input
						type="radio" name="workStatus" value="근무중"
						class="status-option-input"
						${user.workStatus eq '근무중' or empty user.workStatus ? 'checked' : ''}>
						<span class="custom-radio"></span>
						<div class="status-text-group">
							<span class="status-title">근무중</span> <span class="status-desc">정상적으로
								근무를 수행 중입니다.</span>
						</div>
					</label>

					<!-- 휴식중 -->
					<label class="status-option-card"> <input type="radio"
						name="workStatus" value="휴식중" class="status-option-input"
						${user.workStatus eq '휴식중' ? 'checked' : ''}> <span
						class="custom-radio"></span>
						<div class="status-text-group">
							<span class="status-title">휴식중</span> <span class="status-desc">잠시
								휴식을 취하고 있습니다.</span>
						</div>
					</label>

					<!-- 외출중 -->
					<label class="status-option-card"> <input type="radio"
						name="workStatus" value="외출중" class="status-option-input"
						${user.workStatus eq '외출중' ? 'checked' : ''}> <span
						class="custom-radio"></span>
						<div class="status-text-group">
							<span class="status-title">외출중</span> <span class="status-desc">외부
								업무로 자리를 비웠습니다.</span>
						</div>
					</label>

					<!-- 퇴근 -->
					<label class="status-option-card type-danger"> <input
						type="radio" name="workStatus" value="퇴근"
						class="status-option-input"
						${user.workStatus eq '퇴근' ? 'checked' : ''}> <span
						class="custom-radio"></span>
						<div class="status-text-group">
							<span class="status-title">퇴근</span> <span class="status-desc">오늘
								일과를 마치고 퇴근했습니다.</span>
						</div>
					</label>

				</div>

				<!-- 하단 버튼 -->
				<div class="action-buttons">
					<a href="${pageContext.request.contextPath}/agent/main"
						class="btn btn-cancel">취소</a>
					<button type="submit" class="btn btn-submit">변경</button>
				</div>
			</form>
		</main>
	</div>

	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script type="text/javascript">
		var currentStatus = "${empty user.workStatus ? '근무중' : user.workStatus}";
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/js/agent/agentStatusEdit.js"></script>

	<!-- 감지 알림(토스트 알림) -->
	<jsp:include page="/WEB-INF/views/common/agentAlarm.jsp" />

</body>
</html>
