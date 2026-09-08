<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="agent-container">
    <!-- 1. 좌측: 사용자 목록 패널 -->
    <div class="agent-card list-panel">
        <div class="panel-header">
            <h3 class="panel-title"><i class="fa-solid fa-users"></i> 사용자 목록</h3>
            <button type="button" class="mini-btn primary" id="btn-reset-form">
                <i class="fa-solid fa-user-plus"></i> 신규 등록
            </button>
        </div>

        <!-- 검색 영역 -->
        <div class="search-box">
            <div class="search-input-wrapper">
                <i class="fa-solid fa-magnifying-glass search-icon"></i>
                <input type="text" id="search-keyword" class="form-input" placeholder="이름 또는 ID 검색..." />
            </div>
        </div>

        <!-- 사용자 리스트 스크롤 구역 -->
        <div class="agent-list" id="agent-list-container">
            <!-- AJAX로 요원 항목들이 동적 생성됩니다 -->
        </div>
    </div>

    <!-- 2. 우측: 현대적 그리드 배치의 사용자 상세/등록 패널 -->
    <div class="agent-card detail-panel">
        <div class="panel-header">
            <h3 class="panel-title" id="form-title"><i class="fa-solid fa-user-gear"></i> 사용자 상세 정보</h3>
            <span class="badge badge-active" id="status-badge">상태</span>
        </div>

        <form id="agent-form" class="info-form">
		    <!-- 모드 구분 (create / update) -->
		    <input type="hidden" id="form-mode" value="create" />
		
		    <!-- 항상 보이는 상단 프로필 요약 헤더 -->
		    <div class="profile-preview-card" id="profile-card">
		        <div class="avatar-box">
		            <i class="fa-solid fa-user-shield" id="profile-avatar-icon"></i>
		        </div>
		        <div class="profile-info-text">
		            <h4 id="preview-name">사용자 관리</h4>
		            <p id="preview-id-text">좌측 목록에서 사용자를 선택하거나 신규 등록을 진행하세요.</p>
		        </div>
		    </div>
		
		    <!-- [숨김 대상] 사용자를 선택하거나 신규등록 클릭 시에만 나타나는 폼 영역 -->
		    <div id="form-body-wrapper" style="display: none;">
		        <!-- 2컬럼 Form Grid 배치 -->
		        <div class="form-grid">
		            <!-- 아이디 (1열) -->
		            <div class="form-group">
		                <label class="form-label"><i class="fa-solid fa-id-badge"></i> 사용자 ID</label>
		                <input type="text" id="userId" name="userId" class="form-input" placeholder="아이디 입력" required />
		            </div>
		
		            <!-- 비밀번호 (2열) -->
		            <div class="form-group">
		                <label class="form-label"><i class="fa-solid fa-lock"></i> 비밀번호</label>
		                <input type="password" id="userPw" name="userPw" class="form-input" placeholder="비밀번호 (수정 시 미입력)" />
		            </div>
		
		            <!-- 이름 (1열) -->
		            <div class="form-group">
		                <label class="form-label"><i class="fa-solid fa-signature"></i> 이름</label>
		                <input type="text" id="userName" name="userName" class="form-input" placeholder="성명 입력" required />
		            </div>
		
		            <!-- 연락처 (2열) -->
		            <div class="form-group">
		                <label class="form-label"><i class="fa-solid fa-phone"></i> 연락처</label>
		                <input type="text" id="phone" name="phone" class="form-input" placeholder="010-0000-0000" />
		            </div>
		
		            <!-- 이메일 (전체 너비 차지) -->
		            <div class="form-group full-width">
		                <label class="form-label"><i class="fa-solid fa-envelope"></i> 이메일 주소</label>
		                <input type="email" id="email" name="email" class="form-input" placeholder="example@aurora.com" />
		            </div>
		        </div>
		
		        <!-- 계정 설정 & 스위치 섹션 -->
		        <div class="form-section-title">계정 권한 및 상태</div>
		        <div class="form-group row-group">
		            <div class="switch-label-group">
		                <span class="switch-title">계정 활성화</span>
		                <span class="switch-desc">비활성화 시 해당 사용자의 로그인 및 관제 시스템 접근이 제한됩니다.</span>
		            </div>
		            <label class="switch">
		                <input type="checkbox" id="enabled" checked />
		                <span class="slider"></span>
		            </label>
		        </div>
		
		        <!-- 하단 버튼 영역 -->
		        <div class="form-actions">
		            <button type="submit" class="btn-success" id="btn-save">
		                <i class="fa-solid fa-floppy-disk"></i> 저장하기
		            </button>
		        </div>
		    </div>
		</form>
    </div>
</div>

<script>
$(document).ready(function() {
    let agentCache = [];

    // 1. 전체 목록 로드
    loadAgentList();

    function loadAgentList() {
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/api/agents',
            type: 'GET',
            success: function(data) {
                agentCache = data;
                renderAgentList(data);
            },
            error: function() {
                alert('요원 목록을 불러오는 중 오류가 발생했습니다.');
            }
        });
    }

    // 2. 목록 렌더링 (원래 가지고 계시던 안전한 문자열 조합 방식 유지)
    function renderAgentList(list) {
        const $container = $('#agent-list-container').empty();

        if (!list || list.length === 0) {
            $container.append('<div class="empty-msg">등록된 요원이 없습니다.</div>');
            return;
        }

        list.forEach(function(agent) {
            const isEnabled = agent.enabled === 1 || agent.enabled === true || agent.enabled === 'Y';
            const badgeClass = isEnabled ? 'badge-active' : 'badge-inactive';
            const badgeText = isEnabled ? '활성' : '비활성';

            const phoneText = agent.phone ? agent.phone : '-';
            const emailText = agent.email ? agent.email : '-';

            // 백틱 대신 기존 원래 방식인 + 연산자로 조합하여 JSP EL 충돌 원천 차단
            let html = '';
            html += '<div class="agent-item" data-id="' + agent.userId + '">';
            html += '   <div class="agent-item-header">';
            html += '       <span class="agent-name">' + agent.userName + ' <small>(' + agent.userId + ')</small></span>';
            html += '       <span class="badge ' + badgeClass + '">' + badgeText + '</span>';
            html += '   </div>';
            html += '   <div class="agent-item-info">';
            html += '       <span><i class="fa-solid fa-phone"></i> ' + phoneText + '</span>';
            html += '       <span><i class="fa-solid fa-envelope"></i> ' + emailText + '</span>';
            html += '   </div>';
            html += '</div>';

            const $item = $(html);

            $item.on('click', function() {
                $('.agent-item').removeClass('active');
                $(this).addClass('active');
                selectAgent(agent);
            });

            $container.append($item);
        });
    }

 // 3. 요원 선택 시 (폼 영역 보이기)
    function selectAgent(agent) {
        $('#form-mode').val('update');
        $('#form-title').html('<i class="fa-solid fa-user-pen"></i> 요원 정보 수정');
        $('#userId').val(agent.userId).prop('readonly', true);
        $('#userPw').val('');
        $('#userName').val(agent.userName);
        $('#phone').val(agent.phone);
        $('#email').val(agent.email);
        $('#enabled').prop('checked', agent.enabled === 1 || agent.enabled === true || agent.enabled === 'Y');
        
        // 헤더 프로필 정보 업데이트
        $('#preview-name').text(agent.userName);
        $('#preview-id-text').text('ID: ' + agent.userId + ' | ' + (agent.email ? agent.email : '이메일 미등록'));

        // 하단 폼 영역 표시
        $('#form-body-wrapper').fadeIn(200);

        const isEnabled = agent.enabled === 1 || agent.enabled === true || agent.enabled === 'Y';
        $('#status-badge')
            .attr('class', isEnabled ? 'badge badge-active' : 'badge badge-inactive')
            .text(isEnabled ? '계정 활성' : '계정 비활성');
    }

    // 4. 신규 등록 버튼 (폼 영역 보이기)
    $('#btn-reset-form').on('click', function() {
        $('.agent-item').removeClass('active');
        $('#form-mode').val('create');
        $('#form-title').html('<i class="fa-solid fa-user-plus"></i> 신규 요원 등록');
        $('#userId').val('').prop('readonly', false);
        $('#agent-form')[0].reset();
        $('#enabled').prop('checked', true);

        // 헤더 텍스트 변경
        $('#preview-name').text('신규 사용자 작성');
        $('#preview-id-text').text('시스템 계정을 생성하려면 아래 정보를 입력하세요.');

        // 하단 폼 영역 표시
        $('#form-body-wrapper').fadeIn(200);

        $('#status-badge').attr('class', 'badge badge-active').text('신규 작성');
    });

 // 5. 폼 제출 (등록/수정 AJAX)
    $('#agent-form').on('submit', function(e) {
        e.preventDefault();

        const mode = $('#form-mode').val();
        const method = mode === 'create' ? 'POST' : 'PUT';

        const payload = {
            userId: $('#userId').val(),
            userPw: $('#userPw').val(),
            userName: $('#userName').val(),
            phone: $('#phone').val(),
            email: $('#email').val(),
            enabled: $('#enabled').is(':checked') ? 1 : 0
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/admin/api/agents',
            type: method,
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: function(res) {
                if (res.success) {
                    alert(mode === 'create' ? '신규 요원이 등록되었습니다.' : '요원 정보가 수정되었습니다.');
                    
                    // 1) 좌측 목록 다시 로드 (메인 화면 요원 관리 패널)
                    loadAgentList();

                    // 💡 [핵심 추가] 저장 성공 시 우측 사이드바의 요원 목록도 즉시 새로고침!
                    if (typeof loadAdminAgentList === 'function') {
                        loadAdminAgentList();
                    }

                    if(mode === 'create') {
                        // 신규 등록 시 폼 초기화
                        $('#btn-reset-form').click();
                    } else {
                        // 2) 수정 시 [우측 상단 프로필 카드] 즉시 반영
                        $('#preview-name').text(payload.userName);
                        $('#preview-id-text').text('ID: ' + payload.userId + ' | ' + (payload.email ? payload.email : '이메일 미등록'));
                        
                        // 3) 비밀번호 입력란 비우기
                        $('#userPw').val('');
                    }
                } else {
                    alert('처리에 실패했습니다.');
                }
            },
            error: function() {
                alert('서버 통신 중 오류가 발생했습니다.');
            }
        });
    });

    // 6. 검색 필터링
    $('#search-keyword').on('keyup', function() {
        const kw = $(this).val().toLowerCase();
        const filtered = agentCache.filter(function(a) {
            const nameMatch = a.userName ? a.userName.toLowerCase().includes(kw) : false;
            const idMatch = a.userId ? a.userId.toLowerCase().includes(kw) : false;
            return nameMatch || idMatch;
        });
        renderAgentList(filtered);
    });
});
</script>