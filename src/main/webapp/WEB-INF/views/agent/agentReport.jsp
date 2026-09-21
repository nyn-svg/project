<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>알림 보관함</title>
<!-- FontAwesome 아이콘 -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<!-- 커스텀 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/agent/agentReport.css">
</head>
<body>

	<div class="header-bar">
		<a href="javascript:history.back()" class="back-btn"> <i
			class="fa-solid fa-chevron-left"></i>
		</a>
		<div class="header-title">알림 보관함</div>
	</div>

	<div class="container" id="report-list-container"></div>

	<!-- JS -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script>
		window.contextPath = "${pageContext.request.contextPath}";
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/js/agent/agentReport.js"></script>

</body>
</html>