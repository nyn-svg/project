document.addEventListener('DOMContentLoaded', function() {
    // 💡 contextPath 동적 추출 (스크립트 경로 에러 방지)
    var contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/agent'));

    // 1. 상황 내용 글자 수 실시간 카운트
    var situContent = document.getElementById('situContent');
    var charCount = document.getElementById('charCount');
    if (situContent && charCount) {
        situContent.addEventListener('input', function() {
            charCount.innerText = this.value.length;
        });
    }

    // 2. 첨부 사진 미리보기 및 삭제 핸들러 (🚨 예외 처리 및 오타 완벽 복구)
    var photoInput = document.getElementById('photoInput');
    var photoPreview = document.getElementById('photoPreview');
    var previewImg = document.getElementById('previewImg');
    var btnRemovePhoto = document.getElementById('btnRemovePhoto');

    if (photoInput) {
        photoInput.addEventListener('change', function(e) {
            // 안전하게 인덱스 0번 처리
            if (e.target.files && e.target.files[0]) {
                var file = e.target.files[0];
                var reader = new FileReader();
                reader.onload = function(e) {
                    if(previewImg) previewImg.src = e.target.result;
                    if(photoPreview) photoPreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        });
    }

    if (btnRemovePhoto) {
        btnRemovePhoto.addEventListener('click', function() {
            if(photoInput) photoInput.value = '';
            if(previewImg) previewImg.src = '';
            if(photoPreview) photoPreview.style.display = 'none';
        });
    }

    // 3. 🚨 긴급 등록 AJAX 비동기 전송 처리 및 팝업 연동
    var btnSubmitEmergency = document.getElementById('btnSubmitEmergency');
    if (btnSubmitEmergency) {
        btnSubmitEmergency.addEventListener('click', function(e) {
            e.preventDefault(); // 기본 submit 트리거 차단

            // 유효성 검사 (상황 내용 공백 차단)
            if (!situContent || !situContent.value.trim()) {
                alert("상황 내용을 상세히 입력해주세요.");
                if(situContent) situContent.focus();
                return;
            }

            // 💡 [최종 안] 신중한 보고를 위한 크롬/모바일 공용 알림 컨펌창
            var isConfirm = confirm("🚨 긴급 보고는 전송 후 수정이나 조회가 불가능합니다.\n정말로 관제실로 즉시 전송하시겠습니까?");
            if (!isConfirm) {
                return; // 취소 누르면 코드 중단
            }

            // 멀티파트 파일 전송을 위한 FormData 객체 생성
            var formElement = document.getElementById('emergencyForm');
            var formData = new FormData(formElement);

            // 이미지 파일 수동 확인 및 안전 바인딩
            if (photoInput && photoInput.files && photoInput.files[0]) {
                formData.append("photo", photoInput.files[0]);
            }

            // 관제실 서버 API 통신 시작
            $.ajax({
                url: contextPath + '/agent/api/report',
                type: 'POST',
                data: formData,
                processData: false, // 필수
                contentType: false, // 필수
                success: function(response) {
                    if (response.success) {
                        var realSituNo = response.situNo; // DB 진짜 이력번호
                        
                        var dngrType = document.getElementById('dngrType').value;
                        var dngrLevel = document.getElementById('dngrLevel').value;
                        var zoneName = document.getElementById('zoneName').value;

                        // 결과 정보 쿼리스트링 파라미터 링크 이동 (& 부호 결합 구조)
                        location.href = contextPath + "/agent/report/complete"
                                      + "?situNo=" + encodeURIComponent(realSituNo)
                                      + "&dngrType=" + encodeURIComponent(dngrType)
                                      + "&dngrLevel=" + encodeURIComponent(dngrLevel)
                                      + "&zoneName=" + encodeURIComponent(zoneName);
                    } else {
                        alert("보고 등록 실패: " + response.message);
                    }
                },
                error: function(xhr) {
                    alert("관제 DB 서버 통신 장애 발생 (상태코드: " + xhr.status + ")");
                }
            });
        });
    }
});
