<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 1. 실제 본문이 들어있는 'mainContent.jsp' 경로를 변수로 전달 -->
<c:set var="contentPage" value="/WEB-INF/views/mainContent.jsp" scope="request" />

<!-- 2. 레이아웃 템플릿 실행 -->
<jsp:include page="/WEB-INF/views/layout/mainLayout.jsp" />