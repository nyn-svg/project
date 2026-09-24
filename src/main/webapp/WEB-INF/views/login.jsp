<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 - 행사장 안전관리 시스템</title>
    
    <!-- FontAwesome 아이콘 CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background-color: #0b132b;
            color: #ffffff;
            font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        /* 1. Vanta 3D 배경 레이어 */
        #vanta-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 1;
        }

        /* 2. 로그인 카드 패널 (투명도 증가 + 네온 은은한 빛) */
        .login-container {
            position: relative;
            z-index: 2;
            background: rgba(10, 18, 42, 0.45); /* 🎯 투명도를 높여 뒤쪽 Vanta 라인이 은은하게 투과됨 */
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            padding: 42px 36px;
            border-radius: 20px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.6),
                        inset 0 1px 0 rgba(255, 255, 255, 0.15),
                        0 0 30px rgba(56, 189, 248, 0.12); /* 은은한 헤일로 이펙트 */
            width: 360px;
            border: 1px solid rgba(56, 189, 248, 0.3);
            box-sizing: border-box;
        }

        /* 헤더 영역 */
        .brand-header {
            text-align: center;
            margin-bottom: 28px;
        }

        .brand-icon {
            font-size: 32px;
            color: #38bdf8;
            margin-bottom: 12px;
            filter: drop-shadow(0 0 10px rgba(56, 189, 248, 0.6));
        }

        h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            color: #f8fafc;
            letter-spacing: -0.5px;
        }

        .sub-title {
            font-size: 11px;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-top: 4px;
        }

        /* 3. 입력 폼 영역 & 아이콘 연동 */
        .input-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-size: 12.5px;
            color: #cbd5e1;
            font-weight: 600;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-wrapper i {
            position: absolute;
            left: 14px;
            color: #64748b;
            font-size: 14px;
            transition: color 0.25s ease;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px 14px 12px 40px; /* 아이콘 여백 */
            box-sizing: border-box;
            background-color: rgba(0, 0, 0, 0.35); /* 약간 어두운 반투명 */
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 10px;
            color: #ffffff;
            font-size: 14px;
            outline: none;
            transition: all 0.25s ease;
        }

        /* 크롬 자동완성 시 배경이 흰색으로 바뀌는 현상 방지 */
        input:-webkit-autofill,
        input:-webkit-autofill:hover,
        input:-webkit-autofill:focus {
            -webkit-text-fill-color: #ffffff;
            -webkit-box-shadow: 0 0 0px 1000px #0b132b inset;
            transition: background-color 5000s ease-in-out 0s;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #38bdf8;
            box-shadow: 0 0 15px rgba(56, 189, 248, 0.3);
            background-color: rgba(0, 0, 0, 0.5);
        }

        .input-wrapper:focus-within i {
            color: #38bdf8; /* 포커스 시 아이콘 빛남 */
        }

        /* 4. 관제 사이버 버튼 스타일 */
        button[type="submit"] {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #0284c7 0%, #2563eb 100%);
            border: 1px solid rgba(56, 189, 248, 0.4);
            border-radius: 10px;
            color: white;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 10px;
            box-shadow: 0 6px 20px rgba(2, 132, 199, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        button[type="submit"]:hover {
            background: linear-gradient(135deg, #0369a1 0%, #1d4ed8 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(56, 189, 248, 0.5);
            filter: brightness(1.1);
        }

        .error-msg {
            color: #f87171;
            font-size: 12.5px;
            text-align: center;
            margin-top: 16px;
            padding: 8px 12px;
            background: rgba(239, 68, 68, 0.12);
            border-radius: 8px;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }
    </style>
</head>
<body>

    <!-- Vanta 3D 배경 캔버스 -->
    <div id="vanta-bg"></div>

    <!-- 로그인 카드 -->
    <div class="login-container">
        <div class="brand-header">
            <div class="brand-icon">
            </div>
            <h2>행사장 안전관리 시스템</h2>
            <div class="sub-title">SMART SAFETY CONTROL CENTER</div>
        </div>
        
        <form action="${pageContext.request.contextPath}/loginProcess" method="post">
            <div class="input-group">
                <label>아이디</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-user"></i>
                    <input type="text" name="userId" placeholder="아이디 입력" required autocomplete="off" />
                </div>
            </div>
            
            <div class="input-group">
                <label>비밀번호</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" name="userPw" placeholder="비밀번호 입력" required />
                </div>
            </div>
            
            <button type="submit">
                <span>시스템 접속</span>
                <i class="fa-solid fa-arrow-right-to-bracket"></i>
            </button>
        </form>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error-msg">
                <i class="fa-solid fa-triangle-exclamation"></i> 아이디 또는 비밀번호가 올바르지 않습니다.
            </div>
        <% } %>
    </div>

    <!-- Vanta.js 및 Three.js 라이브러리 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vanta@latest/dist/vanta.net.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            VANTA.NET({
                el: "#vanta-bg",
                mouseControls: true,
                touchControls: true,
                gyroControls: false,
                minHeight: 200.00,
                minWidth: 200.00,
                scale: 1.00,
                scaleMobile: 1.00,
                color: 0x38bdf8,          // 선 색상 (네온 블루)
                backgroundColor: 0x060d1f, // 깊이감 있는 어두운 파란색
                points: 12.00,            // 포인트 밀도
                maxDistance: 20.00,
                spacing: 16.00
            });
        });
    </script>
</body>
</html>