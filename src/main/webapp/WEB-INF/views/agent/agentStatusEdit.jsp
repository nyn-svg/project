<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>근무 상태 변경</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentMain.css">
    
    <style>
        .sub-header {
            background-color: #0c4a6e;
            color: #ffffff;
            height: 56px;
            padding: 0 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .sub-header .btn-back {
            position: absolute;
            left: 16px;
            color: #ffffff;
            text-decoration: none;
            font-size: 1.2rem;
        }

        .sub-header .header-title {
            font-size: 1.05rem;
            font-weight: 700;
        }

        .page-guide {
            font-size: 0.95rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 12px;
        }

        .status-option-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        /* Radio Card Label Style */
        .status-option-card {
            display: flex;
            align-items: center;
            gap: 14px;
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 16px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .status-option-card input[type="radio"] {
            display: none;
        }

        .custom-radio {
            width: 22px;
            height: 22px;
            border: 2px solid #cbd5e1;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .custom-radio::after {
            content: '';
            width: 10px;
            height: 10px;
            background-color: #0284c7;
            border-radius: 50%;
            display: none;
        }

        .status-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .status-title {
            font-size: 0.95rem;
            font-weight: 700;
            color: #334155;
        }

        .status-desc {
            font-size: 0.8rem;
            color: #64748b;
        }

        /* Checked State Style */
        .status-option-card:has(input[type="radio"]:checked) {
            border: 1.5px solid #16a34a;
            background-color: #f0fdf4;
        }

        .status-option-card input[type="radio"]:checked + .custom-radio {
            border-color: #16a34a;
            background-color: #16a34a;
        }

        .status-option-card input[type="radio"]:checked + .custom-radio::after {
            display: block;
            background-color: #ffffff;
        }

        .status-option-card:has(input[type="radio"]:checked) .status-title {
            color: #15803d;
        }

        /* Action Buttons */
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 24px;
        }

        .btn-cancel {
            flex: 1;
            padding: 14px 0;
            background-color: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            color: #475569;
            font-size: 0.95rem;
            font-weight: 700;
            text-align: center;
            text-decoration: none;
        }

        .btn-submit {
            flex: 1;
            padding: 14px 0;
            background-color: #0284c7;
            border: none;
            border-radius: 10px;
            color: #ffffff;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <div class="mobile-container">
        <!-- 상단 헤더 -->
        <header class="sub-header">
            <a href="javascript:history.back()" class="btn-back">
                <i class="fa-solid fa-chevron-left"></i>
            </a>
            <span class="header-title">근무 상태 변경</span>
        </header>

        <!-- 메인 컨텐츠 -->
        <main class="mobile-content">
            <p class="page-guide">현재 근무 상태를 선택해주세요.</p>

            <form action="${pageContext.request.contextPath}/agent/status/edit" method="post">
                <div class="status-option-list">
                    
                    <!-- 1. 근무중 -->
                    <label class="status-option-card">
                        <input type="radio" name="workStatus" value="근무중" ${user.workStatus eq '근무중' or empty user.workStatus ? 'checked' : ''}>
                        <span class="custom-radio"></span>
                        <div class="status-info">
                            <span class="status-title">근무중</span>
                            <span class="status-desc">정상적으로 근무를 수행 중입니다.</span>
                        </div>
                    </label>

                    <!-- 2. 휴식중 -->
                    <label class="status-option-card">
                        <input type="radio" name="workStatus" value="휴식중" ${user.workStatus eq '휴식중' ? 'checked' : ''}>
                        <span class="custom-radio"></span>
                        <div class="status-info">
                            <span class="status-title">휴식중</span>
                            <span class="status-desc">잠시 휴식을 취하고 있습니다.</span>
                        </div>
                    </label>

                    <!-- 3. 외출중 -->
                    <label class="status-option-card">
                        <input type="radio" name="workStatus" value="외출중" ${user.workStatus eq '외출중' ? 'checked' : ''}>
                        <span class="custom-radio"></span>
                        <div class="status-info">
                            <span class="status-title">외출중</span>
                            <span class="status-desc">외부 업무로 자리를 비웠습니다.</span>
                        </div>
                    </label>

                    <!-- 4. 퇴근 -->
                    <label class="status-option-card">
                        <input type="radio" name="workStatus" value="퇴근" ${user.workStatus eq '퇴근' ? 'checked' : ''}>
                        <span class="custom-radio"></span>
                        <div class="status-info">
                            <span class="status-title">퇴근</span>
                            <span class="status-desc">오늘 일과를 마치고 퇴근했습니다.</span>
                        </div>
                    </label>

                </div>

                <!-- 하단 버튼 -->
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/agent/info" class="btn-cancel">취소</a>
                    <button type="submit" class="btn-submit">변경</button>
                </div>
            </form>
        </main>
    </div>

</body>
</html>