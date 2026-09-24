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
            완료 조치 이력
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
                    <th style="width: 15%;">요청ID</th>
                    <th style="width: 10%;">위험유형</th>
                    <th style="width: 10%;">감지유형</th>
                    <th style="width: 11%;">제출자</th>
                    <th style="width: 24%;">조치 내용</th>
                    <th style="width: 13%;">제출 일시</th>
                    <th style="width: 8%;">상태</th>
                    <th style="width: 9%;">검토 처리</th>
                </tr>
            </thead>
            <tbody id="pendingTbody">
                <tr>
                    <td colspan="8" style="text-align:center;">데이터를 불러오는 중입니다...</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 2. 완료 조치 이력 (아카이빙) 영역 -->
    <div id="tab-history" class="content-card" style="display: none;">
        <!-- 🎯 상세 항목별 Select 검색 필터 바 -->
        <div class="filter-bar" style="flex-wrap: wrap; gap: 12px; margin-bottom: 20px;">
            <div class="filter-group" style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
                
                <!-- 1) 최종 처리상태 필터 -->
                <select id="historyStatusFilter" class="filter-select" style="padding: 8px 12px; border: 1px solid rgba(255,255,255,0.2); background:#0f172a; color:#fff; border-radius: 8px; font-size: 13px; outline: none;">
                    <option value="">전체 처리상태</option>
                    <option value="APPROVED">최종 승인</option>
                    <option value="REJECTED">반려 처리</option>
                </select>

                <!-- 2) 위험유형 필터 -->
                <select id="historyDngrFilter" class="filter-select" style="padding: 8px 12px; border: 1px solid rgba(255,255,255,0.2); background:#0f172a; color:#fff; border-radius: 8px; font-size: 13px; outline: none;">
                    <option value="">전체 위험유형</option>
                    <option value="인파위험">인파위험</option>
                    <option value="시설물위험">시설물위험</option>
                    <option value="화재위험">화재위험</option>
                    <option value="응급환자">응급환자</option>
                    <option value="기타">기타</option>
                </select>

                <!-- 3) 감지유형 필터 -->
                <select id="historySituFilter" class="filter-select" style="padding: 8px 12px; border: 1px solid rgba(255,255,255,0.2); background:#0f172a; color:#fff; border-radius: 8px; font-size: 13px; outline: none;">
                    <option value="">전체 감지유형</option>
                    <option value="AI_CCTV">AI CCTV</option>
                    <option value="DRONE">드론 감지</option>
                    <option value="PATROL">요원 순찰</option>
                    <option value="REPORT">시민 신고</option>
                </select>

                <!-- 4) 키워드 검색어 입력창 -->
                <input type="text" id="historyKeywordInput" placeholder="검색어 (제출자, 관리자, 조치내용)" style="padding: 8px 14px; border: 1px solid rgba(255,255,255,0.2); background:#0f172a; color:#fff; border-radius: 8px; font-size: 13px; min-width: 220px; outline: none;">

                <!-- 5) 검색 및 초기화 버튼 -->
                <button type="button" class="btn btn-secondary" onclick="resetHistoryFilter()" style="display: inline-flex; align-items: center; gap: 6px;">
                    <i class="fa-solid fa-rotate-right"></i> 초기화
                </button>
            </div>
            <span style="font-size: 12.5px; color: #94a3b8;">※ 마감된 이력 데이터 검색 영역입니다.</span>
        </div>

        <table class="custom-table">
            <thead>
                <tr>
                    <th style="width: 15%;">요청ID</th>
                    <th style="width: 10%;">위험유형</th>
                    <th style="width: 10%;">감지유형</th>
                    <th style="width: 10%;">제출자</th>
                    <th style="width: 10%;">최종 처리상태</th>
                    <th style="width: 18%;">승인/반려 일시</th>
                    <th style="width: 17%;">처리자(관리자)</th>
                    <th style="width: 10%;">상세보기</th>
                </tr>
            </thead>
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