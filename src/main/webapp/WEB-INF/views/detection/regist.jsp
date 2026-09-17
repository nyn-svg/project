<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>수동 감지 등록</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/detection/detection-popup.css">
</head>
<body>
	<form action="${pageContext.request.contextPath}/detection/regist" method="post" enctype="multipart/form-data">
	<!-- 1. 팝업 헤더 -->
	<div class="popup-header">
		<div class="popup-title">
			<i class="fa-solid fa-pen-to-square"></i>
			<span>수동 감지 등록</span>
		</div>
		<span class="badge status-pending">감지</span>
	</div>

	<!-- 2. 본문 그리드 영역 -->
	<div class="grid-container">
		<div class="info-box">
			<div class="info-label">구역명 | 발견인</div>
			<div class="info-value">
				<input type="text" name="zoneName" id="zoneName" class="form-control" readonly> | 
				<input type="text" name="finder" class="form-control" readonly>
				<input type="hidden" name="droneId" class="form-control">
			</div>
		</div>
		
		<div class="info-box">
			<div class="info-label">발생 일시</div>
			<div class="info-value">
				<fmt:formatDate value="현시각" pattern="yyyy-MM-dd HH:mm:ss" />
				<input type="datetime-local" id='currentDatetime'/><!-- 어떻게 넘겨주지? -->
			</div>
		</div>

		<!-- 위험 유형 + 위험 단계 배지 -->
		<div class="info-box">
			<div class="info-label">위험 유형</div>
			<div class="info-value form-inline">
				<select name="dngrType" class="form-control" required>
					<option value="">위험 유형 선택</option>
					<option value="인파위험">인파위험</option>
					<option value="야생동물">야생동물</option>
					<option value="인명사고">인명사고</option>
					<option value="시설고장/파손">시설고장/파손</option>
					<option value="시설점검">시설점검</option>
					<option value="연계필요">연계필요</option>
					<option value="기타">기타</option>
				</select>
			</div>
		</div>
		<div class="info-box">
			<div class="info-label">위험 단계</div>
			<div class="info-value form-inline">
				<select name="dngrLevel" class="form-control" required>
					<option value="">위험 단계 선택</option>
					<option value="관심">관심</option>
					<option value="주의">주의</option>
					<option value="경계">경계</option>
					<option value="심각">심각</option>
					<option value="판단불가">판단불가</option>
				</select>
			</div>
		</div>

		<!-- 발생 내용 -->
		<div class="info-box full-width">
			<div class="info-label">발생 내용</div>
			<div class="info-value">
				<textarea name="situContent" class="form-control" placeholder="발생 상황에 대해 상세히 적어주세요." required></textarea>
			</div>
		</div>

		<!-- 첨부 사진 영역 -->
		<div class="info-box full-width">
			<div class="info-label">관제 화면 스냅샷</div>
			<div style="width:100%;">
				<div class="img-preview-box" id="previewContainer">
					<span id="noImgText" class="text-orange" style="display:none;"><i class="fa-solid fa-triangle-exclamation"></i> 캡처된 영상이 없습니다.</span>
					<img id="previewImg" src="" style="display:none;">
				</div>
				<div style="font-size: 11px; color: #94a3b8; text-align: right;">
					<i class="fa-solid fa-check text-skyblue"></i> 등록 버튼 클릭 시 영상 캡처본이 자동 첨부됩니다.
				</div>
				<input type="file" name="uploadImage" id="realFileInput" style="display:none;">
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
		<button type="button" class="btn" style="margin-right: 8px;" onclick="window.close()">취소</button>
		<button type="submit" class="btn btn-primary">등록하기</button>
	</div>
	</form>
	
	<script>
		let currentScale = 1;
		let pointX = 0;
		let pointY = 0;
		let startX = 0;
		let startY = 0;
		let isDragging = false;
		let wheelTimer = null;
		
		// Base64 문자열을 File 객체로 변환해주는 마법의 함수
		function dataURLtoFile(dataurl, filename) {
			let arr = dataurl.split(','),
				mime = arr[0].match(/:(.*?);/)[1],
				bstr = atob(arr[1]), 
				n = bstr.length, 
				u8arr = new Uint8Array(n);
				
			while (n--) {
				u8arr[n] = bstr.charCodeAt(n);
			}
			return new File([u8arr], filename, { type: mime });
		}

		document.addEventListener("DOMContentLoaded", function() {
			const zoneName = sessionStorage.getItem('manualZoneName');
			const base64Img = sessionStorage.getItem('manualCaptureImg');

			if (zoneName) {
				document.getElementById('regZoneName').value = zoneName;
			}

			if (base64Img) {
				const imgEl = document.getElementById('previewImg');
				imgEl.src = base64Img;
				imgEl.style.display = 'inline-block';
				
				// 1. Base64 데이터를 File 객체로 변환 (파일명을 현재 시간으로 임시 지정)
				const fileName = 'capture_' + new Date().getTime() + '.jpg';
				const convertedFile = dataURLtoFile(base64Img, fileName);

				// 2. DataTransfer를 이용해 File 객체를 input type="file"에 강제 주입
				const dataTransfer = new DataTransfer();
				dataTransfer.items.add(convertedFile);
				document.getElementById('realFileInput').files = dataTransfer.files;

			} else {
				document.getElementById('noImgText').style.display = 'block';
			}

			sessionStorage.removeItem('manualZoneName');
			sessionStorage.removeItem('manualCaptureImg');
		});

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
	</script>
</body>
</html>