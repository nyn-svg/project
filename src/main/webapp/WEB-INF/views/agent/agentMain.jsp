<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>안전요원 홈</title>

<link rel="stylesheet"	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet"	href="${pageContext.request.contextPath}/resources/css/agent/agentMain.css">
</head>
<body>

	<div class="mobile-container">
		<!--  HEADER -->
		<header class="mobile-header">
			<div class="header-left">
				<div class="user-profile">
					<div class="profile-icon">
						<i class="fa-solid fa-user"></i>
					</div>
					<div class="user-text">
						<span class="welcome-text"> 안녕하세요 </span> <strong
							class="user-name"> ${user.userName} 안전요원님 </strong>
					</div>
				</div>
			</div>


			<button type="button" class="notification-bell" id="notificationBtn">
				<i class="fa-regular fa-bell"></i> <span class="bell-count">0</span>
			</button>
		</header>


		<!-- MAIN CONTENT 이 영역만 스크롤됨 -->
		<main class="mobile-content">
			<!-- 현재 근무 상태 -->
			<section class="status-card">
				<div class="status-card-top">
					<span class="section-label"> 현재 상태 </span>

					<c:choose>
						<c:when test="${user.workStatus eq '근무중'}">
							<span class="status-badge status-green"> <span
								class="status-dot"></span> 근무중
							</span>
						</c:when>
						<c:when
							test="${user.workStatus eq '휴식중' or user.workStatus eq '외출중'}">
							<span class="status-badge status-blue"> <span
								class="status-dot"></span> ${user.workStatus}
							</span>
						</c:when>
						<c:when test="${user.workStatus eq '퇴근'}">
							<span class="status-badge status-red"> <span
								class="status-dot"></span> 퇴근
							</span>
						</c:when>
					</c:choose>
				</div>

				<div class="status-main">
					<h2>${user.workArea}</h2>
					<p>
						<i class="fa-regular fa-clock"></i> ${user.workTime}
					</p>
				</div>

				<button type="button" class="status-change-btn" id="statusChangeBtn">
					<span> 근무 상태 변경 </span> <i class="fa-solid fa-chevron-right"></i>
				</button>
			</section>

			<!-- 안전 수칙 -->
			<section class="notice-section">
				<div class="section-header">
					<h2>안전 수칙</h2>
				</div>

				<div class="notice-list">
					<!-- 1. 위험 상황 전파 -->
					<button type="button" class="notice-item info rule-item"
						data-title="위험 상황 전파 수칙"
						data-rule="발견 즉시 관제실 보고 및 무전 전파를 최우선으로 합니다.|메가폰 및 호각을 사용하여 주변 관람객에게 대피 방향을 안내합니다.|2차 사고 예방을 위해 통제선을 신속히 설치하고 인근 요원에게 지원을 요청합니다.">
						<div class="notice-icon">
							<i class="fa-solid fa-bullhorn"></i>
						</div>
						<div class="notice-info">
							<div class="notice-title">위험 상황 전파</div>
							<div class="notice-text">위험 감지 즉시 관제실 보고 및 주변 전파 수칙</div>
						</div>
						<span class="notice-time"><i
							class="fa-solid fa-chevron-right"></i></span>
					</button>

					<!-- 2. 인파 밀집 대응 -->
					<button type="button" class="notice-item info rule-item"
						data-title="인파 밀집 대응 수칙"
						data-rule="보행 동선 흐름이 끊기지 않도록 일방통행(우측통행)을 유도합니다.|병목 현상이 발생하는 취약 지점(계단, 경사로)에 요원을 고정 배치합니다.|밀집도가 급증할 경우 진입을 일시 통제하고 우회 동선을 안내합니다.">
						<div class="notice-icon">
							<i class="fa-solid fa-people-group"></i>
						</div>
						<div class="notice-info">
							<div class="notice-title">인파 밀집 대응</div>
							<div class="notice-text">병목 구간 고정 배치 및 일방 보행 동선 유도 지침</div>
						</div>
						<span class="notice-time"><i
							class="fa-solid fa-chevron-right"></i></span>
					</button>

					<!-- 3. 사고 발생 조치 -->
					<button type="button" class="notice-item info rule-item"
						data-title="사고 발생 조치 지침"
						data-rule="즉시 119 신고 및 주변 관람객과 협조하여 환자 안전 공간을 확보합니다.|구조대 도착 전까지 기도 확보 및 심폐소생술(CPR) 등 응급처치를 실시합니다.|관제실과의 실시간 무전 공유를 통해 사고 경위 및 피해 상황을 지속 보고합니다.">
						<div class="notice-icon">
							<i class="fa-solid fa-truck-medical"></i>
						</div>
						<div class="notice-info">
							<div class="notice-title">사고 발생 조치</div>
							<div class="notice-text">응급 환자 발생 시 CPR 실시 및 의무대 연계 지침</div>
						</div>
						<span class="notice-time"><i
							class="fa-solid fa-chevron-right"></i></span>
					</button>
				</div>
			</section>

			<!-- 팝업창(모달) 구조 -->
			<div id="ruleModal" class="custom-modal-overlay">
				<div class="custom-modal-content">
					<div class="modal-header-row">
						<h3 id="modalTitle">수칙 상세 보기</h3>
						<button type="button" class="modal-close-x" id="btnCloseModal">&times;</button>
					</div>
					<div class="modal-body-area">
						<!-- 자바스크립트로 행안부 수칙 세부 내용이 들어갈 자리 -->
						<p id="modalBodyText"></p>
					</div>
					<div class="modal-footer-row">
						<button type="button" class="modal-confirm-btn"
							id="btnConfirmModal">확인</button>
					</div>
				</div>
			</div>


			<!-- 바로가기 -->
			<section class="quick-section">
				<div class="section-header">
					<h2>바로가기</h2>
				</div>

				<div class="quick-grid">
					<!-- 긴급 보고 -->
					<button type="button" class="quick-card quick-danger">
						<div class="quick-icon danger-icon">
							<i class="fa-solid fa-triangle-exclamation"></i>
						</div>

						<div class="quick-text">
							<strong> 긴급 보고 </strong> <span> 긴급 조치 보고 </span>
						</div>
						<i class="fa-solid fa-chevron-right quick-arrow"></i>
					</button>

					<!-- 사전 점검 -->
					<button type="button" class="quick-card quick-patrol">
						<div class="quick-icon patrol-icon">
							<i class="fa-solid fa-shield-halved"></i>
						</div>

						<div class="quick-text">
							<strong> 사전 점검 </strong> <span> 사전 점검 체크 리스트</span>
						</div>

						<i class="fa-solid fa-chevron-right quick-arrow"></i>
					</button>

					<!-- 비상 연락망 -->
					<button type="button" class="quick-card quick-area">
						<div class="quick-icon area-icon">
							<i class="fa-solid fa-phone-volume"></i>
						</div>

						<div class="quick-text">
							<strong> 비상 연락망 </strong> <span> 비상 연락망 </span>
						</div>

						<i class="fa-solid fa-chevron-right quick-arrow"></i>
					</button>

					<!-- 비상연락망 팝업 모달 -->
					<div id="contactModal" class="custom-modal-overlay">
						<div class="custom-modal-content">
							<div class="modal-header-row">
								<h3>📞 비상 연락망</h3>
								<button type="button" class="modal-close-x"
									id="btnCloseContactModal">&times;</button>
							</div>
							<div class="modal-body-area">
								<ul id="contactListArea" class="contact-modal-list"></ul>
							</div>
							<div class="modal-footer-row">
								<button type="button" class="modal-confirm-btn"
									id="btnConfirmContactModal">확인</button>
							</div>
						</div>
					</div>


					<!-- 조치보고 -->
					<button type="button" class="quick-card quick-report">
						<div class="quick-icon report-icon">
							<i class="fa-solid fa-file-pen"></i>
						</div>

						<div class="quick-text">
							<strong> 조치 보고 </strong> <span> 안전조치 보고 </span>
						</div>

						<i class="fa-solid fa-chevron-right quick-arrow"></i>
					</button>
				</div>
			</section>



			<!-- 로그아웃 -->
			<section class="logout-section">
				<button type="button" class="logout-btn"
					onclick="location.href='${pageContext.request.contextPath}/logout'">
					<i class="fa-solid fa-right-from-bracket"></i> 로그아웃
				</button>
			</section>
		</main>


		<!-- 하단 메뉴바 -->

		<nav class="bottom-nav">
			<button type="button" class="nav-item nav-patrol" id="navPatrol">
				<i class="fa-solid fa-shield-halved"></i> <span> 안전순찰 </span>
			</button>


			<button type="button" class="nav-item active nav-home" id="navHome">
				<i class="fa-solid fa-house"></i> <span> 홈 </span>
			</button>

			<button type="button" class="nav-item nav-report" id="navReport">
				<i class="fa-solid fa-file-pen"></i> <span> 조치보고 </span>
			</button>
		</nav>
	</div>

	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script>
		window.contextPath = "${pageContext.request.contextPath}";
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/js/agent/agentMain.js"></script>

	<!-- 감지 알림(토스트 알림) -->
	<jsp:include page="/WEB-INF/views/common/agentAlarm.jsp" />

</body>
</html>