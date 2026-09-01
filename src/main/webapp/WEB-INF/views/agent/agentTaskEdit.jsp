<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>업무 수정</title>
    <!-- FontAwesome 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 커스텀 CSS (기존 스타일 재사용 및 공유) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentTaskRegister.css">
</head>
<body>

    <div class="mobile-container">
        <!-- 상단 헤더 -->
        <header class="mobile-header">
            <button type="button" class="btn-back" onclick="history.back()">
                <i class="fa-solid fa-chevron-left"></i>
            </button>
            <h1 class="header-title">업무 수정</h1>
            <div class="header-dummy"></div>
        </header>

        <!-- 메인 콘텐츠 -->
        <main class="mobile-content">
            <form id="taskUpdateForm" class="task-form">
                
                <!-- 업무 유형 -->
                <div class="form-row">
                    <label class="form-label" for="taskType">업무 유형</label>
                    <select id="taskType" class="form-select">
                        <option value="PATROL" selected>순찰</option>
                        <option value="INSPECTION">점검</option>
                        <option value="SUPPORT">지원</option>
                        <option value="OTHER">기타</option>
                    </select>
                </div>

                <!-- 담당 구역 -->
                <div class="form-row">
                    <label class="form-label" for="taskArea">담당 구역</label>
                    <select id="taskArea" class="form-select">
                        <option value="A">A구역</option>
                        <option value="B" selected>B구역</option>
                        <option value="C">C구역</option>
                        <option value="D">D구역</option>
                    </select>
                </div>

                <!-- 업무 제목 -->
                <div class="form-row">
                    <label class="form-label" for="taskTitle">업무 제목</label>
                    <input type="text" id="taskTitle" class="form-input" value="B구역 순찰" placeholder="업무 제목을 입력하세요.">
                </div>

                <!-- 업무 내용 -->
                <div class="form-row vertical">
                    <label class="form-label" for="taskContent">업무 내용</label>
                    <div class="textarea-wrapper">
                        <textarea id="taskContent" class="form-textarea" maxlength="300" placeholder="업무 내용을 상세히 입력해주세요.">B구역 행사장 주변 순찰 및 안전 확인</textarea>
                        <span class="char-count"><span id="charCount">0</span>/300</span>
                    </div>
                </div>

                <!-- [신규 추가] 조치 상태 -->
                <div class="form-row">
                    <label class="form-label" for="actionStatus">조치 상태</label>
                    <select id="actionStatus" class="form-select">
                        <option value="COMPLETED">조치완료</option>
                        <option value="IN_PROGRESS" selected>조치중</option>
                        <option value="PENDING_CLOSED">미조치 종결</option>
                    </select>
                </div>

                <!-- 업무 시작 시간 -->
                <div class="form-row">
                    <label class="form-label" for="startTime">업무 시작 시간</label>
                    <div class="date-input-wrapper">
                        <input type="text" id="startTime" class="form-input" value="2026-05-20 11:00">
                        <i class="fa-regular fa-calendar calendar-icon"></i>
                    </div>
                </div>

                <!-- 업무 종료 시간 -->
                <div class="form-row">
                    <label class="form-label" for="endTime">업무 종료 시간</label>
                    <div class="date-input-wrapper">
                        <input type="text" id="endTime" class="form-input" value="2026-05-20 12:00">
                        <i class="fa-regular fa-calendar calendar-icon"></i>
                    </div>
                </div>

                <!-- 참고 사항 (선택) -->
                <div class="form-row vertical">
                    <label class="form-label" for="taskNote">참고 사항 (선택)</label>
                    <textarea id="taskNote" class="form-textarea short" placeholder="참고 사항을 입력하세요.">특이사항 없음</textarea>
                </div>

                <!-- 하단 버튼 그룹 -->
                <div class="form-btn-group">
                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                    <button type="submit" class="btn-submit">수정</button>
                </div>

            </form>
        </main>
    </div>

    <!-- 스크립트 영역 -->
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // 업무 내용 글자 수 초기화 및 카운트
        var taskContent = document.getElementById('taskContent');
        var charCount = document.getElementById('charCount');
        
        if (taskContent && charCount) {
            // 기존 텍스트 길이 초기 반영
            charCount.innerText = taskContent.value.length;
            
            taskContent.addEventListener('input', function() {
                charCount.innerText = this.value.length;
            });
        }

        // 폼 제출 시 수정 완료 처리
        var taskUpdateForm = document.getElementById('taskUpdateForm');
        if (taskUpdateForm) {
            taskUpdateForm.addEventListener('submit', function(e) {
                e.preventDefault();
                alert('업무가 성공적으로 수정되었습니다.');
                location.href = '${pageContext.request.contextPath}/agent/history';
            });
        }
    });
    </script>

</body>
</html>