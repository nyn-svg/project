<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>감지 상세 이력 - ${situation.situNo}</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/detection/detection-popup.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<!-- 1. 팝업 헤더 -->
	<div class="popup-header">
		<div class="popup-title">
			<i class="fa-solid fa-triangle-exclamation"></i>
			<span>감지 상세 이력</span>
		</div>

		<!-- 조치 상태 배지 -->
		<c:choose>
			<c:when test="${situation.situStatus eq '감지'}">
				<span class="badge status-pending">감지</span>
			</c:when>
			<c:when test="${situation.situStatus eq '조치'}">
				<span class="badge status-in-progress">조치</span>
			</c:when>
			<c:when test="${situation.situStatus eq '완료'}">
				<span class="badge status-completed">완료</span>
			</c:when>
			<c:when test="${situation.situStatus eq '미해결'}">
				<span class="badge status-failed">미해결</span>
			</c:when>
			<c:when test="${situation.situStatus eq '취소'}">
				<span class="badge status-canceled">취소</span>
			</c:when>
			<c:otherwise>
				<span class="badge status-pending">${situation.situStatus}</span>
			</c:otherwise>
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
				<div class="step-icon">
					<i class="fa-solid fa-bell"></i>
				</div>
				<div class="step-label">감지</div>
				<div class="step-time">
					<fmt:formatDate value="${situation.situDate}" pattern="HH:mm:ss" />
				</div>
			</div>

			<div class="timeline-step ${situation.situStatus eq '조치' ? 'active' : (situation.situStatus eq '완료' ? 'completed' : '')}">
				<div class="step-icon">
					<i class="fa-solid fa-wrench"></i>
				</div>
				<div class="step-label">조치</div>
				<div class="step-time">
					<c:choose>
						<c:when test="${not empty situation.startDate}">
							<fmt:formatDate value="${situation.startDate}" pattern="HH:mm:ss" />
						</c:when>
						<c:otherwise>-</c:otherwise>
					</c:choose>
				</div>
			</div>

			<!-- 마지막 단계: 완료 / 미해결 / 취소 동적 분기 처리 -->
			<c:choose>
				<c:when test="${situation.situStatus eq '완료'}">
					<div class="timeline-step completed active">
						<div class="step-icon">
							<i class="fa-solid fa-check"></i>
						</div>
						<div class="step-label">완료</div>
						<div class="step-time">
							<c:choose>
								<c:when test="${not empty situation.endDate}">
									<fmt:formatDate value="${situation.endDate}" pattern="HH:mm:ss" />
								</c:when>
								<c:otherwise>-</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:when>

				<c:when test="${situation.situStatus eq '미해결'}">
					<div class="timeline-step active failed">
						<div class="step-icon">
							<i class="fa-solid fa-xmark"></i>
						</div>
						<div class="step-label">미해결</div>
						<div class="step-time">
							<c:choose>
								<c:when test="${not empty situation.endDate}">
									<fmt:formatDate value="${situation.endDate}" pattern="HH:mm:ss" />
								</c:when>
								<c:otherwise>-</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:when>

				<c:when test="${situation.situStatus eq '취소'}">
					<div class="timeline-step active canceled">
						<div class="step-icon">
							<i class="fa-solid fa-ban"></i>
						</div>
						<div class="step-label">취소</div>
						<div class="step-time">
							<c:choose>
								<c:when test="${not empty situation.endDate}">
									<fmt:formatDate value="${situation.endDate}" pattern="HH:mm:ss" />
								</c:when>
								<c:otherwise>-</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:when>

				<c:otherwise>
					<div class="timeline-step">
						<div class="step-icon">
							<i class="fa-solid fa-check"></i>
						</div>
						<div class="step-label">완료</div>
						<div class="step-time">-</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<!-- 3. 본문 그리드 영역 -->
	<div class="grid-container">
		<!-- 이력 번호 + 감지 유형 배지 -->
		<div class="info-box">
			<div class="info-label">이력 번호 (NO)</div>
			<div class="info-value">
				<span class="text-skyblue">${situation.situNo}</span>
				<span class="badge type-badge">${situation.situType}</span>
			</div>
		</div>

		<div class="info-box">
			<div class="info-label">구역명 | 발견인</div>
			<div class="info-value justify-start">
				<span>${situation.zoneName != null ? situation.zoneName : '인식불가'}</span>
				<span>|</span> 
				<span>${not empty situation.finder ? situation.finder : situation.droneId}</span>
			</div>
		</div>

		<!-- 위험 유형 + 위험 단계 배지 -->
		<div class="info-box">
			<div class="info-label">위험 유형</div>
			<div class="info-value">
				<span class="text-orange">${situation.dngrType}</span>
				<c:choose>
					<c:when test="${situation.dngrLevel eq '관심'}">
						<span class="badge danger-interest">관심</span>
					</c:when>
					<c:when test="${situation.dngrLevel eq '주의'}">
						<span class="badge danger-attention">주의</span>
					</c:when>
					<c:when test="${situation.dngrLevel eq '경계'}">
						<span class="badge danger-caution">경계</span>
					</c:when>
					<c:when test="${situation.dngrLevel eq '심각'}">
						<span class="badge danger-severe">심각</span>
					</c:when>
					<c:otherwise>
						<span class="badge danger-unknown">${situation.dngrLevel != null ? situation.dngrLevel : '판단불가'}</span>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div class="info-box">
			<div class="info-label">발생 일시</div>
			<div class="info-value">
				<fmt:formatDate value="${situation.situDate}" pattern="yyyy-MM-dd HH:mm:ss" />
			</div>
		</div>

		<!-- 발생 내용 -->
		<div class="info-box full-width">
			<div class="info-label">발생 내용</div>
			<div class="content-box">${situation.situContent != null ? situation.situContent : '등록된 내용이 없습니다.'}</div>
		</div>

		<!-- 첨부 사진 영역 -->
		<c:if test="${not empty situation.situImage}">
			<div class="info-box full-width">
				<div class="info-label">감지 사진</div>
				<div class="img-container">
					<span id="noImgText" class="text-orange" style="display:none;"><i class="fa-solid fa-triangle-exclamation"></i> 이미지를 불러올 수 없습니다.</span>
					<img id="viewImg" src="${pageContext.request.contextPath}/upload/${situation.situImage}" alt="${situation.droneId} 감지 사진" onclick="openImageModal(this.src)" title="클릭하여 크게 보기" onerror="handleImageError(this)">
				</div>
				<div class="img-action-bar">
					<a href="${pageContext.request.contextPath}/upload/${situation.situImage}" download="${situation.situNo}" class="btn-download"> 
						<i class="fa-solid fa-floppy-disk"></i> 이미지 다운로드
					</a>
				</div>
			</div>
		</c:if>

		<!-- 전체화면 이미지 모달 레이어 -->
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
		<button type="button" class="btn btn-submit" onclick="location.href='${pageContext.request.contextPath}/detection/modify?no=${situation.situNo}'">수정</button>
		<c:if test="${situation.situStatus eq '감지' or situation.situStatus eq '조치'}">
	        <button type="button" class="btn btn-danger" onclick="openRemovePopup()">삭제</button>
	    </c:if>
		<button type="button" class="btn" onclick="window.close()">창닫기</button>
	</div>

	<script>
		let currentScale = 1;
		let pointX = 0;
		let pointY = 0;
		let startX = 0;
		let startY = 0;
		let isDragging = false;
		let wheelTimer = null;

		function handleImageError(img) {
		    const $box = $(img).closest('.info-box');
		    $box.find('#viewImg').hide();
		    $box.find('.img-action-bar').hide();
		    $box.find('#noImgText').show();
		}
		
		function updateTransform() {
			const modalImg = document.getElementById("modalTargetImg");
			if (modalImg) {
				modalImg.style.transform = "translate(" + pointX + "px, "
						+ pointY + "px) scale(" + currentScale + ")";
			}
		}

		function openImageModal(imgSrc) {
			const modal = document.getElementById("imageModal");
			const modalImg = document.getElementById("modalTargetImg");

			currentScale = 1;
			pointX = 0;
			pointY = 0;
			isDragging = false;

			modalImg.className = "modal-content";
			updateTransform();

			modalImg.src = imgSrc;
			modal.style.display = "flex";
		}

		function closeImageModal() {
			document.getElementById("imageModal").style.display = "none";
		}

		document.addEventListener("DOMContentLoaded", function() {
			const modal = document.getElementById("imageModal");
			const modalImg = document.getElementById("modalTargetImg");

			modalImg.addEventListener("click", function(e) {
				e.stopPropagation();
			});

			modalImg.addEventListener("mousedown", function(e) {
				e.preventDefault();
				e.stopPropagation();

				isDragging = true;
				startX = e.clientX - pointX;
				startY = e.clientY - pointY;

				modalImg.classList.remove("is-zooming-in", "is-zooming-out");
				modalImg.classList.add("is-grabbing");
			});

			window.addEventListener("mousemove", function(e) {
				if (!isDragging)
					return;

				e.preventDefault();
				pointX = e.clientX - startX;
				pointY = e.clientY - startY;
				updateTransform();
			});

			window.addEventListener("mouseup", function() {
				if (isDragging) {
					isDragging = false;
					modalImg.classList.remove("is-grabbing");
				}
			});

			modal.addEventListener("wheel", function(e) {
				if (modal.style.display === "flex") {
					e.preventDefault();

					clearTimeout(wheelTimer);
					modalImg.classList.remove("is-grabbing", "is-zooming-in", "is-zooming-out");

					if (e.deltaY < 0) {
						currentScale = Math.min(currentScale + 0.25, 5.0);
						modalImg.classList.add("is-zooming-in");
					} else {
						currentScale = Math.max(currentScale - 0.25, 0.4);
						modalImg.classList.add("is-zooming-out");
					}

					if (currentScale <= 1) {
						pointX = 0;
						pointY = 0;
					}

					updateTransform();

					wheelTimer = setTimeout(function() {
						modalImg.classList.remove("is-zooming-in", "is-zooming-out");
					}, 400);
				}
			}, {
				passive : false
			});
		});
		
		function openRemovePopup() {
		    const url = '${pageContext.request.contextPath}/detection/remove?no=${situation.situNo}';
		    const width = 630;
		    const height = 340;
		    
		    // 모니터 해상도 기준 정중앙 좌표 계산
		    const left = (window.screen.width / 2) - (width / 2);
    		const top = (window.screen.height / 2) - (height / 2);
    		const windowOption = 'width=' + width + ', height=' + height + ', top=' + top + ', left=' + left + ', scrollbars=no, resizable=no';
		    
		    window.open(url, 'removePopup', windowOption);
		    
		    // 현재 상세페이지 닫기
		    window.close();
		}
	</script>
</body>
</html>