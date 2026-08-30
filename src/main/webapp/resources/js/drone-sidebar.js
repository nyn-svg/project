$(document).ready(function() {
    // 초기 기본 드론 데이터
    var defaultDrones = [
        { id: 'A', name: '드론 A', status: 'LIVE' },
        { id: 'B', name: '드론 B', status: 'LIVE' },
        { id: 'C', name: '드론 C', status: 'LIVE' },
        { id: 'D', name: '드론 D', status: 'OFFLINE' }
    ];

    var isEditMode = false;

    // 1. localStorage에서 드론 목록 가져오기
    function getDrones() {
        var saved = localStorage.getItem('droneList');
        if (!saved) {
            localStorage.setItem('droneList', JSON.stringify(defaultDrones));
            return defaultDrones;
        }
        return JSON.parse(saved);
    }

    // 2. localStorage에 드론 목록 저장하기
    function saveDrones(drones) {
        localStorage.setItem('droneList', JSON.stringify(drones));
        renderDroneList();
    }

	// 3. 드론 목록 화면에 동적 렌더링
	function renderDroneList() {
	    var drones = getDrones();
	    var $container = $('#drone-list-container');
	    $container.empty();

	    var ctx = window.contextPath || '';

	    drones.forEach(function(drone) {
	        // 💡 href 주소 뒤에 &name= 파라미터를 추가합니다.
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
	}

    // 4. 편집 모드 토글 이벤트
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

    // 5. ... (더보기) 메뉴 토글
    $(document).on('click', '.btn-drone-more', function(e) {
        e.stopPropagation();
        var $dropdown = $(this).next('.drone-menu-dropdown');
        $('.drone-menu-dropdown').not($dropdown).hide();
        $dropdown.toggle();
    });

    $(document).on('click', function() {
        $('.drone-menu-dropdown').hide();
    });

    // 6. 모달 열기 (신규 등록)
    $('#btn-open-add-modal').on('click', function() {
        $('#modal-title').text('🛸 신규 드론 등록');
        $('#modal-drone-id').val('');
        $('#modal-input-name').val('');
        $('#drone-modal').addClass('active');
    });

    // 7. 모달 열기 (수정)
    $(document).on('click', '.btn-edit-drone', function() {
        var droneId = $(this).closest('.drone-item-wrapper').data('id');
        var drones = getDrones();
        var target = drones.filter(function(d) { return d.id == droneId; })[0];

        if (target) {
            $('#modal-title').text('✏️ 드론 이름 수정');
            $('#modal-drone-id').val(target.id);
            $('#modal-input-name').val(target.name);
            $('#drone-modal').addClass('active');
        }
    });

    // 8. 모달 닫기
    $('#btn-modal-cancel').on('click', function() {
        $('#drone-modal').removeClass('active');
    });

    // 9. 드론 저장 (신규 또는 수정)
    $('#btn-modal-save').on('click', function() {
        var name = $('#modal-input-name').val().trim();
        var id = $('#modal-drone-id').val();

        if (!name) {
            alert('드론 이름을 입력해주세요.');
            return;
        }

        var drones = getDrones();

        if (id) {
            drones = drones.map(function(d) {
                if (d.id == id) {
                    return Object.assign({}, d, { name: name });
                }
                return d;
            });
        } else {
            var newId = String.fromCharCode(65 + drones.length) + '_' + Date.now().toString().slice(-3);
            drones.push({ id: newId, name: name, status: 'LIVE' });
        }

        saveDrones(drones);
        $('#drone-modal').removeClass('active');
    });

    // 10. 드론 삭제
    $(document).on('click', '.btn-delete-drone', function() {
        var droneId = $(this).closest('.drone-item-wrapper').data('id');
        if (confirm('해당 드론을 정말 삭제하시겠습니까?')) {
            var drones = getDrones();
            drones = drones.filter(function(d) { return d.id != droneId; });
            saveDrones(drones);
        }
    });

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