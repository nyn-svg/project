<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 1. 본문에 들어갈 드론 관제 실체 화면(droneStreamContent.jsp) 경로 설정 -->
<c:set var="contentPage" value="/WEB-INF/views/drone/droneStreamContent.jsp" scope="request" />

<!-- 2. 공통 레이아웃 호출 (헤더, 푸터, 사이드바 자동 조립) -->
<jsp:include page="/WEB-INF/views/layout/mainLayout.jsp" />