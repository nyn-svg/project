<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>조치 보고 수정</title>
<!-- FontAwesome 아이콘 CDN -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<!-- 커스텀 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/agent/agentTaskEdit.css">
</head>
<body>

	<div class="mobile-container">
		<header class="mobile-header">
			<button type="button" class="btn-back"
				onclick="location.href='${pageContext.request.contextPath}/agent/history'">
				<i class="fa-solid fa-chevron-left"></i>
			</button>
			<h1 class="header-title">조치 보고서 작성</h1>
			<div class="header-dummy"></div>
		</header>

		<main class="mobile-content">
			<div class="info-summary-card highlight-box">
				<div class="summary-title">
					<i class="fa-solid fa-circle-exclamation text-danger"></i> 상황 원본 상세
					정보
				</div>
				<div class="summary-grid">
					<div class="grid-item">
						<span class="label">감지 유형</span> <span
							class="value font-highlight">${not empty task.situType ? task.situType : '자동감지'}</span>
					</div>
					<div class="grid-item">
						<span class="label">위험 단계</span> <span
							class="value status-badge ${task.dngrLevel == '심각' ? 'lvl-danger' : task.dngrLevel == '경계' ? 'lvl-warning' : 'lvl-normal'}">
							${not empty task.dngrLevel ? task.dngrLevel : '주의'} </span>
					</div>
					<div class="grid-item">
						<span class="label">담당 기기</span> <span class="value">${not empty task.droneId ? task.droneId : '(없음)'}</span>
					</div>
					<div class="grid-item">
						<span class="label">최초 발견자</span> <span class="value font-dark">${not empty task.finder ? task.finder : '시스템 자동'}</span>
					</div>
				</div>
			</div>

			<!-- ✨ 1. 컨트롤러에 파일 스트림을 온전히 전송하도록 enctype 속성 추가 -->
			<form id="taskUpdateForm" class="task-form"
				action="${pageContext.request.contextPath}/agent/taskEdit"
				method="post" enctype="multipart/form-data">

				<!-- form 바로 첫줄에 situNo 히든 필드를 배치하여 유실을 원천 방지합니다. -->
				<input type="hidden" id="situNo" name="situNo"
					value="${task.situNo}">

				<div class="form-row text-view-row">
					<label class="form-label">위험 유형</label>
					<div class="readonly-box-text">${task.dngrType}</div>
				</div>

				<div class="form-row text-view-row">
					<label class="form-label">발견 구역</label>
					<div class="readonly-box-text">${task.zoneName}${fn:contains(task.zoneName, '구역') ? '' : '구역'}</div>
				</div>

				<div class="form-row vertical">
					<label class="form-label">상황 내용</label>
					<div class="readonly-textarea-box">${task.situContent}</div>
				</div>

				<div class="form-row vertical">
					<label class="form-label">현장 원본 사진 (시스템 감지)</label>
					<div class="image-preview-container">
						<c:choose>
							<c:when test="${not empty task.situImage}">
								<!-- ✨ 404 에러 방지: 관제사가 맞춰놓은 정적 업로드 루트 경로 매핑 적용 -->
								<img
									src="${pageContext.request.contextPath}/upload/${task.situImage}"
									alt="현장 원본 이미지" class="img-responsive-view"
									onerror="this.onerror=null; this.src='https://placehold.co';">
							</c:when>
							<c:otherwise>
								<div class="no-image-placeholder">
									<i class="fa-regular fa-image"></i> <span>등록된 현장 원본 사진이
										없습니다.</span>
								</div>
							</c:otherwise>
						</c:choose>
						
						<div id="imageModal" class="image-modal" onclick="closeImageModal()">
							<img id="modalTargetImg" src="" alt="확대 이미지">
						</div>
					</div>
				</div>

				<div class="form-row vertical">
					<label class="form-label" for="workContent">현장 조치 내용</label>
					<div class="textarea-wrapper">
						<textarea id="workContent" name="workContent"
							class="form-textarea" maxlength="300" required
							placeholder="현장에서 수행한 조치 사항을 상세히 입력해주세요.">${task.workContent}</textarea>
						<span class="char-count"><span id="charCount">0</span>/300</span>
					</div>
				</div>

				<!-- ✨ 2. CSS 스타일 시트 및 JS 파일의 id 스펙에 맞춰 누락되었던 [현장 조치 사진 첨부 단추 컴포넌트] 완벽 복구 -->
				<div class="form-row vertical">
					<label class="form-label">현장 조치 증빙 사진</label>
					<div class="file-upload-wrapper">
						<input type="file" id="uploadFile" name="photo"
							class="form-file-input" accept="image/*">
						<div class="file-custom-button">
							<i class="fa-solid fa-cloud-arrow-up"></i> 현장 조치 사진 첨부하기
						</div>
						<div id="fileNameDisplay" class="file-name-text">선택된 파일이
							없습니다.</div>
					</div>
				</div>

				<div class="form-row">
					<label class="form-label" for="situStatus">조치 상태</label> <select
						id="situStatus" name="situStatus" class="form-select">
						<option value="조치중"
							${task.situStatus == '조치' || task.situStatus == '조치중' ? 'selected' : ''}>조치중</option>
						<option value="조치완료"
							${task.situStatus == '완료' || task.situStatus == '조치완료' ? 'selected' : ''}>조치완료</option>
						<option value="미조치 종결"
							${task.situStatus == '미해결' || task.situStatus == '미조치 종결' ? 'selected' : ''}>미조치
							종결</option>
					</select>
				</div>

				<div class="form-row">
					<label class="form-label" for="startDateDisplay">조치 시작 시간</label>
					<div class="date-input-wrapper">
						<input type="text" id="startDateDisplay"
							class="form-input readonly-input" value="${customStartDate}"
							readonly
							style="background-color: #f1f5f9; color: #1e293b; font-weight: 700;">
					</div>
				</div>

				<div class="form-row">
					<label class="form-label" for="endDate">조치 완료 시간</label>
					<div class="date-input-wrapper">
						<input type="datetime-local" id="endDate" class="form-input"
							data-raw-date="${task.endDate}">
					</div>
				</div>

				<div class="form-btn-group">
					<button type="button" class="btn-cancel"
						onclick="location.href='${pageContext.request.contextPath}/agent/history'">취소</button>
					<button type="submit" class="btn-submit">제출</button>
				</div>

			</form>
		</main>
	</div>

	<!-- JS 라이브러리: 공식 CDN 안정적인 주소로 복구 -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/js/agent/agentTaskEdit.js"></script>

</body>
</html>
