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
            <button type="button" onclick="generateAiSituationReport()" style="width: auto !important; padding: 7px 13px; font-size: 12px; background: rgba(99, 102, 241, 0.12); border: 1px solid #6366f1; color: #a5b4fc; border-radius: 6px; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; white-space: nowrap; font-weight: 500;">
            <i class="fa-solid fa-robot" style="font-size: 11px;"></i> AI 사후 종합 보고서 생성
        </button>
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

            <!-- 🎯 [추가] 현장 첨부 사진 표시 영역 -->
            <div style="margin-top: 15px;">
                <p style="margin-bottom: 5px; color:#ffffff;"><strong>현장 첨부 사진:</strong></p>
                <div style="text-align: center; background: #1e293b; padding: 10px; border-radius: 6px; min-height: 100px; display: flex; align-items: center; justify-content: center; border: 1px solid #334155;">
                    <!-- 사진이 있을 때 노출되는 img 태그 -->
                    <img id="mActionImage" src="" alt="현장 사진" style="max-width: 100%; max-height: 250px; border-radius: 4px; display: none;" />
                    <!-- 사진이 없을 때 노출되는 안내 텍스트 -->
                    <span id="noImageText" style="color: #94a3b8; font-size: 13px;">첨부된 사진이 없습니다.</span>
                </div>
            </div>

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

<!-- 🎯 AI 사후 종합 보고서 모달 (메일 발송 폼 포함) -->
<div id="aiReportModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(5, 7, 15, 0.85); z-index: 99999; justify-content: center; align-items: center; backdrop-filter: blur(8px);">
    <div style="background: radial-gradient(circle at 0% 0%, #1a102f 0%, #0d1127 50%, #080914 100%); border: 1px solid rgba(147, 51, 234, 0.25); border-radius: 16px; width: 720px; max-width: 90%; max-height: 85vh; padding: 24px; color: #f1f5f9; box-shadow: 0 20px 50px rgba(0, 0, 0, 0.8), 0 0 30px rgba(126, 34, 206, 0.12); display: flex; flex-direction: column;">
        
        <!-- 헤더 -->
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.08); padding-bottom: 14px; margin-bottom: 16px;">
            <div style="display: flex; align-items: center; gap: 8px;">
                <span style="display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: #38bdf8; box-shadow: 0 0 10px #38bdf8;"></span>
                <h3 style="margin: 0; font-size: 16px; font-weight: 700; color: #e2e8f0;">🤖 AI 현장 조치 사후 종합 보고서</h3>
            </div>
            <button type="button" onclick="closeAiReportModal()" style="background: none; border: none; color: #64748b; font-size: 18px; cursor: pointer;">✕</button>
        </div>

        <!-- 본문 (보고서 내용 출력 영역) -->
        <div style="overflow-y: auto; flex: 1; padding-right: 6px;">
            <!-- 로딩 상태 표시 -->
            <div id="aiReportLoading" style="text-align: center; padding: 40px 0; display: none;">
                <i class="fa-solid fa-spinner fa-spin" style="font-size: 32px; color: #8b5cf6; margin-bottom: 15px;"></i>
                <p style="color: #cbd5e1; font-size: 14px; margin: 0;">SITUATIONS 이력 데이터를 분석하여 AI 종합 보고서를 생성 중입니다...</p>
            </div>

            <!-- 보고서 생성 결과 출력 -->
            <pre id="aiReportContent" style="white-space: pre-wrap; word-break: break-all; font-family: inherit; font-size: 13px; line-height: 1.6; color: #cbd5e1; margin: 0; background: rgba(0,0,0,0.2); padding: 16px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.05); display: none;"></pre>
        </div>

        <!-- 🎯 유관기관 이메일 발송 폼 (기본 숨김) -->
        <div id="emailFormArea" style="display: none; margin-top: 14px; background: rgba(15, 23, 42, 0.6); border: 1px solid rgba(147, 51, 234, 0.3); border-radius: 8px; padding: 12px; gap: 8px; align-items: center;">
            <select id="agencySelect" onchange="onSelectAgency(this.value)" style="background: #0f172a; color: #e2e8f0; border: 1px solid #334155; padding: 7px 10px; border-radius: 6px; font-size: 12px; outline: none; width: 170px;">
                <option value="">-- 유관기관 선택 --</option>
                <option value="police@police.go.kr">관할 경찰서 (경비과)</option>
                <option value="fire@korea.kr">119 종합상황실</option>
                <option value="city@gu.go.kr">구청 재난안전과</option>
                <option value="direct">직접 입력</option>
            </select>
            
            <input type="email" id="targetEmailInput" placeholder="이메일 주소를 입력하세요" style="flex: 1; background: #0f172a; color: #e2e8f0; border: 1px solid #334155; padding: 7px 10px; border-radius: 6px; font-size: 12px; outline: none;">
            
            <button type="button" onclick="sendReportEmail()" style="background: #9333ea; color: #fff; border: none; padding: 7px 14px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; white-space: nowrap;">
                <i class="fa-solid fa-paper-plane"></i> 전송
            </button>
        </div>

        <!-- 푸터 -->
        <div style="margin-top: 18px; text-align: right; border-top: 1px solid rgba(255, 255, 255, 0.08); padding-top: 14px; display: flex; justify-content: flex-end; gap: 8px;">
            <button type="button" onclick="toggleEmailArea()" style="background: rgba(147, 51, 234, 0.2); color: #c084fc; border: 1px solid rgba(147, 51, 234, 0.4); padding: 8px 16px; border-radius: 8px; cursor: pointer; font-size: 12px; font-weight: 600;">
                <i class="fa-solid fa-envelope"></i> 메일 발송
            </button>
            <button type="button" onclick="window.print()" style="background: #0284c7; color: #fff; border: none; padding: 8px 16px; border-radius: 8px; cursor: pointer; font-size: 12px; font-weight: 600;">인쇄 / PDF 출력</button>
            <button type="button" onclick="closeAiReportModal()" style="background: rgba(255, 255, 255, 0.05); color: #cbd5e1; border: 1px solid rgba(255,255,255,0.08); padding: 8px 16px; border-radius: 8px; cursor: pointer; font-size: 12px;">닫기</button>
        </div>
    </div>
</div>

<!-- JS 분리 파일 연결 -->
<script src="<c:url value='/resources/js/admin/fieldAction.js'/>"></script>