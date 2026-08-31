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

                drones.forEach(function(drone) {
                    var html = '<div class="drone-item-wrapper" data-id="' + drone.id + '" data-name="' + drone.name + '">'
                             + '<a href="' + ctx + '/drone/stream?id=' + drone.id + '&name=' + encodeURIComponent(drone.name) + '" class="drone-btn sidebar-link" data-id="' + drone.id + '" data-name="' + drone.name + '">'
                             + '<span class="nav-icon"><i class="fa-solid fa-mask-ventilator"></i></span>'
                             + '<span class="drone-name">' + drone.name + ' 관제</span>'
                             + '<span class="drone-status">' + (drone.status || 'LIVE') + '</span>'
                             + '</a>';

                    if (isEditMode) {
                        html += '<button class="more-btn btn-drone-more">⋮</button>'
                              + '<div class="drone-menu-dropdown" style="display: none;">'
                              + '<button class="dropdown-item btn-edit-drone">✏️ 수정</button>'
                              + '<button class="dropdown-item delete btn-delete-drone">🗑️ 삭제</button>'
                              + '</div>';
                    }

                    html += '</div>';
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

    // 2. 편집 모드 토글 이벤트
    $('#btn-edit-mode').on('click', function() {
        isEditMode = true;
        $('#mode-defaultBtns').hide();
        $('#mode-edit-btns').css('display', 'flex');
        renderDroneList();
    });

    $('#btn-cancel-edit').on('click', function() {
        isEditMode = false;
        $('#mode-edit-btns').hide();
        $('#mode-defaultBtns').show();
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
        $('#modal-input-name').val('');
        $('#drone-modal').addClass('active');
    });

    // 5. 모달 열기 (수정)
    $(document).on('click', '.btn-edit-drone', function() {
        var $wrapper = $(this).closest('.drone-item-wrapper');
        var droneId = $wrapper.data('id');
        var droneName = $wrapper.data('name');

        $('#modal-title').text('✏️ 드론 이름 수정');
        $('#modal-drone-id').val(droneId);
        $('#modal-input-name').val(droneName);
        $('#drone-modal').addClass('active');
    });

    // 6. 모달 닫기
    $('#btn-modal-cancel').on('click', function() {
        $('#drone-modal').removeClass('active');
    });

    // 7. 드론 저장 (신규 또는 수정) -> 서버 전달
    $('#btn-modal-save').on('click', function() {
        var name = $('#modal-input-name').val().trim();
        var id = $('#modal-drone-id').val();

        if (!name) {
            alert('드론 이름을 입력해주세요.');
            return;
        }

        var url = id ? (ctx + '/drone/api/update') : (ctx + '/drone/api/add');
        var paramData = id ? { id: id, name: name } : { name: name };

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
                data: JSON.stringify({ id: droneId }),
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
	    var ctx = window.contextPath || '';
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
	
	
    // 초기화 실행
    renderDroneList();
});