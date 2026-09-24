<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="agent-container" style="height: calc(100vh - 100px); min-height: 680px;">
    <!-- 1. 좌측: 사용자 목록 패널 -->
    <div class="agent-card list-panel" style="display: flex; flex-direction: column; height: 100%;">
        <div class="panel-header">
            <h3 class="panel-title"><i class="fa-solid fa-users"></i> 사용자 목록</h3>
            <button type="button" class="mini-btn primary" id="btn-reset-form">
                <i class="fa-solid fa-user-plus"></i> 신규 등록
            </button>
        </div>

        <!-- 🎯 [수정] 검색 및 필터 영역 (1줄로 깨짐 없이 고정) -->
        <div class="search-box" style="display: flex; gap: 6px; align-items: center; margin-bottom: 10px; flex-wrap: nowrap;">
            <div class="search-input-wrapper" style="flex: 1; min-width: 0;">
                <i class="fa-solid fa-magnifying-glass search-icon"></i>
                <input type="text" id="search-keyword" class="form-input" placeholder="이름/ID..." style="padding-left: 30px; font-size: 12px; text-overflow: ellipsis;" />
            </div>

            <select id="filter-role" class="form-input" style="width: 82px; padding: 6px 4px; font-size: 12px; flex-shrink: 0;">
                <option value="ALL">전체권한</option>
                <option value="ROLE_AGENT">안전요원</option>
                <option value="ROLE_CONTROL">관제사</option>
            </select>

            <select id="filter-status" class="form-input" style="width: 80px; padding: 6px 4px; font-size: 12px; flex-shrink: 0;">
                <option value="ALL">전체상태</option>
                <option value="ACTIVE">활성</option>
                <option value="INACTIVE">비활성</option>
            </select>
        </div>

        <!-- 사용자 리스트 구역 -->
        <div class="agent-list" id="agent-list-container" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
            <!-- AJAX 동적 생성 -->
        </div>
    </div>

    <!-- 2. 우측: 상세/등록 패널 (🎯 내부 스크롤 추가로 저장버튼 잘림 방지) -->
    <div class="agent-card detail-panel" style="display: flex; flex-direction: column; height: 100%; overflow-y: auto;">
        <div class="panel-header">
            <h3 class="panel-title" id="form-title"><i class="fa-solid fa-user-gear"></i> 사용자 상세 정보</h3>
            <span class="badge badge-active" id="status-badge">상태</span>
        </div>

        <form id="agent-form" class="info-form" style="flex: 1; display: flex; flex-direction: column;">
            <input type="hidden" id="form-mode" value="create" />

            <!-- 상단 프로필 요약 -->
            <div class="profile-preview-card" id="profile-card" style="margin-bottom: 12px;">
                <div class="avatar-box">
                    <i class="fa-solid fa-user-shield" id="profile-avatar-icon"></i>
                </div>
                <div class="profile-info-text">
                    <h4 id="preview-name">사용자 관리</h4>
                    <p id="preview-id-text">좌측 목록에서 사용자를 선택하거나 신규 등록을 진행하세요.</p>
                </div>
            </div>

            <!-- 🎯 [수정] 폼 바디에 overflow 적용하여 스크롤 생성 -->
            <div id="form-body-wrapper" style="display: none; flex: 1; overflow-y: auto; padding-right: 4px;">
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label"><i class="fa-solid fa-id-badge"></i> 사용자 ID</label>
                        <input type="text" id="userId" name="userId" class="form-input" placeholder="아이디 입력" required />
                    </div>

                    <div class="form-group">
                        <label class="form-label"><i class="fa-solid fa-lock"></i> 비밀번호</label>
                        <input type="password" id="userPw" name="userPw" class="form-input" placeholder="비밀번호 (수정 시 미입력)" />
                    </div>

                    <div class="form-group">
                        <label class="form-label"><i class="fa-solid fa-signature"></i> 이름</label>
                        <input type="text" id="userName" name="userName" class="form-input" placeholder="성명 입력" required />
                    </div>

                    <div class="form-group">
                        <label class="form-label"><i class="fa-solid fa-phone"></i> 연락처</label>
                        <input type="text" id="phone" name="phone" class="form-input" placeholder="010-0000-0000" />
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label"><i class="fa-solid fa-envelope"></i> 이메일 주소</label>
                        <input type="email" id="email" name="email" class="form-input" placeholder="example@aurora.com" />
                    </div>
                </div>

                <div class="form-section-title" style="margin-top: 10px;">계정 권한 및 상태</div>

                <div class="form-group" style="margin-bottom: 12px;">
                    <label class="form-label"><i class="fa-solid fa-user-shield"></i> 사용자 권한</label>
                    <select id="roleName" name="roleName" class="form-input">
                        <option value="ROLE_AGENT">안전요원</option>
                        <option value="ROLE_CONTROL">관제사</option>
                    </select>
                </div>

                <div class="form-group row-group" style="margin-bottom: 16px;">
                    <div class="switch-label-group">
                        <span class="switch-title">계정 활성화</span>
                        <span class="switch-desc">비활성화 시 로그인 및 시스템 접근이 제한됩니다.</span>
                    </div>
                    <label class="switch">
                        <input type="checkbox" id="enabled" checked />
                        <span class="slider"></span>
                    </label>
                </div>

                <!-- 하단 저장 버튼 영역 -->
                <div class="form-actions" style="margin-top: 10px; margin-bottom: 10px;">
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
    let currentAgentPage = 1;
    const AGENT_PAGE_SIZE = 5;

    loadAgentList();

    function loadAgentList() {
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/api/agents',
            type: 'GET',
            success: function(data) {
                agentCache = data || [];
                currentAgentPage = 1;
                renderAgentList(agentCache);
            },
            error: function() {
                alert('요원 목록을 불러오는 중 오류가 발생했습니다.');
            }
        });
    }

    function renderAgentList(list) {
        const $container = $('#agent-list-container').empty();

        if (!list || list.length === 0) {
            $container.append('<div class="empty-msg" style="text-align:center; padding: 40px 0; color: #94a3b8;">등록된 요원이 없습니다.</div>');
            return;
        }

        const totalPages = Math.ceil(list.length / AGENT_PAGE_SIZE) || 1;

        if (currentAgentPage > totalPages) currentAgentPage = totalPages;
        if (currentAgentPage < 1) currentAgentPage = 1;

        const startIndex = (currentAgentPage - 1) * AGENT_PAGE_SIZE;
        const pageList = list.slice(startIndex, startIndex + AGENT_PAGE_SIZE);

        const $listWrapper = $('<div>').addClass('agent-items-wrapper');

        pageList.forEach(function(agent) {
            const isEnabled = agent.enabled === 1 || agent.enabled === true || agent.enabled === 'Y';
            const badgeClass = isEnabled ? 'badge-active' : 'badge-inactive';
            const badgeText = isEnabled ? '활성' : '비활성';

            const phoneText = agent.phone ? agent.phone : '-';
            const emailText = agent.email ? agent.email : '-';

            const isAdmin = agent.roleName === 'ROLE_ADMIN' || 
                            (agent.userId && agent.userId.toLowerCase().includes('admin')) || 
                            agent.userName === '관리자';

            let nameDisplayHtml = '';
            if (isAdmin) {
                nameDisplayHtml = agent.userName;
            } else {
                let roleText = '안전요원';
                if (agent.roleName === 'ROLE_CONTROL' || (agent.userId && agent.userId.toLowerCase().includes('control'))) {
                    roleText = '관제사';
                }
                nameDisplayHtml = agent.userName + ' <small>(' + roleText + ')</small>';
            }

            let html = '';
            html += '<div class="agent-item" data-id="' + agent.userId + '">';
            html += '   <div class="agent-item-header">';
            html += '       <span class="agent-name">' + nameDisplayHtml + '</span>';
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

            $listWrapper.append($item);
        });

        // 부족한 카드 개수만큼 더미 생성
        for (let i = pageList.length; i < AGENT_PAGE_SIZE; i++) {
            let dummyHtml = '';
            dummyHtml += '<div class="agent-item" style="visibility: hidden; background: transparent; border-color: transparent; pointer-events: none;">';
            dummyHtml += '   <div class="agent-item-header"><span class="agent-name">&nbsp;</span></div>';
            dummyHtml += '   <div class="agent-item-info"><span>&nbsp;</span></div>';
            dummyHtml += '</div>';
            $listWrapper.append(dummyHtml);
        }

        $container.append($listWrapper);

        // 🎯 [수정] 페이징 여백 축소 (margin-top: 6px)
        if (totalPages > 1) {
            const $pagination = $('<div class="agent-pagination">').css({
                'display': 'flex',
                'justify-content': 'center',
                'align-items': 'center',
                'gap': '4px',
                'margin-top': '6px',
                'padding-top': '4px'
            });

            const $prevBtn = $('<button type="button">&lt;</button>').css({
                'background': 'rgba(255, 255, 255, 0.05)',
                'border': '1px solid rgba(255, 255, 255, 0.1)',
                'color': currentAgentPage > 1 ? '#fff' : '#475569',
                'padding': '3px 8px',
                'border-radius': '4px',
                'font-size': '12px',
                'cursor': currentAgentPage > 1 ? 'pointer' : 'default'
            }).prop('disabled', currentAgentPage === 1);

            $prevBtn.on('click', function() {
                if (currentAgentPage > 1) {
                    currentAgentPage--;
                    renderAgentList(list);
                }
            });
            $pagination.append($prevBtn);

            for (let p = 1; p <= totalPages; p++) {
                (function(page) {
                    const isCurrent = (page === currentAgentPage);
                    const $pageBtn = $('<button type="button">' + page + '</button>').css({
                        'background': isCurrent ? '#38bdf8' : 'rgba(255, 255, 255, 0.05)',
                        'border': isCurrent ? '1px solid #38bdf8' : '1px solid rgba(255, 255, 255, 0.1)',
                        'color': isCurrent ? '#fff' : '#a0aec0',
                        'font-weight': isCurrent ? 'bold' : 'normal',
                        'padding': '3px 8px',
                        'border-radius': '4px',
                        'font-size': '12px',
                        'cursor': 'pointer'
                    });

                    $pageBtn.on('click', function() {
                        currentAgentPage = page;
                        renderAgentList(list);
                    });
                    $pagination.append($pageBtn);
                })(p);
            }

            const $nextBtn = $('<button type="button">&gt;</button>').css({
                'background': 'rgba(255, 255, 255, 0.05)',
                'border': '1px solid rgba(255, 255, 255, 0.1)',
                'color': currentAgentPage < totalPages ? '#fff' : '#475569',
                'padding': '3px 8px',
                'border-radius': '4px',
                'font-size': '12px',
                'cursor': currentAgentPage < totalPages ? 'pointer' : 'default'
            }).prop('disabled', currentAgentPage === totalPages);

            $nextBtn.on('click', function() {
                if (currentAgentPage < totalPages) {
                    currentAgentPage++;
                    renderAgentList(list);
                }
            });
            $pagination.append($nextBtn);

            $container.append($pagination);
        }
    }

    function selectAgent(agent) {
        $('#form-mode').val('update');
        $('#form-title').html('<i class="fa-solid fa-user-pen"></i> 요원 정보 수정');
        $('#userId').val(agent.userId).prop('readonly', true);
        $('#userPw').val('');
        $('#userName').val(agent.userName);
        $('#phone').val(agent.phone);
        $('#email').val(agent.email);
        
        $('#roleName').val(agent.roleName || 'ROLE_AGENT');
        $('#enabled').prop('checked', agent.enabled === 1 || agent.enabled === true || agent.enabled === 'Y');
        
        $('#preview-name').text(agent.userName);
        $('#preview-id-text').text('ID: ' + agent.userId + ' | ' + (agent.email ? agent.email : '이메일 미등록'));

        $('#form-body-wrapper').fadeIn(200);

        const isEnabled = agent.enabled === 1 || agent.enabled === true || agent.enabled === 'Y';
        $('#status-badge')
            .attr('class', isEnabled ? 'badge badge-active' : 'badge badge-inactive')
            .text(isEnabled ? '계정 활성' : '계정 비활성');
    }

    $('#btn-reset-form').on('click', function() {
        $('.agent-item').removeClass('active');
        $('#form-mode').val('create');
        $('#form-title').html('<i class="fa-solid fa-user-plus"></i> 신규 요원 등록');
        $('#userId').val('').prop('readonly', false);
        $('#agent-form')[0].reset();
        
        $('#roleName').val('ROLE_AGENT');
        $('#enabled').prop('checked', true);

        $('#preview-name').text('신규 사용자 작성');
        $('#preview-id-text').text('시스템 계정을 생성하려면 아래 정보를 입력하세요.');

        $('#form-body-wrapper').fadeIn(200);
        $('#status-badge').attr('class', 'badge badge-active').text('신규 작성');
    });

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
            roleName: $('#roleName').val(),
            enabled: $('#enabled').is(':checked') ? 1 : 0
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/admin/api/agents',
            type: method,
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: function(res) {
                if (res.success) {
                    alert(mode === 'create' ? '신규 사용자가 등록되었습니다.' : '사용자 정보가 수정되었습니다.');
                    loadAgentList();

                    if (typeof loadAdminAgentList === 'function') {
                        loadAdminAgentList();
                    }

                    if(mode === 'create') {
                        $('#btn-reset-form').click();
                    } else {
                        $('#preview-name').text(payload.userName);
                        $('#preview-id-text').text('ID: ' + payload.userId + ' | ' + (payload.email ? payload.email : '이메일 미등록'));
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

    function filterAgentList() {
        currentAgentPage = 1;

        const kw = $('#search-keyword').val().toLowerCase().trim();
        const selectedRole = $('#filter-role').val();
        const selectedStatus = $('#filter-status').val();

        const filtered = agentCache.filter(function(a) {
            const nameMatch = a.userName ? a.userName.toLowerCase().includes(kw) : false;
            const idMatch = a.userId ? a.userId.toLowerCase().includes(kw) : false;
            const keywordMatch = kw === '' || nameMatch || idMatch;

            let roleMatch = true;
            if (selectedRole !== 'ALL') {
                if (selectedRole === 'ROLE_CONTROL') {
                    roleMatch = a.roleName === 'ROLE_CONTROL' || (a.userId && a.userId.includes('control'));
                } else if (selectedRole === 'ROLE_AGENT') {
                    roleMatch = a.roleName === 'ROLE_AGENT' || (a.userId && a.userId.includes('agent'));
                }
            }

            let statusMatch = true;
            const isEnabled = a.enabled === 1 || a.enabled === true || a.enabled === 'Y' || a.enabled === '1';
            if (selectedStatus === 'ACTIVE') {
                statusMatch = isEnabled;
            } else if (selectedStatus === 'INACTIVE') {
                statusMatch = !isEnabled;
            }

            return keywordMatch && roleMatch && statusMatch;
        });

        renderAgentList(filtered);
    }

    $('#search-keyword').on('keyup', filterAgentList);
    $('#filter-role').on('change', filterAgentList);
    $('#filter-status').on('change', filterAgentList);
});
</script>