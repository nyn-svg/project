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

    // 2. 첨부 사진 미리보기 및 삭제 핸들러
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

    // 3. 🚨 긴급 등록 AJAX 비동기 전송 처리
    var btnSubmitEmergency = document.getElementById('btnSubmitEmergency');
    if (btnSubmitEmergency) {
        btnSubmitEmergency.addEventListener('click', function(e) {
            e.preventDefault();

            // 유효성 검사 (상황 내용 공백 차단)
            if (!situContent.value.trim()) {
                alert("상황 내용을 상세히 입력해주세요.");
                situContent.focus();
                return;
            }

            // 멀티파트 파일 전송을 위한 FormData 객체 생성
            var formElement = document.getElementById('emergencyForm');
            var formData = new FormData(formElement);

            // 이미지 파일 수동 확인 및 바인딩
            if (photoInput.files && photoInput.files[0]) {
                formData.append("photo", photoInput.files[0]);
            }

            // 관제실 서버 API 통신 시작
            $.ajax({
                url: contextPath + '/agent/api/report',
                type: 'POST',
                data: formData,
                processData: false, // 파일 전송 필수 옵션
                contentType: false, // 파일 전송 필수 옵션
                success: function(response) {
                    // 서버단 SituationController가 정상 저장 후 success 오브젝트를 반환할 때
                    if (response.success) {
                        var realSituNo = response.situNo; // 🚨 DB가 부여한 진짜 이력번호 추출
                        
                        var dngrType = document.getElementById('dngrType').value;
                        var dngrLevel = document.getElementById('dngrLevel').value;
                        var zoneName = document.getElementById('zoneName').value;

                        // 결과 정보를 캐치하여 완료 페이지로 파라미터 링크 이동
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
