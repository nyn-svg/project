<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 2-1. 우측 60px 고정 퀵바 (아이콘 전용) -->
<aside class="quick-sidebar">
    <div class="quick-top">
        <button id="toggle-drawer-btn" class="quick-btn toggle-btn" title="사이드바 열기/닫기">
            ❮❮
        </button>
    </div>

    <nav class="quick-nav">
        <button class="quick-nav-item" data-target="panel-drones">
            <span class="nav-icon"><i class="fa-solid fa-mask-ventilator"></i></span>
            <span class="nav-label">드론</span>
        </button>
        <button class="quick-nav-item" data-target="panel-agent" id="btn-nav-agent" style="position: relative;">
		    <span class="nav-icon"><i class="fa-solid fa-triangle-exclamation"></i></span>
		    <span class="nav-label">긴급보고</span>
		    <span id="quick-agent-badge" class="quick-badge" style="display: none;">0</span>
		</button>
        <button class="quick-nav-item" data-target="panel-check">
            <span class="nav-icon"><i class="fa-solid fa-clipboard-check"></i></span>
            <span class="nav-label">체크리스트</span>
            <span id="check-badge" class="quick-badge" style="display: none;"></span>
        </button>
        <button class="quick-nav-item" data-target="panel-report">
            <span class="nav-icon"><i class="fa-solid fa-laptop-file"></i></span>
            <span class="nav-label">전자문서</span>
            <span id="report-badge" class="quick-badge" style="display: none;"></span>
        </button>
        <!-- 🎯 5) 사이드바 하단 고정 로그아웃 버튼 -->
	    <button type="button" class="quick-nav-item btn-sidebar-logout" onclick="location.href='${pageContext.request.contextPath}/logout'">
	        <span class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>
	        <span class="nav-label">로그아웃</span>
	    </button>
    </nav>
</aside>

<!-- 2-2. 왼쪽으로 열리는 260px 서브 드로어 패널 -->
<div id="sub-drawer" class="sub-drawer collapsed">
    <!-- 드론 관제 패널 -->
<!-- 드론 관제 패널 -->
<div id="panel-drones" class="drawer-content active">
<!-- 헤더 전체 높이를 40px로 고정하고 flex 수직 중앙 정렬 -->
<div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
    <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">드론 관리</span>
    
    <!-- 버튼 우측 컨테이너 (높이 및 flex 유지) -->
    <div class="header-btn-group" style="display: flex; align-items: center; height: 100%;">
        <!-- 일반 모드 시 노출 -->
        <div id="mode-default-btns" style="display: flex; align-items: center;">
            <button id="btn-edit-mode" class="mini-btn">
            <i class="fa-solid fa-gear"></i>
            </button>
        </div>
        
        <!-- 편집 모드 전환 시 노출 -->
        <div id="mode-edit-btns" style="display: none; gap: 4px; align-items: center;">
            <button id="btn-open-add-modal" class="mini-btn primary">+ 신규</button>
            <button id="btn-cancel-edit" class="mini-btn danger">취소</button>
        </div>
    </div>
</div>

    <!-- 2. 드론 목록 영역 (JS가 여기에 dynamic하게 버튼을 뿌려줍니다) -->
    <div class="drawer-body">
        

        <div id="drone-list-container" style="display: flex; flex-direction: column; gap: 10px;">
            <!-- JavaScript로 드론 목록이 렌더링됩니다 -->
        </div>
    </div>
</div>


    <div id="panel-agent" class="drawer-content">
		    <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; height: 40px; min-height: 40px;">
		        <span style="font-size: 15px; font-weight: 700; white-space: nowrap;">실시간 긴급보고</span>
		        <span id="situ-count-badge" style="color: #ff5252 !important; font-size: 13px !important; font-weight: 700 !important; -webkit-text-fill-color: #ff5252 !important;">(0건)</span>
		    </div>
		    
		    <div class="drawer-body">
		        <!-- 실시간 카드 리스트 컨테이너 -->
		        <div id="situation-list-container" style="display: flex; flex-direction: column; gap: 10px;">
		            <!-- JS가 SSE 이벤트를 받아 여기에 카드를 동적으로 추가합니다 -->
		        </div>
		    </div>
		</div>

    <div id="panel-check" class="drawer-content">
    <!-- 패널 헤더 -->
    <div class="drawer-header" style="display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid rgba(255, 255, 255, 0.1);">
        <span style="font-weight: 700; font-size: 15px; color: #f8fafc;">📋 관제 시스템 체크리스트</span>
        <button type="button" id="btn-refresh-checklist" title="새로고침" style="background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 14px;">
            🔄
        </button>
    </div>
    
    <!-- 체크리스트 아이템 목록이 비동기(AJAX)로 들어올 영역 -->
    <div class="drawer-body" style="padding: 16px; overflow-y: auto; height: calc(100vh - 140px);">
        <div id="control-checklist-container" style="display: flex; flex-direction: column; gap: 12px;">
            <div style="text-align: center; color: #94a3b8; padding: 30px 0; font-size: 13px;">
                체크리스트 항목을 불러오는 중...
            </div>
        </div>
    </div>

    <!-- 하단 저장 버튼 -->
    <div class="drawer-footer" style="padding: 12px 16px; border-top: 1px solid rgba(255, 255, 255, 0.1); background: #1e222d; position: absolute; bottom: 0; width: 100%; box-sizing: border-box;">
        <button type="button" id="btn-save-control-checklist" style="width: 100%; padding: 10px; background: #3b82f6; color: #ffffff; border: none; border-radius: 6px; font-weight: 600; font-size: 13px; cursor: pointer; transition: background 0.2s;" onmouseover="this.style.background='#2563eb'" onmouseout="this.style.background='#3b82f6'">
            체크리스트 저장
        </button>
    </div>
</div>


    <div id="panel-report" class="drawer-content">
        <div class="drawer-header">전자문서</div>
        <div class="drawer-body">
            <p>( 임시 )</p>
        </div>
    </div>
</div>

<!-- sidebar.jsp 최하단 위치, 새 드론 등록 모달창 -->
<div id="drone-modal" class="modal-overlay">
    <div class="modal-content">
        <h3 id="modal-title" style="color: #ffffff; margin-bottom: 16px; font-size: 16px;">드론 정보 수정</h3>
        
        <!-- 수정 대상 숨김 필드 -->
        <input type="hidden" id="modal-drone-id" />
        <input type="hidden" id="modal-drone-active" />
        
        <!-- 입력 창 -->
        <input type="text" id="modal-input-zone" class="modal-input" placeholder="비행 구역을 입력하세요" />
        <input type="text" id="modal-input-url" class="modal-input" placeholder="스트리밍 주소(URL)을 입력하세요" />
        <div class="modal-input-group" style="margin-top: 14px;">
		    <label style="font-size: 11px; color: #94a3b8; font-weight: 600;">드론 상태</label>
		    
		    <!-- 실제 데이터 전송용 숨김 input -->
		    <input type="hidden" id="modal-input-status" value="대기" />
		    
		    <div class="status-badge-group" style="display: flex; gap: 8px; margin-top: 8px;">
		        <button type="button" class="status-select-btn ready active" data-value="대기">대기</button>
		        <button type="button" class="status-select-btn flying" data-value="비행">비행</button>
		        <button type="button" class="status-select-btn error" data-value="고장">고장</button>
		    </div>
		</div>
        
        <div style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 20px;">
            <button id="btn-modal-save" class="mini-btn primary">저장</button>
            <button id="btn-modal-cancel" class="mini-btn">취소</button>
        </div>
    </div>
</div>





<!-- situation-modal: sidebar.jsp 최하단에 위치 -->
<div id="situation-modal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.7); z-index: 9999; justify-content: center; align-items: center;">
    <div class="modal-content" style="background: #1e222d; border: 1px solid #333; border-radius: 8px; padding: 20px; max-width: 420px; width: 90%; color: #fff; box-shadow: 0 10px 25px rgba(0,0,0,0.5);">
        
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #333; padding-bottom: 10px; margin-bottom: 15px;">
            <h3 id="situ-modal-title" style="color: #ffffff; font-size: 16px; margin: 0; font-weight: bold;">
                🚨 <span id="situ-modal-dngr-type">위험 상황</span>
            </h3>
            <button id="btn-situ-modal-close" type="button" style="background: none; border: none; color: #aaa; font-size: 22px; cursor: pointer; line-height: 1;">&times;</button>
        </div>
        
        <div style="display: flex; flex-direction: column; gap: 10px; font-size: 13px;">
            <div style="display: flex; justify-content: space-between;">
                <span><strong>발생 구역:</strong> <span id="situ-modal-zone" style="color: #e74c3c; font-weight: bold;">-</span></span>
                <span><strong>보고자:</strong> <span id="situ-modal-user" style="color: #3498db;">-</span></span>
            </div>
            <div><strong>보고 시각:</strong> <span id="situ-modal-time" style="color: #aaa;">-</span></div>
            
            <div style="margin-top: 5px;">
                <strong>상황 내용:</strong>
                <div id="situ-modal-content" style="background: #14161d; padding: 10px; border-radius: 4px; margin-top: 5px; min-height: 50px; white-space: pre-wrap; color: #ddd; border: 1px solid #2c303e;">-</div>
            </div>
            
            <!-- 첨부 사진 영역 -->
            <div id="situ-modal-img-wrapper" style="margin-top: 5px; display: none;">
                <strong>첨부 사진:</strong>
                <div style="margin-top: 5px; text-align: center; background: #000; border-radius: 4px; overflow: hidden;">
                    <img id="situ-modal-img" src="" alt="상황 사진" style="max-width: 100%; max-height: 250px; object-fit: contain;">
                </div>
            </div>
        </div>
        
        <div style="margin-top: 20px; text-align: right;">
            <button id="btn-situ-modal-confirm" type="button" class="mini-btn primary" style="padding: 6px 16px;">확인</button>
        </div>
    </div>
</div>


<script>
//==================================================
//관제사 체크리스트 (TARGET_TYPE = 'CONTROL')
//==================================================

//1. 관제사 체크리스트 목록 AJAX 조회 (아코디언 목록 형태)
function loadControlChecklist() {
 var basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : ((typeof ctx !== 'undefined') ? ctx : '');
 var $container = $('#control-checklist-container');
 
 if ($container.length === 0) return;
 $container.html('<div style="text-align:center; color:#94a3b8; padding:30px 0; font-size:13px;">체크리스트를 불러오는 중...</div>');

 $.ajax({
     url: basePath + '/control/checklist/api/list',
     type: 'GET',
     dataType: 'json',
     cache: false,
     success: function(data) {
         console.log('▼ 관제사 체크리스트 데이터 수신 완료:', data);
         $container.empty();

         if (!data || data.length === 0) {
             $container.html('<div style="text-align:center; color:#94a3b8; padding:30px 0; font-size:13px;">등록된 관제 점검 항목이 없습니다.</div>');
             return;
         }

         var html = '';
         data.forEach(function(item, index) {
             var itemNo = item.itemId || item.itemNo || item.ITEM_ID;
             var title = item.itemTitle || item.ITEM_TITLE || '점검 항목';
             var question = item.question || item.QUESTION || '';

             html += '<div class="control-chk-card" data-item-no="' + itemNo + '">'
                  // 헤더: 1. 제목 (클릭 시 아코디언 토글)
                  + '  <div class="chk-card-header">'
                  + '    <span class="chk-card-title">' + (index + 1) + '. ' + title + '</span>'
                  + '    <span class="chk-status-badge">미작성</span>'
                  + '  </div>'
                  
                  // 바디: 클릭 시 펼쳐지는 상세 점검 영역 (사진 디자인)
                  + '  <div class="chk-card-body">'
                  + '    <div class="chk-question-text">' + question + '</div>'
                  
               // 4가지 상태 선택 버튼 (value 값을 한글로 변경)
                  + '    <div class="chk-status-group">'
                  + '      <label class="chk-status-btn">'
                  + '        <input type="radio" name="status_' + itemNo + '" value="정상">'
                  + '        <span>정상</span>'
                  + '      </label>'
                  + '      <label class="chk-status-btn">'
                  + '        <input type="radio" name="status_' + itemNo + '" value="주의">'
                  + '        <span>주의</span>'
                  + '      </label>'
                  + '      <label class="chk-status-btn">'
                  + '        <input type="radio" name="status_' + itemNo + '" value="위험">'
                  + '        <span>위험</span>'
                  + '      </label>'
                  + '      <label class="chk-status-btn">'
                  + '        <input type="radio" name="status_' + itemNo + '" value="해당없음">'
                  + '        <span>해당없음</span>'
                  + '      </label>'
                  + '    </div>'
                  
                  // 비고 입력란
                  + '    <input type="text" class="chk-remark-input" placeholder="비고를 입력해주세요">'
                  + '  </div>'
                  + '</div>';
         });

         $container.html(html);
     },
     error: function(xhr, status, error) {
         console.error('🚨 체크리스트 조회 실패:', xhr.status, error);
         $container.html('<div style="text-align:center; color:#f87171; padding:30px 0; font-size:13px;">체크리스트 로드 실패 (상태코드: ' + xhr.status + ')</div>');
     }
 });
}
window.loadControlChecklist = loadControlChecklist;

//2. 관제사 체크리스트 저장
function saveControlChecklist() {
    var basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : ((typeof ctx !== 'undefined') ? ctx : '');
    var detailList = [];
    var uncheckedCount = 0;

    $('.control-chk-card').each(function() {
        var $card = $(this);
        var itemNo = $card.attr('data-item-no');
        var selectedStatus = $card.find('input[type="radio"]:checked').val();
        var remarkText = $card.find('.chk-remark-input').val();

        if (!selectedStatus) {
            uncheckedCount++;
        } else {
            detailList.push({
                itemNo: String(itemNo),
                statusCode: selectedStatus,
                remark: remarkText
            });
        }
    });

    if (uncheckedCount > 0) {
        alert('선택하지 않은 점검 항목이 ' + uncheckedCount + '개 있습니다. 모든 항목을 확인해 주세요.');
        return;
    }

    if (!confirm('체크리스트 점검 결과를 제출하시겠습니까?')) {
        return;
    }

    var masterDTO = {
        detailList: detailList
    };

    // CSRF 토큰 추출 (Spring Security 대응)
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");

    $.ajax({
        // 🎯 [수정] 백엔드 컨트롤러 경로에 맞춰 URL 변경
        url: basePath + '/control/checklist/api/submit', 
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(masterDTO),
        beforeSend: function(xhr) {
            // CSRF 토큰이 존재하는 경우 헤더에 추가
            if (token && header) {
                xhr.setRequestHeader(header, token);
            }
        },
        success: function(res) {
            if (res.success) {
                alert('체크리스트 점검 결과가 성공적으로 저장되었습니다.');
                loadControlChecklist();
            } else {
                alert('저장 실패: ' + (res.message || '오류가 발생했습니다.'));
            }
        },
        error: function(xhr, status, error) {
            console.error('저장 오류:', xhr.status, error);
            if (xhr.status === 403) {
                alert('저장 권한이 없거나 CSRF 인증에 실패했습니다. (403)');
            } else if (xhr.status === 404) {
                alert('저장 요청 경로(URL)를 찾을 수 없습니다. (404)');
            } else {
                alert('서버 통신 중 오류가 발생했습니다.');
            }
        }
    });
}

//3. 이벤트 바인딩
$(document).ready(function() {
 // [아코디언 토글] 항목 제목 클릭 시 상세 내용 열기/접기
 $(document).on('click', '.chk-card-header', function() {
     var $body = $(this).next('.chk-card-body');
     // 다른 항목은 접고 현재 클릭한 항목만 슬라이드 토글
     $('.chk-card-body').not($body).slideUp(200);
     $body.slideToggle(200);
 });

 // [상태 선택 이벤트] 라디오 버튼 선택 시 헤더 배지 업데이트
 $(document).on('change', '.chk-status-group input[type="radio"]', function() {
     var $card = $(this).closest('.control-chk-card');
     var $badge = $card.find('.chk-status-badge');
     var val = $(this).val();
     
     var textMap = { 'NORMAL': '정상', 'WARN': '주의', 'DANGER': '위험', 'NONE': '해당없음' };
     $badge.text(textMap[val] || '완료').addClass('selected');
 });

 // 저장 버튼
 $(document).off('click', '#btn-save-control-checklist').on('click', '#btn-save-control-checklist', function() {
     saveControlChecklist();
 });

 // 새로고침 버튼
 $(document).off('click', '#btn-refresh-checklist').on('click', '#btn-refresh-checklist', function() {
     loadControlChecklist();
 });

 // 패널 열릴 때 목록 자동 로드
 $(document).on('click', '[data-target="panel-check"], [data-target="#panel-check"]', function() {
     loadControlChecklist();
 });
});
</script>






<style>
/* 뱃지 위치 및 디자인 */
.quick-badge {
    position: absolute;
    top: 2px;
    right: 4px;
    background-color: #e74c3c;
    color: #ffffff;
    font-size: 10px;
    font-weight: bold;
    padding: 2px 5px;
    border-radius: 8px;
    line-height: 1;
    z-index: 10;
}

/* 탭 버튼 붉은색 반짝임 효과 */
@keyframes blinkGlow {
    0% { background-color: transparent; }
    50% { background-color: rgba(231, 76, 60, 0.6); }
    100% { background-color: transparent; }
}

.blink-active {
    animation: blinkGlow 1s infinite !important;
    border-left: 3px solid #e74c3c !important;
}

/* ==========================================
   .sub-drawer (260px) 내부 체크리스트 전용 완벽 맞춤 CSS
   ========================================== */

/* 1. 체크리스트 패널 & 컨테이너 (위치/여백 중복 지정 완전 제거) */
#panel-check,
#control-checklist-container {
    width: 100% !important;
    max-width: 100% !important;
    padding: 0 !important;          /* .sub-drawer 패딩(20px)을 활용하므로 0으로 초기화 */
    margin: 0 !important;
    position: static !important;     /* right, position 고정값 제거 */
    box-sizing: border-box !important;
}

/* 2. 패널 상단 제목 (줄바꿈 방지 & 그라데이션) */
#panel-check .drawer-header {
    font-size: 16px !important;
    font-weight: 700 !important;
    white-space: nowrap !important;  /* "관제 시스템 체크리스트" 줄바꿈 차단 */
    margin-bottom: 16px !important;
    padding-bottom: 12px !important;
    border-bottom: 1px solid rgba(255, 255, 255, 0.12) !important;
    background: linear-gradient(135deg, #ffffff 0%, #38bdf8 60%, #818cf8 100%) !important;
    -webkit-background-clip: text !important;
    -webkit-text-fill-color: transparent !important;
}

/* 3. 체크리스트 카드 (드론 카드 .drone-btn과 동일하게 100% 채움) */
.control-chk-card {
    width: 100% !important;
    margin: 0 0 10px 0 !important;
    background: rgba(255, 255, 255, 0.05) !important;
    border: 1px solid rgba(255, 255, 255, 0.08) !important;
    border-radius: 12px !important;
    overflow: hidden !important;
    box-sizing: border-box !important;
    transition: background 0.2s, border-color 0.2s !important;
}

.control-chk-card:hover {
    background: rgba(56, 189, 248, 0.08) !important;
    border-color: rgba(56, 189, 248, 0.3) !important;
}

/* 4. 카드 헤더 */
.chk-card-header {
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    padding: 12px 14px !important;
    gap: 8px !important;
    cursor: pointer !important;
    background: transparent !important;
    box-sizing: border-box !important;
    width: 100% !important;
}

.chk-card-title {
    font-size: 13px !important;
    font-weight: 600 !important;
    color: #f8fafc !important;
    word-break: keep-all !important;
    line-height: 1.4 !important;
    flex: 1 !important;
    min-width: 0 !important;
}

/* 상태 배지 */
.chk-status-badge {
    font-size: 10px !important;
    font-weight: 700 !important;
    padding: 2px 6px !important;
    border-radius: 6px !important;
    white-space: nowrap !important;
    flex-shrink: 0 !important;
    color: #94a3b8 !important;
    background: rgba(148, 163, 184, 0.12) !important;
    border: 1px solid rgba(148, 163, 184, 0.2) !important;
    box-sizing: border-box !important;
}

.chk-status-badge.selected,
.chk-status-badge.complete {
    color: #4ade80 !important;
    background: rgba(34, 197, 94, 0.15) !important;
    border: 1px solid rgba(74, 222, 128, 0.3) !important;
    box-shadow: 0 0 8px rgba(74, 222, 128, 0.2) !important;
}

/* 5. 상세 점검 내용 바디 */
.chk-card-body {
    display: none;
    padding: 12px 14px !important;
    background: rgba(0, 0, 0, 0.25) !important;
    border-top: 1px solid rgba(255, 255, 255, 0.06) !important;
    box-sizing: border-box !important;
    width: 100% !important;
}

.chk-question-text {
    font-size: 12px !important;
    color: #94a3b8 !important;
    line-height: 1.5 !important;
    margin-bottom: 12px !important;
    word-break: keep-all !important;
}

/* 상태 선택 버튼 그룹 (2열 배치) */
.chk-status-group {
    display: grid !important;
    grid-template-columns: repeat(2, 1fr) !important;
    gap: 8px !important;
    margin-bottom: 10px !important;
    width: 100% !important;
    box-sizing: border-box !important;
}

.chk-status-btn {
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    padding: 8px 0 !important;
    background: rgba(255, 255, 255, 0.05) !important;
    border: 1px solid rgba(255, 255, 255, 0.15) !important;
    border-radius: 8px !important;
    color: #94a3b8 !important;
    font-size: 12px !important;
    font-weight: 600 !important;
    cursor: pointer !important;
    box-sizing: border-box !important;
    width: 100% !important;
}

.chk-status-btn input[type="radio"] {
    display: none !important;
}

.chk-status-btn:has(input:checked) {
    color: #38bdf8 !important;
    background: rgba(14, 165, 233, 0.15) !important;
    border-color: #38bdf8 !important;
    box-shadow: 0 0 12px rgba(56, 189, 248, 0.3) !important;
}

/* 비고 입력창 */
.chk-remark-input {
    width: 100% !important;
    padding: 8px 12px !important;
    background: rgba(255, 255, 255, 0.08) !important;
    border: 1px solid rgba(255, 255, 255, 0.2) !important;
    border-radius: 8px !important;
    color: #ffffff !important;
    font-size: 12px !important;
    outline: none !important;
    box-sizing: border-box !important;
}

.chk-remark-input::placeholder {
    color: #64748b !important;
}

.chk-remark-input:focus {
    border-color: #38bdf8 !important;
    box-shadow: 0 0 8px rgba(56, 189, 248, 0.25) !important;
}

/* 하단 저장 버튼 */
.chk-save-btn,
#btn-save-checklist {
    width: 100% !important;
    padding: 12px !important;
    margin-top: 12px !important;
    background: linear-gradient(135deg, #0284c7 0%, #3b82f6 100%) !important;
    border: 1px solid rgba(56, 189, 248, 0.4) !important;
    border-radius: 10px !important;
    color: #ffffff !important;
    font-size: 13px !important;
    font-weight: 700 !important;
    cursor: pointer !important;
    box-shadow: 0 4px 14px rgba(14, 165, 233, 0.3) !important;
    box-sizing: border-box !important;
}

</style>

<script src="${pageContext.request.contextPath}/resources/js/drone-sidebar.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/situation-sidebar.js"></script>