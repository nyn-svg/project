<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>감지 상세 정보 - ${situation.situNo}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Pretendard', sans-serif; }
        body { background-color: #0f172a; color: #f8fafc; padding: 20px; font-size: 13px; }
        
        /* 팝업 헤더 */
        .popup-header { display: flex; justify-content: space-between; align-items: center; padding-bottom: 12px; border-bottom: 1px solid #334155; margin-bottom: 16px; }
        .popup-title { font-size: 18px; font-weight: 700; color: #38bdf8; display: flex; align-items: center; gap: 8px; }

        /* 배지 공통 */
        .badge { 
		    padding: 3px 8px; 
		    border-radius: 4px; 
		    font-size: 12px; 
		    font-weight: 600; 
		    display: inline-flex; 
		    align-items: center;
		    justify-content: center;
		    line-height: 1;
		    margin-left: 0; 
		}
        .type-badge { background: rgba(148, 163, 184, 0.15); color: #cbd5e1; border: 1px solid rgba(148, 163, 184, 0.3); }

        /* 위험 단계 배지 */
        .danger-interest  { background: rgba(59, 130, 246, 0.2);  color: #60a5fa; border: 1px solid rgba(59, 130, 246, 0.4); }
        .danger-attention { background: rgba(234, 179, 8, 0.2);   color: #facc15; border: 1px solid rgba(234, 179, 8, 0.4); }
        .danger-caution   { background: rgba(249, 115, 22, 0.2);  color: #fb923c; border: 1px solid rgba(249, 115, 22, 0.4); }
        .danger-severe    { background: rgba(239, 68, 68, 0.2);   color: #f87171; border: 1px solid rgba(239, 68, 68, 0.4); }
        .danger-unknown   { background: rgba(156, 163, 175, 0.2);  color: #9ca3af; border: 1px solid rgba(156, 163, 175, 0.4); }

        /* 조치 상태 배지 */
        .status-pending     { background: rgba(56, 189, 248, 0.2);  color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.4); }
        .status-confirmed   { background: rgba(59, 130, 246, 0.2);  color: #60a5fa; border: 1px solid rgba(59, 130, 246, 0.4); }
        .status-in-progress { background: rgba(249, 115, 22, 0.2);  color: #fb923c; border: 1px solid rgba(249, 115, 22, 0.4); }
        .status-completed   { background: rgba(16, 185, 129, 0.2);  color: #34d399; border: 1px solid rgba(16, 185, 129, 0.4); }
        .status-failed      { background: rgba(168, 85, 247, 0.2);  color: #c084fc; border: 1px solid rgba(168, 85, 247, 0.4); }
        .status-canceled    { background: rgba(148, 163, 184, 0.2);  color: #94a3b8; border: 1px solid rgba(148, 163, 184, 0.4); }

        /* 최상단 타임라인 */
        .timeline-section { background: rgba(30, 41, 59, 0.7); border: 1px solid #334155; border-radius: 6px; padding: 12px 14px; margin-bottom: 16px; }
        .timeline-title { font-size: 12px; font-weight: 600; color: #94a3b8; margin-bottom: 10px; display: flex; align-items: center; gap: 6px; }
        .timeline-wrapper { display: flex; justify-content: space-between; align-items: flex-start; position: relative; padding: 0 10px; }
        .timeline-line { position: absolute; top: 14px; left: 40px; right: 40px; height: 2px; background: #334155; z-index: 1; }
        
        .timeline-step { display: flex; flex-direction: column; align-items: center; position: relative; z-index: 2; width: 22%; text-align: center; }
        .step-icon { width: 28px; height: 28px; border-radius: 50%; background: #1e293b; border: 2px solid #475569; color: #64748b; display: flex; align-items: center; justify-content: center; font-size: 11px; margin-bottom: 4px; }
        .step-label { font-size: 11px; font-weight: 600; color: #94a3b8; }
        .step-time { font-size: 10px; color: #64748b; margin-top: 1px; }

        .timeline-step.active .step-icon { background: #0284c7; border-color: #38bdf8; color: #fff; box-shadow: 0 0 8px rgba(56, 189, 248, 0.4); }
        .timeline-step.active .step-label { color: #38bdf8; }
        .timeline-step.completed .step-icon { background: #059669; border-color: #34d399; color: #fff; }
        .timeline-step.completed .step-label { color: #34d399; }

        /* 정보 그리드 */
        .grid-container { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px; }
        .info-box { 
		    background: rgba(30, 41, 59, 0.7); 
		    border: 1px solid #334155; 
		    border-radius: 6px; 
		    padding: 10px 12px; 
		    min-height: 62px; /* 고정 최소 높이 부여 */
		    display: flex;
		    flex-direction: column;
		    justify-content: center;
		}
		.info-label { 
		    font-size: 11px; 
		    color: #94a3b8; 
		    font-weight: 600; 
		    margin-bottom: 4px; 
		}
		.info-value { 
		    font-size: 13px; 
		    color: #f1f5f9; 
		    font-weight: 500; 
		    display: flex; 
		    align-items: center; /* 수직 중앙 정렬 */
		    justify-content: space-between; /* 좌우 끝 정렬 */
		    width: 100%;
		    min-height: 24px; /* 배지 높이와 동일하게 라인 높이 맞춤 */
		    line-height: 1;
		}

        .full-width { grid-column: span 2; }
        .content-box { min-height: 50px; background: #090d16; border: 1px solid #1e293b; border-radius: 4px; padding: 8px 10px; color: #cbd5e1; white-space: pre-wrap; line-height: 1.4; }

        /* 이미지 박스 */
        .img-container { text-align: center; background: #000; border-radius: 6px; padding: 10px; border: 1px solid #334155; min-height: 180px; display: flex; align-items: center; justify-content: center; }
        .img-container img { max-width: 100%; max-height: 250px; object-fit: contain; }
        .no-img { color: #64748b; font-size: 12px; display: flex; flex-direction: column; gap: 6px; align-items: center; }
		
		/* 다운로드 버튼 라인 */
		.img-action-bar {
		    display: flex;
		    justify-content: flex-end;
		    margin-top: 8px;
		}
		.btn-download {
		    background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
		    color: #ffffff !important;
		    border: none;
		    border-radius: 6px;
		    padding: 5px 12px;
		    font-size: 12px;
		    font-weight: 600;
		    cursor: pointer;
		    display: inline-flex;
		    align-items: center;
		    gap: 6px;
		    text-decoration: none;
		    transition: all 0.2s ease;
		    box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2);
		}
		
		.btn-download:hover {
		    background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
		    color: #ffffff !important;
		    box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3);
		}

		/* FontAwesome 아이콘 색상 및 크기 고정 */
		.btn-download i {
		    color: #ffffff;
		    font-size: 13px;
		}
		
		/* 이미지 전체화면 모달 */
		.img-modal {
		    display: none; 
		    position: fixed; 
		    z-index: 9999; 
		    left: 0;
		    top: 0;
		    width: 100%; 
		    height: 100%; 
		    background-color: rgba(0, 0, 0, 0.85); 
		    justify-content: center;
		    align-items: center;
		    overflow: hidden;
		}
		.modal-content {
		    width: auto;
		    height: auto;
		    max-width: 80vw;
		    max-height: 80vh;
		    border-radius: 8px;
		    box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);
		    transform-origin: center center;
		    cursor: grab;
		    user-select: none;
		    -webkit-user-drag: none; /* 브라우저 기본 이미지 드래그 기능 차단 */
		}
		/* 커서 상태 클래스 */
		.modal-content.is-grabbing { cursor: grabbing !important; }
		.modal-content.is-zooming-in { cursor: zoom-in !important; }
		.modal-content.is-zooming-out { cursor: zoom-out !important; }
		
		.modal-close {
		    position: absolute;
		    top: 20px;
		    right: 30px;
		    color: #ffffff;
		    font-size: 40px;
		    font-weight: bold;
		    cursor: pointer;
		    z-index: 10000;
		}
		
        .btn-group { display: flex; justify-content: flex-end; }
        .btn { padding: 8px 16px; border-radius: 4px; border: none; font-weight: 600; cursor: pointer; background: #334155; color: #f8fafc; }
        .btn:hover { background: #475569; }
    </style>
</head>
<body>

    <!-- 1. 팝업 헤더 (우측 상단에는 조치상태만 남아있음) -->
    <div class="popup-header">
        <div class="popup-title">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <span>상황 감지 이력</span>
        </div>
        
        <!-- 조치 상태 배지 -->
        <c:choose>
            <c:when test="${situation.situStatus eq '대기'}"><span class="badge status-pending">대기</span></c:when>
            <c:when test="${situation.situStatus eq '확인'}"><span class="badge status-confirmed">확인</span></c:when>
            <c:when test="${situation.situStatus eq '조치'}"><span class="badge status-in-progress">조치중</span></c:when>
            <c:when test="${situation.situStatus eq '완료'}"><span class="badge status-completed">완료</span></c:when>
            <c:when test="${situation.situStatus eq '미해결'}"><span class="badge status-failed">미해결</span></c:when>
            <c:when test="${situation.situStatus eq '취소'}"><span class="badge status-canceled">취소</span></c:when>
            <c:otherwise><span class="badge status-pending">${situation.situStatus}</span></c:otherwise>
        </c:choose>
    </div>

    <!-- 2. 최상단 배치: 조치 진행 타임라인 -->
    <div class="timeline-section">
        <div class="timeline-title">
            <i class="fa-solid fa-clock-rotate-left"></i>
            <span>조치 진행 타임라인</span>
        </div>
        <div class="timeline-wrapper">
            <div class="timeline-line"></div>

            <div class="timeline-step completed">
                <div class="step-icon"><i class="fa-solid fa-bell"></i></div>
                <div class="step-label">감지</div>
                <div class="step-time"><fmt:formatDate value="${situation.situDate}" pattern="HH:mm:ss"/></div>
            </div>

            <div class="timeline-step ${situation.situStatus eq '확인' ? 'active' : (situation.situStatus eq '조치' || situation.situStatus eq '완료' ? 'completed' : '')}">
                <div class="step-icon"><i class="fa-solid fa-eye"></i></div>
                <div class="step-label">확인</div>
                <div class="step-time">
                    <c:choose>
                        <c:when test="${not empty situation.startDate}"><fmt:formatDate value="${situation.startDate}" pattern="HH:mm:ss"/></c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="timeline-step ${situation.situStatus eq '조치' ? 'active' : (situation.situStatus eq '완료' ? 'completed' : '')}">
                <div class="step-icon"><i class="fa-solid fa-wrench"></i></div>
                <div class="step-label">조치</div>
                <div class="step-time">
                    <c:choose>
                        <c:when test="${not empty situation.startDate}"><fmt:formatDate value="${situation.startDate}" pattern="HH:mm:ss"/></c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="timeline-step ${situation.situStatus eq '완료' ? 'completed active' : ''}">
                <div class="step-icon"><i class="fa-solid fa-check"></i></div>
                <div class="step-label">종료</div>
                <div class="step-time">
                    <c:choose>
                        <c:when test="${not empty situation.endDate}"><fmt:formatDate value="${situation.endDate}" pattern="HH:mm:ss"/></c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- 3. 본문 그리드 영역 -->
    <div class="grid-container">
        <!-- 이력 번호 + 감지 유형 배지 -->
        <div class="info-box">
		    <div class="info-label">이력 번호 (NO)</div>
		    <div class="info-value">
		        <span style="color: #38bdf8;">${situation.situNo}</span>
		        <span class="badge type-badge">${situation.situType != null ? situation.situType : '자동'}</span>
		    </div>
		</div>
		
		<div class="info-box">
		    <div class="info-label">구역명 / 작성자</div>
		    <div class="info-value">${situation.zoneName != null ? situation.zoneName : '미지정'} (${situation.userId})</div>
		</div>

        <!-- 위험 유형 + 위험 단계 배지 -->
        <div class="info-box">
		    <div class="info-label">위험 유형</div>
		    <div class="info-value">
		        <span style="color:#fb923c;">${situation.dngrType}</span>
		        <c:choose>
		            <c:when test="${situation.dngrLevel eq '관심'}"><span class="badge danger-interest">관심</span></c:when>
		            <c:when test="${situation.dngrLevel eq '주의'}"><span class="badge danger-attention">주의</span></c:when>
		            <c:when test="${situation.dngrLevel eq '경계'}"><span class="badge danger-caution">경계</span></c:when>
		            <c:when test="${situation.dngrLevel eq '심각'}"><span class="badge danger-severe">심각</span></c:when>
		            <c:otherwise><span class="badge danger-unknown">${situation.dngrLevel != null ? situation.dngrLevel : '판단불가'}</span></c:otherwise>
		        </c:choose>
		    </div>
		</div>
        
        <div class="info-box">
            <div class="info-label">최초 발생 일시</div>
            <div class="info-value"><fmt:formatDate value="${situation.situDate}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
        </div>

        <!-- 발생 내용 -->
        <div class="info-box full-width">
            <div class="info-label">발생 내용</div>
            <div class="content-box">${situation.situContent != null ? situation.situContent : '등록된 내용이 없습니다.'}</div>
        </div>

        <!-- 1) 첨부 사진 영역 수정 (클릭 이벤트 및 다운로드 버튼 추가) -->
		<c:if test="${not empty situation.situImage}">
		    <div class="info-box full-width">
		        <div class="info-label">첨부 사진</div>
		        <div class="img-container">
		            <!-- 클릭 시 모달 열기 -->
		            <img src="${pageContext.request.contextPath}/resources/upload/situation/${situation.situImage}" 
		                 alt="감지 사진" 
		                 onclick="openImageModal(this.src)"
		                 style="cursor: pointer;" title="클릭하여 크게 보기">
		        </div>
		        <!-- 사진 하단 다운로드 영역 -->
		        <div class="img-action-bar">
				    <a href="${pageContext.request.contextPath}/resources/upload/situation/${situation.situImage}" 
				       download="${situation.situImage}"
				       class="btn-download">
				        <i class="fa-solid fa-floppy-disk"></i>
				        이미지 다운로드
				    </a>
				</div>
		    </div>
		</c:if>

		<!-- 2) 전체화면 이미지를 보여줄 모달 레이어 (JSP 맨 아래 추가) -->
		<div id="imageModal" class="img-modal" onclick="closeImageModal()">
		    <span class="modal-close">&times;</span>
		    <img class="modal-content" id="modalTargetImg">
		</div>

        <!-- 조치 내용 -->
        <c:if test="${not empty situation.workContent}">
            <div class="info-box full-width">
                <div class="info-label">조치 내용 및 처리 결과</div>
                <div class="content-box">${situation.workContent}</div>
            </div>
        </c:if>
    </div>

    <!-- 4. 하단 버튼 -->
    <div class="btn-group">
        <button type="button" class="btn" onclick="window.close()">창 닫기</button>
    </div>
	
	<script>
		let currentScale = 1;
		let pointX = 0;
		let pointY = 0;
		let startX = 0;
		let startY = 0;
		let isDragging = false;
		let wheelTimer = null;
	
		// 좌표 및 스케일 적용 함수 (JSP EL 표현식과의 충돌을 방지하기 위해 + 연산자 사용)
		function updateTransform() {
		    const modalImg = document.getElementById("modalTargetImg");
		    if (modalImg) {
		        modalImg.style.transform = "translate(" + pointX + "px, " + pointY + "px) scale(" + currentScale + ")";
		    }
		}
	
		// 모달 열기
		function openImageModal(imgSrc) {
		    const modal = document.getElementById("imageModal");
		    const modalImg = document.getElementById("modalTargetImg");
		    
		    // 위치 및 배율 초기화
		    currentScale = 1;
		    pointX = 0;
		    pointY = 0;
		    isDragging = false;
		    
		    // 스타일 및 클래스 초기화
		    modalImg.className = "modal-content";
		    updateTransform();
		    
		    modalImg.src = imgSrc;
		    modal.style.display = "flex";
		}
	
		// 모달 닫기
		function closeImageModal() {
		    document.getElementById("imageModal").style.display = "none";
		}
	
		// 이벤트 바인딩
		document.addEventListener("DOMContentLoaded", function() {
		    const modal = document.getElementById("imageModal");
		    const modalImg = document.getElementById("modalTargetImg");
	
		    // 1. 이미지 자체 클릭 시 모달이 바로 닫히는 것 방지
		    modalImg.addEventListener("click", function(e) {
		        e.stopPropagation();
		    });
	
		    // 2. 마우스 클릭 시 (드래그 시작)
		    modalImg.addEventListener("mousedown", function(e) {
		        e.preventDefault();
		        e.stopPropagation();
		        
		        isDragging = true;
		        startX = e.clientX - pointX;
		        startY = e.clientY - pointY;
		        
		        modalImg.classList.remove("is-zooming-in", "is-zooming-out");
		        modalImg.classList.add("is-grabbing");
		    });
	
		    // 3. 마우스 이동 (드래그 반응)
		    window.addEventListener("mousemove", function(e) {
		        if (!isDragging) return;
		        
		        e.preventDefault();
		        pointX = e.clientX - startX;
		        pointY = e.clientY - startY;
		        updateTransform();
		    });
	
		    // 4. 마우스 뗌 (드래그 종료)
		    window.addEventListener("mouseup", function() {
		        if (isDragging) {
		            isDragging = false;
		            modalImg.classList.remove("is-grabbing");
		        }
		    });
	
		    // 5. 마우스 휠 (확대/축소)
		    modal.addEventListener("wheel", function(e) {
		        if (modal.style.display === "flex") {
		            e.preventDefault();
		            
		            clearTimeout(wheelTimer);
		            modalImg.classList.remove("is-grabbing", "is-zooming-in", "is-zooming-out");
		            
		            if (e.deltaY < 0) {
		                currentScale = Math.min(currentScale + 0.25, 5.0); // 휠 올릴 때 확대
		                modalImg.classList.add("is-zooming-in");
		            } else {
		                currentScale = Math.max(currentScale - 0.25, 0.4); // 휠 내릴 때 축소
		                modalImg.classList.add("is-zooming-out");
		            }
		            
		            // 배율이 1 이하일 경우 중심 위치 자동 리셋
		            if (currentScale <= 1) {
		                pointX = 0;
		                pointY = 0;
		            }
		            
		            updateTransform();
	
		            // 0.4초 뒤 다시 평소(grab) 커서로 복구
		            wheelTimer = setTimeout(function() {
		                modalImg.classList.remove("is-zooming-in", "is-zooming-out");
		            }, 400);
		        }
		    }, { passive: false });
		});
	</script>
</body>
</html>