<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>등록 성공</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Pretendard', -apple-system, sans-serif; }
        body { display: flex; align-items: center; justify-content: center; min-height: 100vh; background-color: #f4f6f9; }
        .card { background: #ffffff; padding: 40px 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); text-align: center; max-width: 420px; width: 90%; }
        .icon { width: 64px; height: 64px; background-color: #e6f4ea; color: #1e8e3e; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; margin: 0 auto 20px; }
        h2 { font-size: 22px; color: #202124; margin-bottom: 10px; }
        p { font-size: 14px; color: #5f6368; margin-bottom: 30px; line-height: 1.5; }
        .btn-group { display: flex; gap: 10px; }
        .btn {
        	flex: 1;
        	padding: 12px 0;
        	border-radius: 6px;
        	text-decoration: none;
        	font-size: 14px;
        	font-weight: 600;
        	text-align: center;
        	transition: background-color 0.2s; 
			cursor: pointer;
			background: #334155;
			color: #f8fafc;
		}
		.btn:hover { background: #475569; }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon">✓</div>
        <h2>처리 완료</h2>
        <p>성공적으로 처리되었습니다.</p>
        
        <div class="btn-group">
            <button type="button" class="btn" onclick="window.close()">창닫기</button>
        </div>
    </div>
</body>
</html>