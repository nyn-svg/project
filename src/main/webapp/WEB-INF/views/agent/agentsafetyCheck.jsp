<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>사전 점검</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentsafetyCheck.css">
</head>

<body>

	<div class="safety-check-page">

		<!-- 상단 헤더 -->
		<header class="page-header">
			<button type="button" class="back-btn" onclick="history.back()">
				<i class="fa-solid fa-chevron-left"></i>
			</button>
			<h1>사전 점검</h1>
		</header>

		<!-- 점검 정보 -->
		<section class="inspection-info">
			<div class="info-title">
				<i class="fa-solid fa-clipboard-check"></i> <span>점검 개요</span>
			</div>

			<div class="info-row">
				<span class="info-label">행사명</span> 
				<span class="info-value">대전 유성온천문화축제</span>
			</div>

			<div class="info-row">
				<span class="info-label">점검 구역</span> 
				<span class="info-value">${empty sessionScope.workArea ? 'A구역(공연장 일대)' : sessionScope.workArea}</span>
			</div>

			<div class="info-row">
				<span class="info-label">점검자</span> 
				<span class="info-value">${empty sessionScope.userId ? 'agent01' : sessionScope.userId}</span>
			</div>
		</section>

		<!-- 체크리스트 폼 -->
		<form id="safetyCheckForm">
			<c:set var="currentCategory" value="" />

			<c:forEach var="item" items="${checklist}">
				<!-- 카테고리 구분 -->
				<c:if test="${currentCategory ne item.category}">
					<c:if test="${not empty currentCategory}">
						</div>
						</section>
					</c:if>

					<section class="check-section">
						<div class="section-title">
							<i class="fa-solid fa-list-check"></i> <span>${item.category}</span>
						</div>

						<div class="section-items">
						<c:set var="currentCategory" value="${item.category}" />
				</c:if>

				<!-- 개별 문항 카드 -->
				<div class="check-item" data-item-id="${item.itemId}">
					<div class="item-header">
						<span class="item-title">${item.itemTitle}</span>
						<p class="item-question">${item.question}</p>
					</div>

					<!-- 상태 선택 옵션 -->
					<div class="status-options">
						<label class="status-option"> 
							<input type="radio" name="check_${item.itemId}" value="NORMAL">
							<span>정상</span>
						</label> 
						<label class="status-option"> 
							<input type="radio" name="check_${item.itemId}" value="WARN">
							<span>주의</span>
						</label> 
						<label class="status-option"> 
							<input type="radio" name="check_${item.itemId}" value="DANGER">
							<span>위험</span>
						</label> 
						<label class="status-option"> 
							<input type="radio" name="check_${item.itemId}" value="NONE">
							<span>해당없음</span>
						</label>
					</div>

					<!-- 비고란 -->
					<div class="remark-box">
						<input type="text" class="remark-input" name="remark_${item.itemId}" placeholder="비고를 입력해주세요">
					</div>
				</div>
			</c:forEach>

			<c:if test="${not empty currentCategory}">
						</div>
					</section>
			</c:if>

			<!-- 제출 버튼 -->
			<div class="submit-area">
				<button type="submit" class="submit-btn">
					제출하기 <i class="fa-solid fa-chevron-right"></i>
				</button>
			</div>
		</form>
	</div>

	<!-- JS 전역 변수 선언 및 외부 JS 호출 -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script>
		const contextPath = "${pageContext.request.contextPath}";
	</script>
	<script src="${pageContext.request.contextPath}/resources/js/agent/agentsafetyCheck.js"></script>
	
</body>
</html>