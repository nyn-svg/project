<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<div class="agent-container">
    <!-- 1. 좌측: 안전요원 목록 패널 -->
    <div class="agent-card list-panel">
        <div class="panel-header">
            <h3 class="panel-title"><i class="fa-solid fa-users"></i> 사용자 목록</h3>
            <button type="button" class="mini-btn primary" id="btn-reset-form">
                <i class="fa-solid fa-plus"></i> 신규 등록
            </button>
        </div>

        <!-- 검색 영역 -->
        <div class="search-box">
            <input type="text" id="search-keyword" class="form-input" placeholder="이름 또는 ID 검색..." />
            <button type="button" class="mini-btn" id="btn-search"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>

        <!-- 요원 리스트 스크롤 구역 -->
        <div class="agent-list" id="agent-list-container">
            <!-- AJAX로 요원 항목들이 동적 생성됩니다 -->
        </div>
    </div>

    <!-- 2. 우측: 요원 상세 및 등록/수정 폼 패널 -->
    <div class="agent-card detail-panel">
        <div class="panel-header">
            <h3 class="panel-title" id="form-title"><i class="fa-solid fa-user-gear"></i>사용자 상세 정보</h3>
            <span class="badge badge-active" id="status-badge">상태</span>
        </div>

        <form id="agent-form" class="info-form">
            <!-- 모드 구분 (create / update) -->
            <input type="hidden" id="form-mode" value="create" />

            <div class="form-group">
                <label class="form-label">사용자 ID</label>
                <input type="text" id="userId" name="userId" class="form-input" placeholder="아이디 입력" required />
            </div>

            <div class="form-group">
                <label class="form-label">비밀번호</label>
                <input type="password" id="userPw" name="userPw" class="form-input" placeholder="비밀번호 (수정 시 미입력 유지)" />
            </div>

            <div class="form-group">
                <label class="form-label">이름</label>
                <input type="text" id="userName" name="userName" class="form-input" placeholder="이름 입력" required />
            </div>

            <div class="form-group">
                <label class="form-label">연락처</label>
                <input type="text" id="phone" name="phone" class="form-input" placeholder="010-0000-0000" />
            </div>

            <div class="form-group">
                <label class="form-label">이메일</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="example@aurora.com" />
            </div>

            <div class="form-group row-group">
                <label class="form-label">계정 활성화 상태</label>
                <label class="switch">
                    <input type="checkbox" id="enabled" checked />
                    <span class="slider"></span>
                </label>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-success" id="btn-save">
                    <i class="fa-solid fa-check"></i> 저장하기
                </button>
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

    // 2. 목록 렌더링
    function renderAgentList(list) {
    const $container =$('#agent-list-container').empty();

    if (!list || list.length === 0) {
        $container.append('<div class="empty-msg">등록된 요원이 없습니다.</div>');
        return;
    }

    list.forEach(agent => {
        const isEnabled = agent.enabled === 1;
        const badgeClass = isEnabled ? 'badge-active' : 'badge-inactive';
        const badgeText = isEnabled ? '활성' : '비활성';

        // $ 앞에 \ 를 추가하여 JSP EL과의 충돌 방지
        const $item =$(`
            <div class="agent-item" data-id="\${agent.userId}">
                <div class="agent-item-header">
                    <span class="agent-name">\${agent.userName} (\${agent.userId})</span>
                    <span class="badge \${badgeClass}">\${badgeText}</span>
                </div>
                <div class="agent-item-info">
                    <span><i class="fa-solid fa-phone"></i> \${agent.phone || '-'}</span>
                    <span><i class="fa-solid fa-envelope"></i> \${agent.email || '-'}</span>
                </div>
            </div>
        `);

        $item.on('click', function() {
            $('.agent-item').removeClass('active');
            $(this).addClass('active');
            selectAgent(agent);
        });

        $container.append($item);
    });
}

    // 3. 요원 선택 시 폼에 데이터 바인딩 (수정 모드)
    function selectAgent(agent) {
        $('#form-mode').val('update');
        $('#form-title').html('<i class="fa-solid fa-user-pen"></i> 요원 정보 수정');
        $('#userId').val(agent.userId).prop('readonly', true);
        $('#userPw').val('');
        $('#userName').val(agent.userName);
        $('#phone').val(agent.phone);
        $('#email').val(agent.email);
        $('#enabled').prop('checked', agent.enabled === 1);
        
        $('#status-badge')
            .attr('class', agent.enabled === 1 ? 'badge badge-active' : 'badge badge-inactive')
            .text(agent.enabled === 1 ? '계정 활성' : '계정 비활성');
    }

    // 4. 신규 등록 버튼 (폼 리셋)
    $('#btn-reset-form').on('click', function() {
        $('.agent-item').removeClass('active');
        $('#form-mode').val('create');
        $('#form-title').html('<i class="fa-solid fa-user-plus"></i> 신규 요원 등록');
        $('#userId').val('').prop('readonly', false);
        $('#agent-form')[0].reset();
        $('#enabled').prop('checked', true);
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
                    loadAgentList();
                    if(mode === 'create') $('#btn-reset-form').click();
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
        const filtered = agentCache.filter(a => 
            a.userName.toLowerCase().includes(kw) || a.userId.toLowerCase().includes(kw)
        );
        renderAgentList(filtered);
    });
});
</script>