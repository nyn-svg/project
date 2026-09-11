<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>보고 수정</title>
<!-- FontAwesome 아이콘 -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- 커스텀 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/agent/agentTaskEdit.css">
</head>
<body>

	<div class="mobile-container">
		<!-- 상단 헤더 -->
		<header class="mobile-header">
			<button type="button" class="btn-back" onclick="history.back()">
				<i class="fa-solid fa-chevron-left"></i>
			</button>
			<h1 class="header-title">보고 수정</h1>
			<div class="header-dummy"></div>
		</header>

		<!-- 메인 콘텐츠 -->
		<main class="mobile-content">
			<!-- 💡 action과 method 지정 -->
			<form id="taskUpdateForm" class="task-form"
				action="${pageContext.request.contextPath}/agent/taskEdit"
				method="post">

				<!-- 💡 [필수] 수정 대상 PK (taskId) hidden 전송 -->
				<input type="hidden" name="taskId" value="${task.taskId}">

				<!-- 업무 유형 -->
				<div class="form-row">
					<label class="form-label" for="taskType">조치 유형</label> <select
						id="taskType" name="taskType" class="form-select">
						<option value="순찰" ${task.taskType == '순찰' ? 'selected' : ''}>순찰</option>
						<option value="점검" ${task.taskType == '점검' ? 'selected' : ''}>점검</option>
						<option value="지원" ${task.taskType == '지원' ? 'selected' : ''}>지원</option>
						<option value="기타" ${task.taskType == '기타' ? 'selected' : ''}>기타</option>
					</select>
				</div>
				<!-- 담당 구역 -->
				<div class="form-row">
					<label class="form-label" for="taskArea">담당 구역</label> <select
						id="taskArea" name="taskArea" class="form-select">
						<option value="A" ${task.taskArea == 'A' ? 'selected' : ''}>A구역</option>
						<option value="B" ${task.taskArea == 'B' ? 'selected' : ''}>B구역</option>
						<option value="C" ${task.taskArea == 'C' ? 'selected' : ''}>C구역</option>
						<option value="D" ${task.taskArea == 'D' ? 'selected' : ''}>D구역</option>
					</select>
				</div>

				<!-- 업무 제목 -->
				<div class="form-row">
					<label class="form-label" for="taskTitle">조치 제목</label> <input
						type="text" id="taskTitle" name="taskTitle" class="form-input"
						value="${task.taskTitle}" placeholder="업무 제목을 입력하세요.">
				</div>

				<!-- 업무 내용 -->
				<div class="form-row vertical">
					<label class="form-label" for="taskContent">조치 내용</label>
					<div class="textarea-wrapper">
						<textarea id="taskContent" name="taskContent"
							class="form-textarea" maxlength="300"
							placeholder="업무 내용을 상세히 입력해주세요.">${task.taskContent}</textarea>
						<span class="char-count"><span id="charCount">0</span>/300</span>
					</div>
				</div>

				<!-- 조치 상태 -->
				<div class="form-row">
					<label class="form-label" for="actionStatus">조치 상태</label> <select
						id="actionStatus" name="actionStatus" class="form-select">
						<option value="COMPLETED"
							${task.actionStatus == 'COMPLETED' ? 'selected' : ''}>조치완료</option>
						<option value="IN_PROGRESS"
							${task.actionStatus == 'IN_PROGRESS' ? 'selected' : ''}>조치중</option>
						<option value="PENDING_CLOSED"
							${task.actionStatus == 'PENDING_CLOSED' ? 'selected' : ''}>미조치
							종결</option>
					</select>
				</div>

				<!-- 업무 시작 시간 -->
				<div class="form-row">
					<label class="form-label" for="startTime">사건 발생 시간</label>
					<div class="date-input-wrapper">
						<input type="datetime-local" id="startTime" name="startTime"
							class="form-input"
							value="${fn:replace(task.startTime, ' ', 'T')}">
					</div>
				</div>

				<!-- 업무 종료 시간 -->
				<div class="form-row">
					<label class="form-label" for="endTime">사건 종료 시간</label>
					<div class="date-input-wrapper">
						<input type="datetime-local" id="endTime" name="endTime"
							class="form-input" value="${fn:replace(task.endTime, ' ', 'T')}">
					</div>
				</div>

				<!-- 참고 사항 (선택) -->
				<div class="form-row vertical">
					<label class="form-label" for="taskNote">참고 사항 (선택)</label>
					<textarea id="taskNote" name="taskNote" class="form-textarea short"
						placeholder="참고 사항을 입력하세요.">${task.taskNote}</textarea>
				</div>

				<!-- 하단 버튼 그룹 -->
				<div class="form-btn-group">
					<button type="button" class="btn-cancel" onclick="history.back()">취소</button>
					<button type="submit" class="btn-submit">수정</button>
				</div>

			</form>
		</main>
	</div>
	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script>
		const contextPath = "${pageContext.request.contextPath}";
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/js/agent/agentTaskEdit.js"></script>

</body>
</html>