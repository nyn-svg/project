<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이력 처리 안내</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/detection/detection-popup.css">
</head>
<body>
    <div class="popup-header">
    	<div class="popup-title">
			<i class="fa-solid fa-triangle-exclamation"></i>
			<span>이력 처리 안내</span>
		</div>
	</div>
	<div class="target-summary">
		<div class="summary-row">
			<span class="label">이력 번호</span>
			<span class="value text-skyblue">
				${situation.situNo}  
				<span class="badge type-badge">${situation.situType}</span>
			</span>
			
		</div>
		<div class="summary-row">
	        <span class="label">구역명 | 발견인</span>
	        <span class="value">${situation.zoneName} | ${situation.finder}</span>
	    </div>
	    <div class="summary-row">
	        <span class="label">위험 유형</span>
	        <span class="value text-orange">
	        	${situation.dngrType}  
	        	<c:choose>
					<c:when test="${situation.dngrLevel eq '관심'}">
						<span class="badge danger-interest">관심</span>
					</c:when>
					<c:when test="${situation.dngrLevel eq '주의'}">
						<span class="badge danger-attention">주의</span>
					</c:when>
					<c:when test="${situation.dngrLevel eq '경계'}">
						<span class="badge danger-caution">경계</span>
					</c:when>
					<c:when test="${situation.dngrLevel eq '심각'}">
						<span class="badge danger-severe">심각</span>
					</c:when>
					<c:otherwise>
						<span class="badge danger-unknown">${situation.dngrLevel != null ? situation.dngrLevel : '판단불가'}</span>
					</c:otherwise>
				</c:choose>
	        </span>
	    </div>
		<div class="summary-row">
			<span class="label">현재 상태</span>
			<span class="badge ${situation.situStatus eq '감지' ? 'status-pending' : 'status-in-progress'}">${situation.situStatus}</span>
		</div>
	</div>
	<div class="grid-container">
		<div class="info-box full-width">
			<strong>※ 필독 ※</strong>
	        <c:choose>
	            <c:when test="${situation.situStatus eq '감지'}">
	                <p class="text-warning">
	                	본 이력은 현재 <span class="badge status-pending">${situation.situStatus}</span> 단계입니다.<br>
	                	아래의 확인 버튼 클릭 시, <strong class="text-red">영구 삭제</strong>되며 복구할 수 없습니다.
	                </p>
	            </c:when>
	            <c:when test="${situation.situStatus eq '조치'}">
	                <p class="text-info">
	                	본 이력은 현재 <span class="badge status-in-progress">${situation.situStatus}</span> 단계입니다.
	                	<span class="badge status-in-progress">조치</span> 단계로 넘어간 이력은 삭제할 수 없습니다.<br>
	                	따라서 아래의 확인 버튼 클릭 시, <span class="badge status-canceled">취소</span> 상태로 변경 처리됩니다.
	                </p>
	            </c:when>
	        </c:choose>
        </div>
	</div>
	<form action="${pageContext.request.contextPath}/detection/remove" method="post">
		<input type="hidden" name="situNo" value="${situation.situNo}">
		<input type="hidden" name="situStatus" value="${situation.situStatus}">
		
		<div class="btn-group">
            <button type="submit" class="btn btn-danger">확인</button>
            <button type="button" class="btn" onclick="window.close()">취소</button>
		</div>
	</form>
</body>
</html>