<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상황 보고</title>
    <!-- FontAwesome 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-resources/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 커스텀 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agent/agentReport.css">
</head>
<body>

    <div class="mobile-container">
        <!-- 상단 헤더 -->
        <header class="mobile-header">
            <button type="button" class="btn-back" onclick="history.back()">
                <i class="fa-solid fa-chevron-left"></i>
            </button>
            <h1 class="header-title">상황 보고</h1>
            <div class="header-dummy"></div> <!-- 좌우 대칭용 여백 -->
        </header>

        <!-- 폼 및 입력 영역이 들어갈 자리 -->
        <main class="mobile-content">
            <form id="reportForm" class="report-form">
			    <!-- 보고 유형 -->
			    <div class="form-group">
			        <label class="form-label" for="reportType">보고 유형</label>
			        <select id="reportType" name="reportType" class="form-select">
			            <option value="CROWD">인파 밀집</option>
						<option value="WILD_ANIMAL">야생 동물</option>
						<option value="ACCIDENT">인명 사고</option>
						<option value="FACILITY_DAMAGE">시설고장/파손</option>
						<option value="INTERLINK">연계필요</option>
						<option value="OTHER">기타</option>
			        </select>
			    </div>
			
			    <!-- 발생 구역 -->
			    <div class="form-group">
			        <label class="form-label" for="reportArea">발생 구역</label>
			        <select id="reportArea" name="reportArea" class="form-select">
			            <option value="A">A구역</option>
			            <option value="B">B구역</option>
			            <option value="C">C구역</option>
			            <option value="D">D구역</option>
			        </select>
			    </div>
			
			    <!-- 상황 내용 -->
			    <div class="form-group">
			        <label class="form-label" for="reportText">상황 내용</label>
			        <div class="textarea-wrapper">
			            <textarea id="reportText" name="reportText" class="form-textarea" maxlength="300" placeholder="상황에 대해 상세히 입력해주세요."></textarea>
			            <div class="char-count"><span id="charCount">0</span>/300</div>
			        </div>
			    </div>
			    
						    <!-- 첨부 사진 (선택) -->
			    <div class="form-group">
			        <label class="form-label">첨부 사진 (선택)</label>
			        <div class="photo-upload-area">
			            <input type="file" id="photoInput" name="photo" accept="image/*" style="display: none;">
			            <button type="button" class="btn-photo-add" onclick="document.getElementById('photoInput').click()">
			                <i class="fa-solid fa-camera camera-icon"></i>
			                <span>사진 추가</span>
			            </button>
			            <div id="photoPreview" class="photo-preview-wrapper" style="display: none;">
			                <img id="previewImg" src="" alt="미리보기">
			                <button type="button" class="btn-remove-photo" id="btnRemovePhoto">&times;</button>
			            </div>
			        </div>
			    </div>
			
			    <!-- 위치 정보 -->
			    <div class="form-group">
			        <label class="form-label">위치 정보</label>
			        <div class="location-toggle-row">
			            <div class="location-text">
			                <i class="fa-solid fa-location-dot pin-icon"></i>
			                <span id="locationName">A구역 중앙 광장 부근</span>
			            </div>
			            <label class="switch">
			                <input type="checkbox" id="locationToggle" checked>
			                <span class="slider round"></span>
			            </label>
			        </div>
			    </div>
			
			    <!-- 하단 버튼 그룹 -->
			    <div class="form-btn-group">
			        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
			        <button type="submit" class="btn-submit">등록</button>
			    </div>
			</form>
        </main>
    </div>

</body>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 1. 글자 수 카운트
    var reportText = document.getElementById('reportText');
    var charCount = document.getElementById('charCount');
    if (reportText && charCount) {
        reportText.addEventListener('input', function() {
            charCount.innerText = this.value.length;
        });
    }

    // 2. 사진 첨부 미리보기 및 삭제
    var photoInput = document.getElementById('photoInput');
    var photoPreview = document.getElementById('photoPreview');
    var previewImg = document.getElementById('previewImg');
    var btnRemovePhoto = document.getElementById('btnRemovePhoto');

    if (photoInput) {
        photoInput.addEventListener('change', function(e) {
            var file = e.target.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    photoPreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        });
    }

    if (btnRemovePhoto) {
        btnRemovePhoto.addEventListener('click', function() {
            photoInput.value = '';
            previewImg.src = '';
            photoPreview.style.display = 'none';
        });
    }

    // 3. 폼 제출 이벤트 (완료 페이지 이동)
    var reportForm = document.getElementById('reportForm');
if (reportForm) {
    reportForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // 입력값 가져오기
        var typeSelect = document.getElementById('reportType');
        var areaSelect = document.getElementById('reportArea');
        
        var reportType = typeSelect.options[typeSelect.selectedIndex].text; // 선택된 옵션의 글자 (예: 인파 밀집)
        var reportArea = areaSelect.options[areaSelect.selectedIndex].text; // 선택된 옵션의 글자 (예: A구역)
        
        // URL 파라미터로 생성하여 이동
        var url = '${pageContext.request.contextPath}/agent/report/complete'
                + '?type=' + encodeURIComponent(reportType)
                + '&area=' + encodeURIComponent(reportArea);
                
        location.href = url;
    });
}
});
</script>

</html>