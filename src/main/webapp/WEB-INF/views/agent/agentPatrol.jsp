<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>안전순찰</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/agent/agentPatrol.css">
</head>
<body>

	<div class="mobile-container">
		<!-- 헤더 -->
		<header class="mobile-header">
			<h1>안전순찰</h1>
			<div class="header-right-empty"></div>
		</header>

		<!-- 메인 콘텐츠 -->
		<main class="mobile-content">
			<!-- 사전 점검 메인 카드 -->
			<section class="action-card-section">
				<button type="button" class="main-action-card" id="btnPreCheck">
					<div class="card-icon-wrap">
						<i class="fa-solid fa-shield-halved"></i>
					</div>
					<div class="card-info">
						<strong>사전 점검</strong>
						<p>
							행사장 안전을 위해<br>체크리스트를 작성해 주세요.
						</p>
					</div>
					<i class="fa-solid fa-chevron-right card-arrow"></i>
				</button>
			</section>

			<!-- 오늘 점검 현황 -->
			<section class="status-section">
				<h2 class="section-label">오늘 점검 현황</h2>

				<!-- 1. 오전 점검 (09:00 - 16:00) -->
				<div class="status-card">
					<div class="status-icon sun-icon">
						<i class="fa-solid fa-sun"></i>
					</div>
					<div class="status-info">
						<div class="status-title">
							<strong>오전 점검</strong> <span>(1교대)</span>
						</div>
						<span class="status-time">09:00 - 16:00</span>
					</div>

					<div class="status-meta">
						<c:set var="amDone" value="false" />
						<c:forEach var="item" items="${todayList}">
							<c:if
								test="${not amDone and item.CHECK_TIME >= '09:00' and item.CHECK_TIME < '16:00'}">
								<span class="badge badge-success">완료</span>
								<span class="user-name">${item.USER_ID}</span>
								<span class="created-at">${item.FULL_DATE}</span>
								<c:set var="amDone" value="true" />
							</c:if>
						</c:forEach>

						<c:if test="${not amDone}">
							<span class="badge badge-default">미등록</span>
							<span class="created-at">-</span>
						</c:if>
					</div>
				</div>

				<!-- 2. 오후 점검 (16:00 - 22:00) -->
				<div class="status-card">
					<div class="status-icon moon-icon">
						<i class="fa-solid fa-moon"></i>
					</div>
					<div class="status-info">
						<div class="status-title">
							<strong>오후 점검</strong> <span>(2교대)</span>
						</div>
						<span class="status-time">16:00 - 22:00</span>
					</div>

					<div class="status-meta">
						<c:set var="pmDone" value="false" />
						<c:forEach var="item" items="${todayList}">
							<c:if
								test="${not pmDone and item.CHECK_TIME >= '16:00' and item.CHECK_TIME <= '22:00'}">
								<span class="badge badge-success">완료</span>
								<span class="user-name">${item.USER_ID}</span>
								<span class="created-at">${item.FULL_DATE}</span>
								<c:set var="pmDone" value="true" />
							</c:if>
						</c:forEach>

						<c:if test="${not pmDone}">
							<span class="badge badge-default">미등록</span>
							<span class="created-at">-</span>
						</c:if>
					</div>
				</div>
			</section>

			<!-- 하단 안내 박스 -->
			<div class="info-notice-box">
				<i class="fa-solid fa-circle-info info-icon"></i>
				<p>
					마지막으로 등록된 점검 결과가<br>관리자에게 실시간으로 전송됩니다.
				</p>
			</div>
		</main>

		<!-- 고정 하단 메뉴바 -->
		<nav class="bottom-nav">
			<button type="button" class="nav-item active nav-patrol"
				id="navPatrol">
				<i class="fa-solid fa-shield-halved"></i> <span> 안전순찰 </span>
			</button>

			<button type="button" class="nav-item nav-home" id="navHome">
				<i class="fa-solid fa-house"></i> <span> 홈 </span>
			</button>

			<button type="button" class="nav-item nav-report" id="navReport">
				<i class="fa-solid fa-file-pen"></i> <span> 조치보고 </span>
			</button>
		</nav>
	</div>

	<!-- JS 스크립트 -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/agent/agentPatrol.js"></script>

	<!-- 감지 알림(토스트 알림) -->
	<jsp:include page="/WEB-INF/views/common/agentAlarm.jsp" />

</body>
</html>