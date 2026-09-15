<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>조치 보고</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/agent/agentHistory.css">
</head>
<body>

	<div class="mobile-container">
		<!-- HEADER -->
		<header class="mobile-header">
			<button type="button" class="btn-back" onclick="history.back()">
				<i class="fa-solid fa-chevron-left"></i>
			</button>
			<h1 class="header-title">조치 보고</h1>
			<div class="header-dummy"></div>
		</header>

		<!-- MAIN CONTENT -->
		<main class="mobile-content">
			<!-- 1. 기존 .filter-card 삭제 후 아래 탭 메뉴바 추가 -->
			<div class="sub-menu-bar">
				<button type="button" class="tab-btn active" data-status="ALL">전체</button>
				<button type="button" class="tab-btn" data-status="PENDING">조치대기</button>
				<button type="button" class="tab-btn" data-status="COMPLETED">조치완료</button>
			</div>

			<!-- 2. 건수 헤더 -->
			<div class="list-count-header">
				<span class="count-text">총 <span class="count"
					id="totalCount">0</span>건
				</span>
			</div>

			<!-- 3. 카드 리스트 영역 -->
			<div class="history-list" id="historyList"></div>

			<div id="loading"
				style="display: none; text-align: center; padding: 15px; color: #888;">
				<i class="fa-solid fa-spinner fa-spin"></i> 로딩 중...
			</div>
		</main>

		<!-- 하단 메뉴바 -->
		<nav class="bottom-nav">
			<button type="button" class="nav-item nav-patrol" id="navPatrol">
				<i class="fa-solid fa-shield-halved"></i> <span>안전순찰</span>
			</button>
			<button type="button" class="nav-item nav-home" id="navHome">
				<i class="fa-solid fa-house"></i> <span>홈</span>
			</button>
			<button type="button" class="nav-item active nav-report"
				id="navReport">
				<i class="fa-solid fa-file-pen"></i> <span>조치보고</span>
			</button>
		</nav>
	</div>

	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script>
		const contextPath = "${pageContext.request.contextPath}";
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/js/agent/agentHistory.js"></script>

	<!-- 감지 알림(토스트 알림) -->
	<jsp:include page="/WEB-INF/views/common/agentAlarm.jsp" />
	
</body>
</html>