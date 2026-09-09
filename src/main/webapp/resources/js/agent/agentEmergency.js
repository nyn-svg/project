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
    var emergencyForm = document.getElementById('emergencyForm');
if (emergencyForm) {
    emergencyForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // 선택된 값 읽기
        var typeSelect = document.getElementById('reportType');
        var areaSelect = document.getElementById('reportArea');
        
        var reportType = typeSelect.options[typeSelect.selectedIndex].text; // 예: 인명 사고
        var reportArea = areaSelect.options[areaSelect.selectedIndex].text; // 예: A구역
        
        // URL 파라미터로 데이터를 넘기며 이동
        var url = '${pageContext.request.contextPath}/agent/report/complete'
                + '?type=' + encodeURIComponent(reportType)
                + '&area=' + encodeURIComponent(reportArea);
                
        location.href = "report/complete";
    });
}
});