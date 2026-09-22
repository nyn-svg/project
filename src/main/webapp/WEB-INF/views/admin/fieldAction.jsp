<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ContextPath JS 글로벌 변수 설정 -->
<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>

<!-- CSS 분리 파일 연결 -->
<link rel="stylesheet" href="<c:url value='/resources/css/admin/fieldAction.css'/>">

<div class="action-container">
   <div class="page-title"><i class="fa-solid fa-clipboard-check"></i> 현장 조치 승인 및 관리</div>

    <!-- 탭 상단 메뉴 -->
    <div class="tab-menu">
        <button class="tab-btn active" onclick="switchTab('pending')">
            미결 조치 검토 <span class="badge-count" id="pendingCount">0</span>
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
        <!-- 1. 미결 조치 검토 테이블 헤더 (총 8컬럼으로 변경) -->
        <thead>
            <tr>
                <th style="width: 15%;">요청ID</th>
                <th style="width: 10%;">위험유형</th> <!-- 💡 새로 추가됨 (dngrType) -->
                <th style="width: 10%;">감지유형</th> <!-- 💡 구역명 -> 감지유형 변경 (situType) -->
                <th style="width: 11%;">제출자</th>
                <th style="width: 24%;">조치 내용 Summary</th>
                <th style="width: 13%;">제출 일시</th>
                <th style="width: 8%;">상태</th>
                <th style="width: 9%;">검토 처리</th>
            </tr>
        </thead>
        <!-- JS 연동을 위한 id 부여 (colspan=8로 변경) -->
        <tbody id="pendingTbody">
            <tr>
                <td colspan="8" style="text-align:center;">데이터를 불러오는 중입니다...</td>
            </tr>
        </tbody>
    </table>
</div>

    <!-- 2. 완료 조치 이력 (아카이빙) 영역 -->
<div id="tab-history" class="content-card" style="display: none;">
    <div class="filter-bar">
        <div>
            <input type="text" placeholder="검색어 (위험유형, 감지유형, 안전요원명)" style="padding: 6px 12px; border: 1px solid rgba(255,255,255,0.2); background:#0f172a; color:#fff; border-radius: 4px;">
            <button class="btn btn-secondary">검색</button>
        </div>
        <span>최종 마감된 이력 데이터입니다.</span>
    </div>
    <table class="custom-table">
        <!-- 2. 완료 조치 이력 테이블 헤더 (총 8컬럼) -->
        <thead>
            <tr>
                <th style="width: 15%;">요청ID</th>
                <th style="width: 10%;">위험유형</th> <!-- 💡 새로 추가됨 (dngrType) -->
                <th style="width: 10%;">감지유형</th> <!-- 💡 구역명 -> 감지유형 변경 (situType) -->
                <th style="width: 10%;">제출자</th>
                <th style="width: 10%;">최종 처리상태</th>
                <th style="width: 18%;">승인/반려 일시</th>
                <th style="width: 17%;">처리자(관리자)</th>
                <th style="width: 10%;">상세보기</th>
            </tr>
        </thead>
        <!-- JS 연동을 위한 id 부여 (colspan=8로 변경) -->
        <tbody id="historyTbody">
            <tr>
                <td colspan="8" style="text-align:center;">데이터를 불러오는 중입니다...</td>
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
            <p><strong>요청 번호:</strong> <span id="mActionId">-</span></p>
            <p><strong>조치 요원:</strong> <span id="mWorkerInfo">-</span></p>
            <p><strong>조치 내용:</strong> <span id="mActionContent">-</span></p>

            <div style="margin-top: 15px;">
                <label style="display:block; font-weight:bold; margin-bottom:5px; color:#ffffff;">관리자 검토 의견 / 반려 사유</label>
                <textarea id="adminComment" style="width:100%; height:70px; border-radius:4px; padding:8px;" placeholder="승인 및 반려 시 의견을 적어주세요."></textarea>
            </div>
        </div>
        <div style="margin-top:20px; text-align:right; display:flex; justify-content:flex-end; gap:8px;">
            <button type="button" class="btn btn-danger" onclick="processAction('REJECT')">반려 처리</button>
            <button type="button" class="btn btn-success" onclick="processAction('APPROVE')">최종 승인</button>
            <button type="button" class="btn btn-secondary" onclick="closeModal()">닫기</button>
        </div>
    </div>
</div>

<!-- JS 분리 파일 연결 -->
<script src="<c:url value='/resources/js/admin/fieldAction.js'/>"></script>