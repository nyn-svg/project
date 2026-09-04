<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>분야별 안전점검 체크리스트</title>
    <!-- Font Awesome (아이콘용) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 전용 CSS 파일 연결 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/safetyCheck.css">
</head>
<body class="admin-safety-body">

    <%-- 관리자 헤더/상단바가 있다면 include 해주세요 --%>
    <%-- <%@ include file="/WEB-INF/views/includes/header.jsp" %> --%>

    <div class="safety-container">
        
        <!-- 1. 페이지 타이틀 영역 -->
        <div class="page-header">
            <div>
                <h2 class="page-title">분야별 안전점검 체크리스트</h2>
                <p class="page-subtitle">행정안전부 지침 기반</p>
            </div>
            
            <!-- 우측 상단 전체 점검 요약 대시보드 -->
            <div class="summary-dashboard">
                <div class="summary-label">전체 점검 요약</div>
                <div class="summary-cards">
                    <div class="card">
                        <span class="card-title">전체 항목</span>
                        <span class="card-value" id="count-total">20</span>
                    </div>
                    <div class="card">
                        <span class="card-title">점검 완료</span>
                        <span class="card-value" id="count-done">0</span>
                    </div>
                    <div class="card">
                        <span class="card-title"><i class="fa-solid fa-circle-check text-success"></i> 정상</span>
                        <span class="card-value text-success" id="count-normal">0</span>
                    </div>
                    <div class="card">
                        <span class="card-title"><i class="fa-solid fa-triangle-exclamation text-warning"></i> 주의</span>
                        <span class="card-value text-warning" id="count-warning">0</span>
                    </div>
                    <div class="card">
                        <span class="card-title"><i class="fa-solid fa-circle-xmark text-danger"></i> 위험</span>
                        <span class="card-value text-danger" id="count-danger">0</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. 점검 설정 필터 및 액션 버튼 영역 -->
        <div class="filter-bar">
            <div class="filter-group">
                <label for="checkDate">점검일자</label>
                <input type="date" id="checkDate" class="input-control" value="2025-09-01">

                <label for="checkRound">점검용</label>
                <select id="checkRound" class="select-control">
                    <option value="1">1차 점검 (10:00)</option>
                    <option value="2">2차 점검 (14:00)</option>
                    <option value="3">3차 점검 (18:00)</option>
                </select>

                <label for="inspector">점검자</label>
                <input type="text" id="inspector" class="input-control width-sm" value="김관리">
            </div>

            <div class="action-buttons">
                <button type="button" class="btn btn-primary" id="btn-save">
                    <i class="fa-solid fa-floppy-disk"></i> 점검결과 저장
                </button>
                <button type="button" class="btn btn-outline" id="btn-print">
                    <i class="fa-solid fa-print"></i> 출력 / PDF
                </button>
            </div>
        </div>

        <!-- 3. 체크리스트 테이블 영역 -->
        <div class="checklist-table-wrapper">
            <table class="checklist-table">
                <thead>
                    <tr>
                        <th class="col-category">분야 / 점검 항목</th>
                        <th class="col-status">정상</th>
                        <th class="col-status">주의</th>
                        <th class="col-status">위험</th>
                        <th class="col-status">해당없음</th>
                        <th class="col-remark">비고</th>
                    </tr>
                </thead>
                <tbody>
                    
                    <!-- 섹션 1: 인파 밀집 및 수송 관리 -->
					<tr class="section-header">
					    <td colspan="6">
					        <i class="fa-solid fa-users"></i> 1. 인파 밀집 및 수송 관리
					    </td>
					</tr>
					<tr>
					    <td class="item-text">• 비상 대피로 확보: 관람객 이동 동선 및 비상 대피로에 병목 현상이나 장애물이 없는가?</td>
					    <td class="text-center"><input type="radio" name="item_1" value="NORMAL" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_1" value="WARN" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_1" value="DANGER" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_1" value="NONE" class="radio-status"></td>
					    <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
					</tr>
					<tr>
					    <td class="item-text">• 안전요원 적정 배치: 주요 밀집 예상 구역(계단, 경사로, 연결 통로)에 안내 및 통제 인원이 배치되었는가?</td>
					    <td class="text-center"><input type="radio" name="item_2" value="NORMAL" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_2" value="WARN" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_2" value="DANGER" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_2" value="NONE" class="radio-status"></td>
					    <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
					</tr>
					
					<!-- 섹션 2: 시설물 및 무대 안전 -->
					<tr class="section-header">
					    <td colspan="6">
					        <i class="fa-solid fa-building-shield"></i> 2. 시설물 및 무대 안전
					    </td>
					</tr>
					<tr>
					    <td class="item-text">• 구조물 고정 상태: 무대 장치, 조명탑, 대형 스피커, 현수막(홍보물엔터) 등이 강풍에 견디도록 견고하게 고정되었는가?</td>
					    <td class="text-center"><input type="radio" name="item_3" value="NORMAL" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_3" value="WARN" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_3" value="DANGER" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_3" value="NONE" class="radio-status"></td>
					    <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
					</tr>
					
					<!-- 섹션 3: 가스 및 소방 안전 -->
					<tr class="section-header">
					    <td colspan="6">
					        <i class="fa-solid fa-fire-extinguisher"></i> 3. 가스 및 소방 안전 (특수 효과 포함)
					    </td>
					</tr>
					<tr>
					    <td class="item-text">• 소방 용수 및 장비: 화재 발생 시 사용할 소화기, 소화전이 눈에 띄는 곳에 배치되었고 작동하는가?</td>
					    <td class="text-center"><input type="radio" name="item_4" value="NORMAL" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_4" value="WARN" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_4" value="DANGER" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_4" value="NONE" class="radio-status"></td>
					    <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
					</tr>
					
					<!-- 섹션 4: 전기 안전 -->
					<tr class="section-header">
					    <td colspan="6">
					        <i class="fa-solid fa-bolt"></i> 4. 전기 안전 (CCTV 및 관제 장비 연동)
					    </td>
					</tr>
					<tr>
					    <td class="item-text">• 전선 및 배선 상태: 관람객 동선 상에 누출된 전선이 없으며 누전 차단기가 정상 동작하는가?</td>
					    <td class="text-center"><input type="radio" name="item_5" value="NORMAL" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_5" value="WARN" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_5" value="DANGER" class="radio-status"></td>
					    <td class="text-center"><input type="radio" name="item_5" value="NONE" class="radio-status"></td>
					    <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
					</tr>

                </tbody>
            </table>
        </div>

    </div>

	<!-- 전용 JS 호출 전 Context Path 선언 -->
    <script>
        const contextPath = "${pageContext.request.contextPath}";
    </script>
	<script src="${pageContext.request.contextPath}/resources/js/admin/safetyCheck.js?v=1.1"></script>
</body>
</html>