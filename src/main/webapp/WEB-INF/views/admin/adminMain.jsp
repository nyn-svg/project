<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 1. 메인 컨테이너에 들어갈 관리자 콘텐츠 JSP 지정 -->
<c:set var="contentPage" value="/WEB-INF/views/admin/adminMainContent.jsp" scope="request" />

<!-- 2. 전체 레이아웃 껍데기 불러오기 -->
<jsp:include page="/WEB-INF/views/layout/mainLayout.jsp" />