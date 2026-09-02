<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 - 행사장 안전관리 시스템</title>
    <style>
        body {
            background-color: #0b132b;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background-color: #111c3a;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
            width: 360px;
            border: 1px solid #1f3a60;
        }
        h2 {
            margin-top: 0;
            margin-bottom: 24px;
            font-size: 22px;
            color: #ffffff;
            text-align: center;
        }
        .input-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            color: #94a3b8;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            box-sizing: border-box;
            background-color: #0b132b;
            border: 1px solid #233554;
            border-radius: 6px;
            color: #ffffff;
            font-size: 14px;
        }
        input[type="text"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: #3b82f6;
        }
        button[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #2563eb;
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 5px;
        }
        button[type="submit"]:hover {
            background-color: #1d4ed8;
        }
        .error-msg {
            color: #f87171;
            font-size: 13px;
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>로그인</h2>
        
        <form action="${pageContext.request.contextPath}/loginProcess" method="post">
            <div class="input-group">
                <label>아이디</label>
                <input type="text" name="userId" required />
            </div>
            <div class="input-group">
                <label>비밀번호</label>
                <input type="password" name="userPw" required />
            </div>
            <button type="submit">로그인</button>
        </form>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error-msg">아이디 또는 비밀번호가 올바르지 않습니다.</div>
        <% } %>
    </div>
</body>
</html>