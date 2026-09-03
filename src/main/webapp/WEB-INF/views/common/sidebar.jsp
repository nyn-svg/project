<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="hasRole('ROLE_ADMIN')">
    <jsp:include page="/WEB-INF/views/common/adminSidebarPanel.jsp" />
</sec:authorize>

<sec:authorize access="hasRole('ROLE_CONTROL')">
    <jsp:include page="/WEB-INF/views/common/controlSidebarPanel.jsp" />
</sec:authorize>