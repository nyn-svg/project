<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 컨트롤러에서 contentPage를 넘겨받지 못한 경우(기본 진입)에만 기본 페이지 지정 -->
<c:if test="${empty contentPage}">
    <c:set var="contentPage" value="/WEB-INF/views/mainContent.jsp" scope="request" />
</c:if>

<!-- 전체 껍데기 레이아웃 불러오기 -->
<jsp:include page="/WEB-INF/views/layout/mainLayout.jsp" />