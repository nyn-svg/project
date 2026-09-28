<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
    alert("${errorMessage != null ? errorMessage : '잘못된 접근입니다.'}");
    <c:if test="${closeWindow}">
        window.close();
    </c:if>
</script>