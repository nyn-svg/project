<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="agent-container">
    <!-- 1. 좌측: 등록된 문항 목록 패널 -->
    <div class="agent-card list-panel">
        <div class="panel-header">
            <h3 class="panel-title"><i class="fa-solid fa-list-check"></i> 체크리스트 문항 목록</h3>
            <button type="button" class="mini-btn primary" id="btn-reset-form">
                <i class="fa-solid fa-plus"></i> 문항 추가
            </button>
        </div>

        <!-- 상단 탭: 안전요원 / 관제사 구분 -->
        <div class="tab-group" style="display: flex; gap: 8px; margin-bottom: 12px;">
            <button type="button" class="mini-btn target-tab active" data-target="AGENT" style="flex: 1; padding: 8px; font-weight: bold;">
                <i class="fa-solid fa-user-shield"></i> 안전요원용
            </button>
            <button type="button" class="mini-btn target-tab" data-target="CONTROL" style="flex: 1; padding: 8px; font-weight: bold;">
                <i class="fa-solid fa-headset"></i> 관제사용
            </button>
        </div>

        <!-- 문항 리스트 스크롤 구역 -->
        <div class="agent-list" id="item-list-container">
            <!-- AJAX로 문항 항목들이 동적 생성됩니다 -->
        </div>
    </div>

    <!-- 2. 우측: 문항 등록 및 수정 패널 -->
    <div class="agent-card detail-panel">
        <div class="panel-header">
            <h3 class="panel-title" id="form-title"><i class="fa-solid fa-pen-to-square"></i> 문항 상세 정보</h3>
            <span class="badge badge-active" id="target-badge">안전요원</span>
        </div>

        <form id="checklist-form" class="info-form">
            <!-- 모드 구분 (create / update) 및 PK -->
            <input type="hidden" id="form-mode" value="create" />
            <input type="hidden" id="itemId" name="itemId" value="" />
            <input type="hidden" id="targetType" name="targetType" value="AGENT" />

            <!-- 상단 요약 헤더 -->
            <div class="profile-preview-card">
                <div class="avatar-box">
                    <i class="fa-solid fa-clipboard-question" id="preview-icon"></i>
                </div>
                <div class="profile-info-text">
                    <h4 id="preview-title">문항 관리</h4>
                    <p id="preview-sub-text">좌측 목록에서 문항을 선택하거나 신규 문항을 등록하세요.</p>
                </div>
            </div>

            <!-- 폼 입력 영역 -->
            <div id="form-body-wrapper">
                <div class="form-grid">
                    <!-- 분야 / 카테고리 -->
                    <div class="form-group full-width">
                        <label class="form-label"><i class="fa-solid fa-layer-group"></i> 분야 (카테고리)</label>
                        <input type="text" id="category" name="category" class="form-input" placeholder="예: 1. 인파 밀집 및 수송 관리" required />
                    </div>

                    <!-- 항목명 (소제목) -->
                    <div class="form-group full-width">
                        <label class="form-label"><i class="fa-solid fa-heading"></i> 항목명 (소제목)</label>
                        <input type="text" id="itemTitle" name="itemTitle" class="form-input" placeholder="예: 비상 대피로 확보" required />
                    </div>

                    <!-- 질문 내용 -->
                    <div class="form-group full-width">
                        <label class="form-label"><i class="fa-solid fa-question-circle"></i> 점검 질문 내용</label>
                        <textarea id="question" name="question" class="form-input" rows="3" placeholder="예: 관람객 이동 동선 및 비상 대피로에 병목 현상이나 장애물이 없는가?" style="resize: vertical; min-height: 80px;" required></textarea>
                    </div>

                    <!-- 정렬 순서 -->
                    <div class="form-group">
                        <label class="form-label"><i class="fa-solid fa-arrow-down-1-9"></i> 정렬 순서</label>
                        <input type="number" id="sortOrder" name="sortOrder" class="form-input" value="1" min="1" required />
                    </div>

                    <!-- 사용 여부 스위치 -->
                    <div class="form-group row-group" style="align-items: center;">
                        <div class="switch-label-group">
                            <span class="switch-title">문항 사용 여부</span>
                            <span class="switch-desc">비활성화 시 해당 문항은 사용자 체크리스트에서 숨겨집니다.</span>
                        </div>
                        <label class="switch">
                            <input type="checkbox" id="isUse" checked />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>

                <!-- 하단 버튼 영역 -->
                <div class="form-actions" style="display: flex; gap: 8px;">
                    <button type="button" class="btn-danger" id="btn-delete" style="display: none; background: #e74c3c; color: #fff; border: none; padding: 10px 16px; border-radius: 6px; cursor: pointer;">
                        <i class="fa-solid fa-trash"></i> 삭제하기
                    </button>
                    <button type="submit" class="btn-success" id="btn-save" style="flex: 1;">
                        <i class="fa-solid fa-floppy-disk"></i> 저장하기
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
$(document).ready(function() {
    let currentTarget = 'AGENT'; // 기본값: 안전요원

    // 1. 초기 로드
    loadChecklistItems(currentTarget);

    // 탭 전환 이벤트 (안전요원 <-> 관제사)
    $('.target-tab').on('click', function() {
        $('.target-tab').removeClass('active').css({'background': '', 'color': ''});
        $(this).addClass('active').css({'background': '#007bff', 'color': '#fff'});

        currentTarget = $(this).data('target');
        $('#targetType').val(currentTarget);
        $('#target-badge').text(currentTarget === 'AGENT' ? '안전요원' : '관제사');

        resetForm();
        loadChecklistItems(currentTarget);
    });

    // 2. 문항 목록 로드 AJAX
    function loadChecklistItems(target) {
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/api/checklist/items',
            type: 'GET',
            data: { targetType: target },
            success: function(data) {
                renderItemList(data);
            },
            error: function() {
                alert('문항 목록을 불러오는 중 오류가 발생했습니다.');
            }
        });
    }

    // 3. 목록 렌더링
    function renderItemList(list) {
        const $container = $('#item-list-container').empty();

        if (!list || list.length === 0) {
            $container.append('<div class="empty-msg" style="padding: 20px; text-align: center; color: #888;">등록된 문항이 없습니다.</div>');
            return;
        }

        list.forEach(function(item) {
            const isUse = item.isUse === 'Y';
            const badgeClass = isUse ? 'badge-active' : 'badge-inactive';
            const badgeText = isUse ? '사용중' : '숨김';

            let html = '';
            html += '<div class="agent-item" data-id="' + item.itemId + '" style="padding: 12px; border-bottom: 1px solid #eee; cursor: pointer;">';
            html += '   <div class="agent-item-header" style="display: flex; justify-content: space-between; align-items: center;">';
            html += '       <span class="agent-name" style="font-weight: bold; font-size: 14px;">[' + item.sortOrder + '] ' + item.itemTitle + '</span>';
            html += '       <span class="badge ' + badgeClass + '">' + badgeText + '</span>';
            html += '   </div>';
            html += '   <div class="agent-item-info" style="font-size: 12px; color: #666; margin-top: 4px;">';
            html += '       <div style="color: #007bff; font-weight: 500;">' + item.category + '</div>';
            html += '       <div style="text-overflow: ellipsis; overflow: hidden; white-space: nowrap; max-width: 280px;">' + item.question + '</div>';
            html += '   </div>';
            html += '</div>';

            const $item = $(html);

            $item.on('click', function() {
                $('.agent-item').removeClass('active').css('background', '');
                $(this).addClass('active').css('background', '#eef5ff');
                selectItem(item);
            });

            $container.append($item);
        });
    }

    // 4. 문항 선택 시 폼에 채우기
    function selectItem(item) {
        $('#form-mode').val('update');
        $('#itemId').val(item.itemId);
        $('#form-title').html('<i class="fa-solid fa-pen-to-square"></i> 문항 수정');
        
        $('#category').val(item.category);
        $('#itemTitle').val(item.itemTitle);
        $('#question').val(item.question);
        $('#sortOrder').val(item.sortOrder);
        $('#isUse').prop('checked', item.isUse === 'Y');

        $('#preview-title').text(item.itemTitle);
        $('#preview-sub-text').text(item.category);

        $('#btn-delete').show();
    }

    // 5. 신규 등록 버튼 (폼 초기화)
    $('#btn-reset-form').on('click', function() {
        resetForm();
    });

    function resetForm() {
        $('.agent-item').removeClass('active').css('background', '');
        $('#form-mode').val('create');
        $('#itemId').val('');
        $('#form-title').html('<i class="fa-solid fa-plus"></i> 신규 문항 등록');
        
        $('#checklist-form')[0].reset();
        $('#targetType').val(currentTarget);
        $('#isUse').prop('checked', true);

        $('#preview-title').text('신규 문항 작성');
        $('#preview-sub-text').text('선택한 대상(' + (currentTarget === 'AGENT' ? '안전요원' : '관제사') + ')에 추가될 문항을 작성하세요.');

        $('#btn-delete').hide();
    }

    // 6. 폼 제출 (등록/수정 AJAX)
    $('#checklist-form').on('submit', function(e) {
        e.preventDefault();

        const mode = $('#form-mode').val();
        const method = mode === 'create' ? 'POST' : 'PUT';

        const payload = {
            itemId: $('#itemId').val() ? parseInt($('#itemId').val()) : null,
            targetType: $('#targetType').val(),
            category: $('#category').val(),
            itemTitle: $('#itemTitle').val(),
            question: $('#question').val(),
            sortOrder: parseInt($('#sortOrder').val()),
            isUse: $('#isUse').is(':checked') ? 'Y' : 'N'
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/admin/api/checklist/items',
            type: method,
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: function(res) {
                if (res.success) {
                    alert(mode === 'create' ? '신규 문항이 등록되었습니다.' : '문항이 수정되었습니다.');
                    loadChecklistItems(currentTarget);
                    resetForm();
                } else {
                    alert('처리에 실패했습니다.');
                }
            },
            error: function() {
                alert('서버 통신 중 오류가 발생했습니다.');
            }
        });
    });

    // 7. 문항 삭제 AJAX
    $('#btn-delete').on('click', function() {
        const itemId = $('#itemId').val();
        if (!itemId) return;

        if (confirm('이 문항을 정말로 삭제하시겠습니까?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/api/checklist/items/' + itemId,
                type: 'DELETE',
                success: function(res) {
                    if (res.success) {
                        alert('문항이 삭제되었습니다.');
                        loadChecklistItems(currentTarget);
                        resetForm();
                    } else {
                        alert('삭제 실패했습니다.');
                    }
                },
                error: function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        }
    });
});
</script>