<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>감지 이력 등록 실패</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Pretendard', -apple-system, sans-serif; }
        body { display: flex; align-items: center; justify-content: center; min-height: 100vh; background-color: #f4f6f9; }
        .card { background: #ffffff; padding: 40px 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); text-align: center; max-width: 420px; width: 90%; }
        .icon { width: 64px; height: 64px; background-color: #fce8e6; color: #d93025; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; margin: 0 auto 20px; font-weight: bold; }
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
        <div class="icon">!</div>
        <h2>등록 실패</h2>
        <p> 처리 중 오류가 발생했습니다.<br>잠시 후 다시 시도해 주세요.</p>
        
        <div class="btn-group">
            <button type="button" class="btn" onclick="window.close()">창닫기</button>
        </div>
    </div>
</body>
</html>