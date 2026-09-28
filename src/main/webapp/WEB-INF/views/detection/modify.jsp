<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<c:choose>
    <c:when test="${situation.situStatus eq '감지'}">
        <title>감지 이력 수정 및 조치 이력 등록 - ${situation.situNo}</title>
    </c:when>
    <c:otherwise>
        <title>조치 이력 수정 - ${situation.situNo}</title>
    </c:otherwise>
</c:choose>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/detection/detection-popup.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<form action="${pageContext.request.contextPath}/detection/modify" method="post" enctype="multipart/form-data">
		<!-- PK 정보 -->
		<input type="hidden" name="situNo" value="${situation.situNo}">

		<!-- 1. 팝업 헤더 -->
		<div class="popup-header">
			<div class="popup-title">
				<i class="fa-solid fa-pen-to-square"></i>
				<c:choose>
			        <c:when test="${situation.situStatus eq '감지'}">
			            <span>감지 이력 수정 및 조치 이력 등록</span>
			        </c:when>
			        <c:otherwise>
			            <span>조치 이력 수정</span>
			        </c:otherwise>
			    </c:choose>
			</div>
		</div>

		<!-- 2. 본문 그리드 영역 -->
		<div class="grid-container">
			<!-- 이력 번호 + 감지 유형 -->
			<div class="info-box">
				<div class="info-label">이력 번호 (NO)</div>
				<div class="info-value">
					<span class="text-skyblue">${situation.situNo}</span>
					<span class="badge type-badge">${situation.situType}</span>
				</div>
			</div>

			<!-- 구역명 | 발견인 | 조치인 -->
			<div class="info-box">
				<div class="info-label">구역명 | 발견인 | 조치인</div>
				<div class="info-value justify-start">
					<!-- 1. 구역명 -->
					<span>${not empty situation.zoneName ? situation.zoneName : '인식불가'}</span>
					
					<!-- 2. 발견인 (수동: 관제사 ID /자동: 드론 ID) -->
					<span class="slash">|</span>
					<span>${not empty situation.finder ? situation.finder : situation.droneId}</span>
					
					<!-- 3. 조치인 -->
					<span class="slash">|</span>
					<c:choose>
						<c:when test="${not empty situation.worker}">
							<span>${situation.worker}</span>
						</c:when>
						<c:otherwise>
							<span id="worker"><sec:authentication property="principal.username" /></span>
							<%-- <input type="hidden" name="worker" value="<sec:authentication property='principal.username' />"> --%>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			
			<!-- 위험 유형 선택 -->
			<div class="info-box">
				<div class="info-label">위험 유형</div>
				<div class="info-value form-inline">
					<select name="dngrType" class="form-control" required>
						<option value="인파위험" ${situation.dngrType eq '인파위험' ? 'selected' : ''}>인파위험</option>
						<option value="야생동물" ${situation.dngrType eq '야생동물' ? 'selected' : ''}>야생동물</option>
						<option value="인명사고" ${situation.dngrType eq '인명사고' ? 'selected' : ''}>인명사고</option>
						<option value="시설고장/파손" ${situation.dngrType eq '시설고장/파손' ? 'selected' : ''}>시설고장/파손</option>
						<option value="시설점검" ${situation.dngrType eq '시설점검' ? 'selected' : ''}>시설점검</option>
						<option value="연계필요" ${situation.dngrType eq '연계필요' ? 'selected' : ''}>연계필요</option>
						<option value="기타" ${situation.dngrType eq '기타' ? 'selected' : ''}>기타</option>
					</select>
				</div>
			</div>

			<!-- 위험 단계 선택 -->
			<div class="info-box">
				<div class="info-label">위험 단계</div>
				<div class="info-value form-inline">
					<select name="dngrLevel" class="form-control" required>
						<option value="관심" ${situation.dngrLevel eq '관심' ? 'selected' : ''}>관심</option>
						<option value="주의" ${situation.dngrLevel eq '주의' ? 'selected' : ''}>주의</option>
						<option value="경계" ${situation.dngrLevel eq '경계' ? 'selected' : ''}>경계</option>
						<option value="심각" ${situation.dngrLevel eq '심각' ? 'selected' : ''}>심각</option>
						<option value="판단불가" ${situation.dngrLevel eq '판단불가' ? 'selected' : ''}>판단불가</option>
					</select>
				</div>
			</div>
			
			<!-- 조치 상태 선택 -->
			<div class="info-box">
				<div class="info-label">조치 상태</div>
				<div class="info-value form-inline">
					<select name="situStatus" class="form-control" required>
						<option value="감지" ${situation.situStatus eq '감지' ? 'selected' : ''}>감지</option>
						<option value="조치" ${situation.situStatus eq '조치' ? 'selected' : ''}>조치</option>
						<option value="조치완료" ${situation.situStatus eq '조치완료' ? 'selected' : ''}>조치완료</option>
						<option value="미해결" ${situation.situStatus eq '미해결' ? 'selected' : ''}>미해결</option>
					</select>
				</div>
			</div>
			
			<!-- 발생 일시 (읽기 전용) -->
			<div class="info-box">
				<div class="info-label">발생 일시</div>
				<div class="info-value">
					<fmt:formatDate value="${situation.situDate}" pattern="yyyy-MM-dd HH:mm:ss" />
				</div>
			</div>
			
			<!-- 조치 시작 일시 -->
			<div class="info-box">
				<div class="info-label">조치 시작 일시</div>
				<div class="info-value">
					<c:choose>
						<c:when test="${not empty situation.startDate}">
							<fmt:formatDate value="${situation.startDate}" pattern="yyyy-MM-dd HH:mm:ss" />
				        </c:when>
				        <c:otherwise>
				            <span class="text-muted">-</span>
				        </c:otherwise>
					</c:choose>
				</div>
			</div>
			
			<!-- 조치 종료 일시 -->
			<div class="info-box">
				<div class="info-label">조치 종료 일시</div>
				<div class="info-value">
					<c:choose>
						<c:when test="${not empty situation.endDate}">
							<fmt:formatDate value="${situation.endDate}" pattern="yyyy-MM-dd HH:mm:ss" />
					    </c:when>
					    <c:otherwise>
					    	<c:choose>
					        	<c:when test="${not empty situation.startDate}">
					        		<span class="text-muted">진행 중 (미종료)</span>
					        	</c:when>
					        	<c:otherwise>
					        		<span class="text-muted">-</span>
					        	</c:otherwise>
					        </c:choose>
					    </c:otherwise>
					</c:choose>
				</div>
			</div>

			<!-- 발생 내용 -->
			<div class="info-box full-width">
				<div class="info-label">발생 내용</div>
				<div class="info-value">
					<textarea name="situContent" class="form-control" placeholder="등록된 내용이 없습니다. 발생 상황에 대해 상세히 적어주세요." required>${situation.situContent}</textarea>
				</div>
			</div>

			<!-- 감지 사진 영역 -->
			<div class="info-box full-width">
				<div class="info-label">감지 사진</div>
				<div class="img-container">
					<c:choose>
						<c:when test="${not empty situation.situImage}">
							<span id="noImgText" class="text-orange" style="display:none;"><i class="fa-solid fa-triangle-exclamation"></i> 이미지를 불러올 수 없습니다.</span>
							<img id="situImgPreview" src="${pageContext.request.contextPath}/upload/${situation.situImage}" alt="${situation.droneId} 감지 사진" onclick="openImageModal(this.src)" title="클릭하여 크게 보기" onerror="handleImageError(this)">
						</c:when>
						<c:otherwise>
							<span class="no-img"><i class="fa-solid fa-image"></i> 등록된 이미지가 없습니다.</span>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<!-- 조치 내용 -->
			<div class="info-box full-width">
				<div class="info-label">조치 내용 및 처리 결과</div>
				<div class="info-value">
					<textarea name="workContent" class="form-control" placeholder="수행한 조치 내용 및 결과를 입력하세요.">${situation.workContent}</textarea>
				</div>
			</div>

			<!-- 조치 첨부 사진 영역 -->
			<div class="info-box full-width">
				<div class="info-label">조치완료 사진</div>
				<div class="img-container">
					<c:choose>
						<c:when test="${not empty situation.workImage}">
							<span id="noWorkImgText" class="text-orange" style="display:none;"><i class="fa-solid fa-triangle-exclamation"></i> 이미지를 불러올 수 없습니다.</span>
							<img id="workImgPreview" src="${pageContext.request.contextPath}/upload/${situation.workImage}" alt="조치완료 사진" onclick="openImageModal(this.src)" title="클릭하여 크게 보기" onerror="handleWorkImageError(this)">
						</c:when>
						<c:otherwise>
							<span id="noWorkImgText"  class="no-img"><i class="fa-solid fa-image"></i> 등록된 이미지가 없습니다.</span>
							<img id="workImgPreview" src="" style="display:none;" onclick="openImageModal(this.src)" title="클릭하여 크게 보기">
						</c:otherwise>
					</c:choose>
				</div>
				<div class="img-action-bar">
					<input type="file" name="workPhoto" class="form-control" onchange="previewFile(this, '#workImgPreview', '#noWorkImgText')">
				</div>
			</div>

			<!-- 전체화면 이미지 모달 레이어 -->
			<div id="imageModal" class="img-modal" onclick="closeImageModal()">
				<span class="modal-close">&times;</span>
				<img class="modal-content" id="modalTargetImg">
			</div>
		</div>

		<!-- 4. 하단 버튼 -->
		<div class="btn-group">
			<button type="submit" class="btn btn-submit">저장</button>
			<button type="button" class="btn" onclick="history.back()">취소</button>
		</div>
	</form>

	<script>
		// 파일 선택 시 이미지 미리보기 함수
		function previewFile(input, targetImgSelector, noImgTextSelector) {
			const file = input.files[0];
			if (file) {
				const reader = new FileReader();
				reader.onload = function(e) {
					$(targetImgSelector).attr('src', e.target.result).show();
					if(noImgTextSelector) $(noImgTextSelector).hide();
				}
				reader.readAsDataURL(file);
			}
		}

		// 이미지 확대/축소 모달 관련 자바스크립트
		let currentScale = 1;
		let pointX = 0;
		let pointY = 0;
		let startX = 0;
		let startY = 0;
		let isDragging = false;
		let wheelTimer = null;

		function updateTransform() {
			const modalImg = document.getElementById("modalTargetImg");
			if (modalImg) {
				modalImg.style.transform = "translate(" + pointX + "px, " + pointY + "px) scale(" + currentScale + ")";
			}
		}

		function openImageModal(imgSrc) {
			if(!imgSrc) return;
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
				startY = e.clientY - startY;

				modalImg.classList.remove("is-zooming-in", "is-zooming-out");
				modalImg.classList.add("is-grabbing");
			});

			window.addEventListener("mousemove", function(e) {
				if (!isDragging) return;

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
			}, { passive : false });
		});
	</script>
</body>
</html>