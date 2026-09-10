<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>사전 점검 완료</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentsafetyCheckComplete.css">
</head>

<body>

	<div class="complete-page">

		<!-- 상단 헤더 -->
		<header class="page-header">
			<button type="button" class="back-btn" onclick="history.back()">
				<i class="fa-solid fa-chevron-left"></i>
			</button>
			<h1>사전 점검 완료</h1>
		</header>

		<!-- 메인 콘텐츠 영역 -->
		<main class="content-body">
			<!-- 체크 아이콘 -->
			<div class="check-icon-wrapper">
				<div class="check-icon-circle">
					<i class="fa-solid fa-check"></i>
				</div>
			</div>

			<!-- 안내 메시지 -->
			<div class="message-area">
				<h2>사전 점검이 완료되었습니다.</h2>
				<p class="sub-text">
					총 <span class="highlight-total">${empty totalCount ? 8 : totalCount}개</span> 항목 중 
					<span class="highlight-done">${empty normalCount ? 7 : normalCount}개</span> 확인 완료<br>
					<span class="highlight-warn">${empty warnCount ? 1 : warnCount}개</span> 항목은 보완이 필요합니다.
				</p>
			</div>

			<!-- 점검 결과 요약 카드 -->
			<section class="result-card">
				<h3 class="card-title">점검 결과</h3>

				<div class="result-list">
					<!-- 정상 -->
					<div class="result-item">
						<div class="item-label">
							<span class="status-icon icon-normal">
								<i class="fa-solid fa-check"></i>
							</span>
							<span class="status-text">정상</span>
						</div>
						<span class="status-count count-normal">${empty normalCount ? 7 : normalCount}개</span>
					</div>

					<!-- 보완 필요 (주의/위험) -->
					<div class="result-item">
						<div class="item-label">
							<span class="status-icon icon-warn">
								<i class="fa-solid fa-triangle-exclamation"></i>
							</span>
							<span class="status-text">보완 필요</span>
						</div>
						<span class="status-count count-warn">${empty warnCount ? 1 : warnCount}개</span>
					</div>
				</div>
			</section>
		</main>

		<!-- 하단 버튼 영역 -->
		<footer class="bottom-action-area">
			<button type="button" class="btn-secondary" onclick="history.back()">수정하기</button>
			<button type="button" class="btn-primary" onclick="location.href='${pageContext.request.contextPath}/agent/main'">
				홈으로 이동
			</button>
		</footer>

	</div>

</body>
</html>