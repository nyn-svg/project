document.addEventListener('DOMContentLoaded', function() {
    var contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/agent'));

    // ==================================================
    // 💡 변경 기능: 보고 유형별 상황 조치 내용 마스터 데이터
    // ==================================================
    var templates = {
        "인파위험": ["🚶 병목 현상 발생", "🛑 통행로 차단 위험", "👥 밀집도 급증 (정체)", "🔄 도보 역주행 혼잡"],
        "야생동물": ["🐗 멧돼지 출현", "🐕 유기견 배회", "🐝 벌집 발견", "🐍 뱀 출현 신고"],
        "인명사고": ["🚑 응급 환자 발생", "🤕 단순 낙상 부상", "🏃 실종/미아 발생", "🔊 주취 소란 발생"],
        "시설고장/파손": ["🛠️ 안전 난간 파손", "💡 가로등 전면 소등", "🚧 보도블록 파손", "⚠️ 배수구 막힘/역류"],
        "연계필요": ["🚒 119 구조 요청", "🚓 112 출동 필요", "🏥 의료진 지원 요청", "🚨 관제실 추가 연계"],
        "기타": ["📝 현장 특이사항", "🔊 단순 민원 처리", "🔍 기타 상황 발생"]
    };

    // 🎯 100% 터치 라디오 형태로 동작하는 상황 내용 칩 빌더
    function renderTemplateChips(type) {
        var container = document.getElementById('situTemplateChips');
        var hiddenInput = document.getElementById('situContent');
        if (!container || !hiddenInput) return;
        
        container.innerHTML = ''; // 초기 청소
        hiddenInput.value = '';   // 선택 데이터 리셋

        var list = templates[type] || [];
        list.forEach(function(text) {
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'btn-template-chip';
            btn.innerText = text;
            
            // 상황 내용 버튼 탭 시 토글 이벤트
            btn.addEventListener('click', function() {
                var siblingButtons = container.querySelectorAll('.btn-template-chip');
                siblingButtons.forEach(function(b) { b.classList.remove('active'); });
                
                btn.classList.add('active');
                hiddenInput.value = text; // hidden 태그로 백엔드 연동 데이터 매칭
            });
            
            container.appendChild(btn);
        });
    }

    // ==================================================
    // 버튼형 칩(Chip) 이벤트 스위칭 연동 코어 시스템
    // ==================================================
    function initChipGroup(containerId, selectId, onChangeCallback) {
        var container = document.getElementById(containerId);
        var select = document.getElementById(selectId);
        if (!container || !select) return;

        var buttons = container.querySelectorAll('button');
        buttons.forEach(function(btn) {
            btn.addEventListener('click', function() {
                buttons.forEach(function(b) { b.classList.remove('active'); });
                btn.classList.add('active');
                
                var val = btn.getAttribute('data-value');
                select.value = val;
                
                if (onChangeCallback) {
                    onChangeCallback(val);
                }
            });
        });
    }

    // 마운트 시 실시간 스위칭 활성화
    initChipGroup('dngrTypeChips', 'dngrType', function(selectedType) {
        renderTemplateChips(selectedType); // 보고 유형 바뀔 때마다 상황 칩 세트 동적 리플래시
    });
    initChipGroup('dngrLevelChips', 'dngrLevel');

    // 초기 화면 진입 데이터 바인딩
    var currentType = document.getElementById('dngrType').value;
    renderTemplateChips(currentType);


    // ==================================================
    // 사진 업로드 핸들러
    // ==================================================
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
                    if(previewImg) previewImg.src = e.target.result;
                    if(photoPreview) photoPreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        });
    }

    if (btnRemovePhoto) {
        btnRemovePhoto.addEventListener('click', function() {
            photoInput.value = '';
            if(previewImg) previewImg.src = '';
            if(photoPreview) photoPreview.style.display = 'none';
        });
    }

    // ==================================================
    // 🚨 긴급 등록 비동기 통신 전송 및 칩 유효성 검사
    // ==================================================
    var btnSubmitEmergency = document.getElementById('btnSubmitEmergency');
    if (btnSubmitEmergency) {
        btnSubmitEmergency.addEventListener('click', function(e) {
            e.preventDefault();

            var hiddenInput = document.getElementById('situContent');
            // 터치 선택 유무 유효성 필터링 변경
            if (!hiddenInput || !hiddenInput.value.trim()) {
                alert("현장 상황 내용을 리스트에서 선택해 주세요.");
                return;
            }

            var formElement = document.getElementById('emergencyForm');
            var formData = new FormData(formElement);

            if (photoInput && photoInput.files && photoInput.files[0]) {
                formData.append("photo", photoInput.files[0]);
            }

            $.ajax({
                url: contextPath + '/agent/api/report',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response.success) {
                        var realSituNo = response.situNo;
                        var dngrType = document.getElementById('dngrType').value;
                        var dngrLevel = document.getElementById('dngrLevel').value;
                        
                        // 💡 [수정] JSP 화면 내 '발생 구역' 레이아웃 텍스트 박스에서 진짜 구역명 추출
                        var zoneNameElement = document.querySelector('.location-toggle-row .text-disabled-title');
                        var zoneName = zoneNameElement ? zoneNameElement.innerText.trim() : '-';

                        // 💡 [수정] 완료 페이지 이동 주소 파라미터에 encodeURIComponent(zoneName) 최종 결합
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
