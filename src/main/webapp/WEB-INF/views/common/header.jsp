<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- 관리자 권한일 때 --%>
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <jsp:include page="/WEB-INF/views/common/adminHeader.jsp" />
</sec:authorize>

<%-- 관제사 권한일 때 --%>
<sec:authorize access="hasRole('ROLE_CONTROL')">
    <jsp:include page="/WEB-INF/views/common/controlHeader.jsp" />
</sec:authorize>