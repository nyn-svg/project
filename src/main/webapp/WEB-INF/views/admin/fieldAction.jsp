<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ContextPath JS 글로벌 변수 설정 -->
<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>

<!-- CSS 분리 파일 연결 -->
<link rel="stylesheet" href="<c:url value='/resources/css/admin/fieldAction.css'/>">

<div class="action-container">
    <div class="page-title">🛡️ 현장 조치 승인 및 관리</div>

    <!-- 탭 상단 메뉴 -->
    <div class="tab-menu">
        <button class="tab-btn active" onclick="switchTab('pending')">
            미결 조치 검토 <span class="badge-count" id="pendingCount">3</span>
        </button>
        <button class="tab-btn" onclick="switchTab('history')">
            완료 조치 이력 (아카이빙)
        </button>
    </div>

    <!-- 1. 미결 조치 검토 영역 -->
    <div id="tab-pending" class="content-card">
        <div class="filter-bar">
            <span>안전요원이 제출한 현장 조치 요청 건을 검토 후 승인/반려합니다.</span>
        </div>
        <table class="custom-table">
            <thead>
                <tr>
                    <th>요청ID</th>
                    <th>구역명</th>
                    <th>제출 안전요원</th>
                    <th>조치 내용 Summary</th>
                    <th>제출 일시</th>
                    <th>상태</th>
                    <th>검토 처리</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>ACT-1024</td>
                    <td>A구역 (메인무대)</td>
                    <td>김안전 요원</td>
                    <td>통로 밀집 인원 통제 및 안전펜스 재설치 완료</td>
                    <td>2026-09-11 16:30</td>
                    <td><span class="status-badge status-pending">검토 대기</span></td>
                    <td>
                        <button class="btn btn-primary" onclick="openDetailModal('ACT-1024')">상세 검토</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 2. 완료 조치 이력 (아카이빙) 영역 -->
    <div id="tab-history" class="content-card" style="display: none;">
        <div class="filter-bar">
            <div>
                <input type="text" placeholder="검색어 (구역, 안전요원명)" style="padding: 6px 12px; border: 1px solid rgba(255,255,255,0.2); background:#0f172a; color:#fff; border-radius: 4px;">
                <button class="btn btn-secondary">검색</button>
            </div>
            <span>최종 마감된 이력 데이터입니다.</span>
        </div>
        <table class="custom-table">
            <thead>
                <tr>
                    <th>요청ID</th>
                    <th>구역명</th>
                    <th>안전요원</th>
                    <th>최종 처리상태</th>
                    <th>승인/반려 일시</th>
                    <th>처리자(관리자)</th>
                    <th>상세보기</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>ACT-1011</td>
                    <td>B구역 (먹거리장터)</td>
                    <td>이철수 요원</td>
                    <td><span class="status-badge status-approved">조치 승인</span></td>
                    <td>2026-09-10 14:20</td>
                    <td>최관리 팀장</td>
                    <td>
                        <button class="btn btn-secondary" onclick="openDetailModal('ACT-1011')">이력 조회</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<!-- 상세 보기 및 승인/반려 모달 -->
<div id="actionDetailModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <h3 style="margin:0;" id="modalTitle">현장 조치 상세 검토</h3>
            <button style="background:none; border:none; color:#fff; font-size:20px; cursor:pointer;" onclick="closeModal()">&times;</button>
        </div>
        <div class="modal-body">
            <p><strong>요청 번호:</strong> <span id="mActionId">ACT-1024</span></p>
            <p><strong>조치 요원:</strong> <span id="mWorkerInfo">김안전 (010-1234-5678)</span></p>
            <p><strong>조치 내용:</strong> <span id="mActionContent">메인무대 입구 병목 현상 해소를 위해 라인 테이프 설치 및 인원 우회 유도함.</span></p>

            <div style="margin-top: 15px;">
                <label style="display:block; font-weight:bold; margin-bottom:5px; color:#ffffff;">관리자 검토 의견 / 반려 사유</label>
                <textarea id="adminComment" style="width:100%; height:70px; border-radius:4px; padding:8px;" placeholder="승인 및 반려 시 의견을 적어주세요."></textarea>
            </div>
        </div>
        <div style="margin-top:20px; text-align:right; display:flex; justify-content:flex-end; gap:8px;">
            <button class="btn btn-danger" onclick="processAction('REJECT')">반려 처리</button>
            <button class="btn btn-success" onclick="processAction('APPROVE')">최종 승인</button>
            <button class="btn btn-secondary" onclick="closeModal()">닫기</button>
        </div>
    </div>
</div>

<!-- JS 분리 파일 연결 -->
<script src="<c:url value='/resources/js/admin/fieldAction.js'/>"></script>