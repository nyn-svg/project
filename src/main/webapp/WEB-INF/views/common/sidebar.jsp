<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:choose>
    <%-- 관리자 --%>
    <c:when test="${sessionScope.role eq 'ROLE_ADMIN'}">
        <jsp:include page="/WEB-INF/views/common/adminSidebarPanel.jsp" />
    </c:when>
    <%-- 관제사 (기본값 포함) --%>
    <c:otherwise>
        <jsp:include page="/WEB-INF/views/common/controlSidebarPanel.jsp" />
    </c:otherwise>
</c:choose>