$(document).ready(function() {
    var isEditMode = false;
    var ctx = window.contextPath || '';
	
	// 1. 서버에서 드론 목록 가져와서 렌더링
    function renderDroneList() {
        $.ajax({
            url: ctx + '/drone/api/list',
            type: 'GET',
            dataType: 'json',
            success: function(drones) {
                var $container = $('#drone-list-container');
                $container.empty();
				
				// 🌟 상태별 우선순위 정의 (비행: 1, 대기: 2, 고장: 3)
				var statusPriority = {
					'비행': 1,
					'대기': 2,
					'고장': 3
				};
				
				// 우선순위에 따라 배열 정렬
				drones.sort(function(a, b) {
					var pA = statusPriority[a.droneStatus] || 99;
					var pB = statusPriority[b.droneStatus] || 99;
					
					// 상태가 다르면 우선순위 순 정렬
					if (pA !== pB) {
						return pA - pB;
					}
					// 상태가 같으면 드론 ID 오름차순 정렬
					return a.droneId.localeCompare(b.droneId);
				});
				
				var statusClassMap = {
					'대기': 'ready',
					'비행': 'flying',
					'고장': 'error'
				};

                drones.forEach(function(drone) {
					var currentClass = statusClassMap[drone.droneStatus] || 'ready';
					
					var html = '<div class="drone-item-wrapper" data-id="' + drone.droneId + '" data-zone="' + drone.zoneName + '" data-url="' + drone.url + '" data-active="' + drone.activeStatus + '">'
					         + '<a href="' + ctx + '/control/stream?id=' + drone.droneId + '&zone=' + encodeURIComponent(drone.zoneName) + '" class="drone-btn sidebar-link">'
					         + '<div class="drone-info-box">'
					         +   '<div class="drone-top-row">'
					         +     '<div class="drone-name-wrapper">'
					         +       '<span class="nav-icon"><i class="fa-solid fa-mask-ventilator"></i></span>'
					         +       '<span class="drone-name">' + drone.droneId + '</span>'
					         +     '</div>'
					         +     '<span class="drone-status ' + currentClass + '">' + drone.droneStatus + '</span>'
					         +   '</div>'
					         +   '<div class="drone-zone-name">' + drone.zoneName + '</div>'
					         + '</div>'
					         + '</a>';
							 
                    if (isEditMode) {
                        html += '<button class="more-btn btn-drone-more">⋮</button>'
                              + '<div class="drone-menu-dropdown" style="display: none;">'
                              + '<button class="dropdown-item btn-edit-drone">✏️ 수정</button>'
                              + '<button class="dropdown-item delete btn-delete-drone">🗑️ 삭제</button>'
                              + '</div>';
                    }

                    html +='</div>';
                    $container.append(html);
                });
            },
            error: function(err) {
                console.error('드론 목록 조회 실패:', err);
            }
        });
    }

    // 최초 로딩 시 렌더링
    renderDroneList();
	
	// 상태가 '비행'이 아니라면 링크 이동을 강제로 취소시킵니다.
	$(document).on('click', '.sidebar-link', function(e) {
	    // 클릭한 링크 안의 상태 텍스트(대기, 비행, 고장)를 추출합니다.
	    var currentStatus = $(this).find('.drone-status').text().trim();
	    
	    if (currentStatus !== '비행') {
	        e.preventDefault();  // <a> 태그 고유의 링크 이동 기능을 마비시킴
	        e.stopPropagation(); // 부모 태그로 클릭 이벤트가 퍼지는 것을 방지
	        e.stopImmediatePropagation(); // document에 걸린 다른 클릭 이벤트 실행 즉시 중단
	        
	        alert('현재 비행 중인 드론이 아니므로 접근할 수 없는 페이지입니다.');
	    } else {
	        // 🌟 사용자가 직접 다른 비행 드론을 선택해 이동하는 경우 순회 관제 모드 자동 OFF
	        localStorage.setItem('droneAutoSwitch', 'false');
	    }
	});

    // 2. 편집 모드 토글 이벤트
    $('#btn-edit-mode').on('click', function() {
        isEditMode = true;
        $('#mode-default-btns').hide();
        $('#mode-edit-btns').css('display', 'flex');
        renderDroneList();
    });

    $('#btn-cancel-edit').on('click', function() {
        isEditMode = false;
        $('#mode-edit-btns').hide();
        $('#mode-default-btns').show();
        $('.drone-menu-dropdown').hide();
        renderDroneList();
    });

    // 3. 더보기 메뉴 토글
    $(document).on('click', '.btn-drone-more', function(e) {
        e.stopPropagation();
        var $dropdown = $(this).next('.drone-menu-dropdown');
        $('.drone-menu-dropdown').not($dropdown).hide();
        $dropdown.toggle();
    });

    $(document).on('click', function() {
        $('.drone-menu-dropdown').hide();
    });

    // 4. 모달 열기 (신규 등록)
    $('#btn-open-add-modal').on('click', function() {
        $('#modal-title').text('🛸 신규 드론 등록');
		$('#modal-drone-id').val('');
		$('#modal-drone-active').val(''); 
        $('#modal-input-zone').val('');
		$('#modal-input-url').val('');
		
		// ⭕ 신규 등록 창에서는 상태를 고를 필요가 없으므로 버튼 그룹을 통째로 숨깁니다!
		$('.status-badge-group').closest('.modal-input-group').hide();
		
        $('#drone-modal').addClass('active');
    });

    // 5. 모달 열기 (수정)
    $(document).on('click', '.btn-edit-drone', function() {
        var $wrapper = $(this).closest('.drone-item-wrapper');
        var droneId = $wrapper.data('id');
		var activeStatus = $wrapper.data('active');
        var droneZone = $wrapper.data('zone');
		var droneUrl = $wrapper.data('url');
		var droneStatus = $wrapper.find('.drone-status').text().trim() || '대기';
		// ⭕ 수정 창에서는 드론 상태를 바꿔야 하므로 숨겼던 버튼 그룹을 다시 보여줍니다.
		$('.status-badge-group').closest('.modal-input-group').show();
		$('.status-select-btn').removeClass('active');
		$('.status-select-btn[data-value="' + droneStatus + '"]').addClass('active');

        $('#modal-title').text('✏️ 드론 정보 수정');
        $('#modal-drone-id').val(droneId);
		$('#modal-drone-active').val(activeStatus);
        $('#modal-input-zone').val(droneZone);
		$('#modal-input-url').val(droneUrl);
		$('#modal-input-status').val(droneStatus);
        $('#drone-modal').addClass('active');
    });
	
	// 모달 내 상태 버튼 클릭 시 작동하는 이벤트 추가
	$(document).on('click', '.status-select-btn', function() {
	    var selectedValue = $(this).data('value');
	    $('#modal-input-status').val(selectedValue); // 숨겨진 input에 값 대입
	    
	    $('.status-select-btn').removeClass('active'); // 전체 불빛 끄기
	    $(this).addClass('active'); // 클릭한 버튼만 불빛 켜기
	});

    // 6. 모달 닫기
    $('#btn-modal-cancel').on('click', function() {
        $('#drone-modal').removeClass('active');
    });

    // 7. 드론 저장 (신규 또는 수정) -> 서버 전달
    $('#btn-modal-save').on('click', function() {
		var status = $('#modal-input-status').val();
		var stream = $('#modal-input-url').val().trim();
		var zone = $('#modal-input-zone').val().trim();
		var active = $('#modal-drone-active').val();
        var id = $('#modal-drone-id').val();

        if (!zone) {
            alert('드론의 구역명을 입력해 주세요.');
            return;
        }
		
		if (!stream) {
			alert('스트리밍 주소(URL)을 입력해 주세요.');
			return;
		}

        var url = id ? (ctx + '/drone/api/update') : (ctx + '/drone/api/add');
        var paramData = id ? { droneId: id, activeStatus: active, zoneName: zone, url: stream, droneStatus: status } : { zoneName: zone, url: stream };

        $.ajax({
            url: url,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(paramData),
            success: function(res) {
                if (res.result === 'SUCCESS') {
                    renderDroneList();
                    $('#drone-modal').removeClass('active');
                }
            },
            error: function(err) {
                alert('저장 중 오류가 발생했습니다.');
            }
        });
    });

    // 8. 드론 삭제 -> 서버 전달
    $(document).on('click', '.btn-delete-drone', function() {
        var droneId = $(this).closest('.drone-item-wrapper').data('id');
        if (confirm('해당 드론을 정말 삭제하시겠습니까?')) {
            $.ajax({
                url: ctx + '/drone/api/delete',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ droneId: droneId }),
                success: function(res) {
                    if (res.result === 'SUCCESS') {
                        renderDroneList();
                    }
                },
                error: function(err) {
                    alert('삭제 중 오류가 발생했습니다.');
                }
            });
        }
    });
	
	// 프론트엔드 JS 하단에 추가
	function initSSE() {
	    // 분리된 SseController 매핑 경로로 연결
	    var eventSource = new EventSource(ctx + '/api/sse/subscribe');

	    // 'drone_change' 이벤트를 수신하면 목록 자동 갱신 함수 실행
	    eventSource.addEventListener('drone_change', function(e) {
	        renderDroneList();
	    });

	    eventSource.onerror = function() {
	        eventSource.close();
	        setTimeout(initSSE, 3000); // 에러 발생 시 3초 후 재연결
	    };
	}

	initSSE();


    // ==========================================
    // 11. 모달리스 플로팅 윈도우 드래그 앤 드롭
    // ==========================================
    var isModalDragging = false;
    var modalShiftX = 0;
    var modalShiftY = 0;

    $(document).on('mousedown', '.modal-content', function(e) {
        // 입력창, 버튼 클릭 시 드래그 동작 제외
        if ($(e.target).is('input, button, a, select, textarea')) {
            return;
        }

        isModalDragging = true;
        var modalEl = this;
        var rect = modalEl.getBoundingClientRect();

        // 마우스 클릭 위치와 팝업창 좌상단 좌표 오프셋 계산
        modalShiftX = e.clientX - rect.left;
        modalShiftY = e.clientY - rect.top;

        $(modalEl).css('cursor', 'grabbing');
    });

    $(document).on('mousemove', function(e) {
        if (isModalDragging) {
            var left = e.clientX - modalShiftX;
            var top = e.clientY - modalShiftY;

            $('.modal-content').css({
                'left': left + 'px',
                'top': top + 'px'
            });
        }
    });

    $(document).on('mouseup', function() {
        if (isModalDragging) {
            isModalDragging = false;
            $('.modal-content').css('cursor', 'move');
        }
    });

	// 8-1. ESC 키 입력 시 팝업창 닫기
	    $(document).on('keydown', function(e) {
	        if (e.key === 'Escape' || e.keyCode === 27) {
	            $('#drone-modal').removeClass('active');
	        }
	    });
});