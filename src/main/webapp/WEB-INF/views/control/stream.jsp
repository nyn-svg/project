<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 전체 화면 분할 컨테이너 -->
<div class="drone-stream-wrapper">

	<!-- [상단 영역] 비디오 스트리밍 + 우측 컨트롤 패널 -->
	<div class="stream-top-content">
	    
	    <!-- [상단-좌측 영역] 비디오 스트리밍 -->
	    <div class="stream-main-area">
	        <div class="stream-video-box">
	        	<div id="toast-container"></div>
	            <div class="stream-header-info">
	                <span class="drone-title"> [ ${droneId} ] 실시간 스트리밍</span>
	            </div>
	            <div class="stream-placeholder">
	            	<!-- 💡 초기 로딩 스피너 박스 -->
	                <div class="stream-loading-box">
	                    <i class="fa-solid fa-spinner fa-spin"></i>
	                    <span>스트리밍 연결 중...</span>
	                </div>
	                
	                <img id="stream-video" src="${drone.url}" data-drone-id="${droneId}" onerror="handleStreamError(this, this.getAttribute('data-drone-id'))" alt="실시간 스트리밍" />
	            	
	            	<!-- 전체화면 토글 버튼 -->
				    <button type="button" class="btn-fullscreen" id="btnFullscreen" title="전체화면">
				        <!-- 확대 아이콘 (기본) -->
				        <svg class="icon-expand" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
				            <path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"/>
				        </svg>
				        <!-- 축소 아이콘 (전체화면 상태 시) -->
				        <svg class="icon-compress" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" style="display: none;">
				            <path d="M8 3v3a2 2 0 0 1-2 2H3m18 0h-3a2 2 0 0 1-2-2V3m0 18v-3a2 2 0 0 1 2-2h3M3 16h3a2 2 0 0 1 2 2v3"/>
				        </svg>
				    </button>
	            </div>
	        </div>
	    </div>

	    <!-- [상단-우측 영역] 관제 컨트롤 카드가 위치할 독립 패널 -->
	    <div class="stream-control-area">
        
            <!-- 0. 자동 전환 모드 -->
            <div class="control-card auto-switch-card">
                <div class="card-header">
                    <span class="card-title">자동 전환 모드</span>
                    <div class="card-action">
                        <label class="switch">
	                    	<input type="checkbox" id="auto-switch-toggle">
	                    	<span class="slider round"></span>
	                    </label>
                    </div>
                </div>
            </div>

            <!-- 1. 드론 정보 카드 -->
            <div class="control-card drone-info-card">
                <div class="card-header">
                    <span class="card-title" id="drone-id">${droneId}</span> <!-- drone-name-display → drone-id -->
                </div>
                <div class="card-body">
                    <div class="info">
                        <div>배터리 : <span class="info-value" id="drone-battery">70%</span></div>
                        <div>구역명 : <span class="info-value" id="drone-zone">${zoneName}</span></div>
                    </div>
                </div>
            </div>

            <!-- 2. 밀집도 카드 -->
            <div class="control-card density-info-card"> <!-- density-card → density-info-card -->
                <div class="card-header">
                    <span class="card-title">밀집도</span>
                    <div class="card-action density-value"> <!-- density-value-box → density-value -->
                        <span id="density-rate">00%</span>
                    </div> <!-- density-rate-display → density-rate -->
                </div>
                <div class="card-body">
                    <div class="toggle-box">
                        <div class="toggle">
                            <span class="toggle-label">오버레이 효과</span>
                            <label class="switch">
                                <input type="checkbox" id="density-overlay-toggle" checked>
                                <span class="slider round"></span>
                            </label>
                        </div>
                        <div class="toggle">
                            <span class="toggle-label">사람 수 표시</span>
                            <label class="switch">
                                <input type="checkbox" id="density-count-toggle" checked>
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="sens-panels">
                        <div class="panels-label">민감도 설정</div>
                        <div class="panels">
                            <button type="button" class="card-btn sens-btn" sens-level="low">저고도<br><small>100.0</small></button>
                            <button type="button" class="card-btn sens-btn active" sens-level="mid">기본<br><small>150.0</small></button>
                            <button type="button" class="card-btn sens-btn" sens-level="high">고고도<br><small>200.0</small></button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 3. 야생동물 감지 카드 -->
            <div class="control-card animal-info-card"> <!-- wildlife-card → animal-info-card -->
                <div class="card-header">
                    <span class="card-title">야생동물</span>
                    <div class="card-action">
                        <span class="danger-level-badge" id="danger-level">관심</span>
                        <!-- danger-badge → danger-level-badge, wildlife-risk-level → danger-level -->
                    </div>
                </div>
                <div class="card-body">
                    <div class="toggle-box">
                        <div class="toggle">
                            <span class="toggle-label">바운딩 박스</span>
                            <label class="switch">
                                <input type="checkbox" id="animal-boxing-toggle" checked>
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="animal-action">
                        <div class="info">
                            <div>객체명 : <span class="info-value" id="object-name">고라니</span></div>
                            <div>신뢰도 : <span class="info-value" id="object-conf">72%</span></div>
                        </div>
                        <button type="button" class="card-btn misdetect-btn" id="misdetect">오감지</button>
                    </div>
                </div>
            </div>

            <!-- 4. 자동 신고 카드 -->
            <div class="control-card auto-report-card"> <!-- report-card → auto-report-card -->
                <div class="card-header">
                    <span class="card-title">자동 신고</span>
                </div>
                <div class="card-body" id="report-list">
                    <!-- 이력 아이템 1 -->
			        <div class="report">
			            <div class="report-header">
			                <span class="report-title">소방서 신고 완료</span>
			                <span class="report-date">2026-08-27 09:58</span>
			                <button class="close-btn" onclick="deleteReportItem(this)" title="삭제">&times;</button>
			            </div>
			            <div class="report-msg">유선으로 신고유무 확인 바랍니다.</div>
			        </div>
			        <!-- 이력 아이템 2 -->
			        <div class="report">
			            <div class="report-header">
			                <span class="report-title">경찰서 신고 완료</span>
			                <span class="report-date">2026-08-27 10:15</span>
			                <button class="close-btn" onclick="deleteReportItem(this)" title="삭제">&times;</button>
			            </div>
			            <div class="report-msg">관할 파출소에 위치 정보 전달 완료.</div>
			        </div>
			        <!-- 이력 아이템 3 -->
			        <div class="report">
			            <div class="report-header">
			                <span class="report-title">예시 화면</span>
			                <span class="report-date">2026-08-27 10:15</span>
			                <button class="close-btn" onclick="deleteReportItem(this)" title="삭제">&times;</button>
			            </div>
			            <div class="report-msg">DB와 연동되지 않습니다. 아직</div>
			        </div>
                </div>
            </div>
        </div>
   	</div> <!-- .stream-top-content 끝 -->

	<!-- [하단 영역] 실시간 이력 테이블 -->
	<div class="detection-history">
	    <div class="history-header">
	        <div class="header-title">
	            <i class="fa-solid fa-list-check title-icon"></i>
	            <h3 class="title-text">실시간 감지/조치 이력</h3>
	            <span class="count-badge" id="totalCount">총 0건</span>
	        </div>
	        <div class="header-btn">
	            <button type="button" class="register-btn" id="registerSituation">
	                <i class="fa-solid fa-plus"></i> 수동 이벤트 등록
	            </button>
	        </div>
	    </div>

	    <div class="history-body">
	        <table class="history-table">
	            <thead>
	                <tr>
	                    <th>NO</th>
	                    <th>감지 유형</th>
	                    <th>감지 일시</th>
	                    <th>위험 단계</th>
	                    <th>위험 유형</th>
	                    <th>구역명</th>
	                    <th>조치 상태</th>
	                    <th>상세</th>
	                </tr>
	            </thead>
	            <tbody id="detectionHistoryBody">
	                <!-- JavaScript로 목록이 렌더링됩니다 -->
	            </tbody>
	        </table>
	    </div>

	    <div class="history-footer">
	        <span class="legend-title"><i class="fa-solid fa-circle-info"></i> 조치 상태 범례:</span>
	        <div class="legend-items">
	            <span class="legend-item"><span class="badge status-pending">감지</span> 신규 감지 이벤트</span>
	            <span class="legend-item"><span class="badge status-in-progress">조치</span> 조치 중</span>
	            <span class="legend-item"><span class="badge status-completed">완료</span> 조치 완료</span>
	            <span class="legend-item"><span class="badge status-failed">미해결</span> 조치 실패</span>
	            <span class="legend-item"><span class="badge status-canceled">취소</span> 잘못된 감지 이벤트 또는 조치 완료 전 종료된 감지 이벤트</span>
	        </div>
	    </div>
	</div>

</div>

<script>
let eventSource = null; // SSE 객체 전역 관리
let autoSwitchTimer = null; // 자동 전환 타이머 전역 변수

// 1. 범용 토스트 메시지 출력 함수
function showToast(message, type = 'info') {
    const container = document.getElementById('toast-container');
    if (!container) return;
    
    container.innerHTML = '';

    const toast = document.createElement('div');
    toast.className = 'toast-message ' + type;
    toast.innerHTML = message;

    container.appendChild(toast);

    setTimeout(function() {
        toast.classList.add('show');
    }, 50);

    setTimeout(function() {
        toast.classList.remove('show');
        setTimeout(function() {
            if (toast && toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 400);
    }, 3000);
}

//2. 스트리밍 에러 전용 함수 (가운데 고정 안내 표시)
function handleStreamError(imgElement, errorDroneId) {
	if (!imgElement) return;
    
    imgElement.onerror = null; // 무한 에러 방지
    imgElement.style.display = 'none';
    
 	// 💡 파라미터가 비어있을 경우 태그의 data 속성에서 직접 가져오도록 방어 로직 추가
    const targetDroneId = errorDroneId || imgElement.getAttribute('data-drone-id') || 'UNKNOWN';
    
    const placeholder = imgElement.closest('.stream-placeholder');
    if (placeholder) {
        // 남아있는 로딩 박스 제거
        const loadingBox = placeholder.querySelector('.stream-loading-box');
        if (loadingBox) {
        	loadingBox.remove();
        }
        
        // 이미 에러 안내가 있다면 중복 생성 방지
        if (placeholder.querySelector('.stream-notice-box')) {
        	return;
        }

        // realtime 페이지 스타일과 맞춘 고정 에러 안내 박스 생성
        const errorHtml = `
            <div class="stream-notice-box error">
                <i class="fa-solid fa-plug-circle-xmark"></i>
                <span>[ ${targetDroneId} ] 응답 없음 (점검 필요)</span>
            </div>
        `;
        placeholder.insertAdjacentHTML('beforeend', errorHtml);
    }
}

// 3. 자동 신고 알림 삭제
function deleteReportItem(btn) {
    const itemBox = btn.closest('.report');
    if (!itemBox) return;
    
    const wrapper = itemBox.parentElement;
    itemBox.remove();
    
    if (wrapper.querySelectorAll('.report').length === 0) {
        wrapper.innerHTML = '<div class="empty-report-msg">자동 신고 이력이 없습니다.</div>';
    }
}

// 4. SSE 연결 관리 (진입할 때)
function initSSE() {
    if (eventSource) {
        eventSource.close();
    }

    eventSource = new EventSource(ctx + '/api/sse/subscribe');

    // 'drone_change' 이벤트를 수신하면 목록 자동 갱신
    eventSource.addEventListener('drone_change', function(e) {
        getSituationList();
    });

    eventSource.onerror = function() {
        if (eventSource) {
            eventSource.close();
        }
        setTimeout(initSSE, 3000); // 3초 후 재연결
    };
}

// 스트리밍 페이지 이탈 시 자원을 해제하는 전역 함수 (나갈 때)
window.destroyStreamPage = function() {
    if (eventSource) {
        eventSource.close();
        eventSource = null;
    }
    if (autoSwitchTimer) {
        clearInterval(autoSwitchTimer);
        autoSwitchTimer = null;
    }
    localStorage.setItem('droneAutoSwitch', 'false');
};

//밀리초 타임스탬프를 'YYYY-MM-DD HH:mm:ss' 포맷으로 변환하는 함수
function formatDate(timestamp) {
    if (!timestamp) return '-';
    
    // ISO 문자열이나 숫자가 들어와도 Date 객체로 변환 가능하도록 처리
    var date = new Date(Number(timestamp) || timestamp);
    if (isNaN(date.getTime())) return timestamp; // 변환 실패 시 원본 그대로 출력

    var pad = function(num) { return num < 10 ? '0' + num : num; };

    var year = date.getFullYear();
    var month = pad(date.getMonth() + 1);
    var day = pad(date.getDate());
    var hours = pad(date.getHours());
    var minutes = pad(date.getMinutes());
    var seconds = pad(date.getSeconds());

    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
}

// 감지 이력 상세페이지 팝업 함수
function openDetailPop(situNo) {
    var url = ctx + '/detection/detail?no=' + situNo;
    
    // 💡 팝업창 이름을 고정하면 기존 팝업창에서 내용만 전환되고, 
    // situNo를 붙이면(예: 'Detail_' + situNo) 이벤트별로 각각 팝업창이 새로 떠서 비교가 가능해집니다.
    // var windowName = 'DetectionDetailPop';
    var windowName = 'Detail_' + situNo;
    
    // 팝업창 옵션 (크기, 스크롤, 리사이즈 설정)
    var windowOption = 'width=630, height=830, top=100, left=200, scrollbars=yes, resizable=yes';
    
    var detailPop = window.open(url, windowName, windowOption);
    
    // 이미 팝업이 밑으로 내려가(최소화) 있는 경우 앞으로 끌어올림
    if (detailPop) {
        detailPop.focus();
    }
}

// 5. 실시간 감지 목록 불러오기
function getSituationList() {
    $.ajax({
        url: ctx + '/total/api/list',
        type: 'GET',
        dataType: 'json',
        success: function(situations) {
            var $tbody = $('#detectionHistoryBody');
            $tbody.empty();
            
            // 총 건수 배지 업데이트
            $('#totalCount').text('총 ' + (situations ? situations.length : 0) + '건');
            
            if (!situations || situations.length === 0) {
                $tbody.append('<tr><td colspan="8" style="text-align:center;">생성된 감지/조치 이력이 없습니다.</td></tr>');
                return;
            }
             
            var levelClassMap = {
                '관심': 'danger-interest',
                '주의': 'danger-attention',
                '경계': 'danger-caution',
                '심각': 'danger-severe',
                '판단불가': 'danger-unknown'
            };
            var statusClassMap = {
                '감지': 'status-pending',
                '조치': 'status-in-progress',
                '완료': 'status-completed',
                '미해결': 'status-failed',
                '취소': 'status-canceled'
            };

            situations.forEach(function(situation) {
                var currentLevelClass = levelClassMap[situation.dngrLevel] || 'danger-unknown';
                var currentStatusClass = statusClassMap[situation.situStatus] || 'status-pending';
                
                var html = '<tr>'
                         + '<td>' + situation.situNo + '</td>'
                         + '<td>' + situation.situType + '</td>'
                         + '<td>' + formatDate(situation.situDate) + '</td>'
                         + '<td><span class="badge ' + currentLevelClass + '">' + situation.dngrLevel + '</span></td>'
                         + '<td>' + situation.dngrType + '</td>'
                         + '<td>' + situation.zoneName + '</td>'
                         + '<td><span class="badge ' + currentStatusClass + '">' + situation.situStatus + '</span></td>'
                         + '<td><button type="button" class="btn-detail" onclick="openDetailPop(\'' + situation.situNo + '\')"><i class="fa-solid fa-magnifying-glass"></i></button></td>'
                         + '</tr>';

                $tbody.append(html);
            });
        },
        error: function(err) {
            console.error('감지/조치 목록 조회 실패:', err);
        }
    });
}

// 페이지 진입/복원/SPA 전환 공통 초기화 함수
window.initStreamPage = function() {
    getSituationList(); // 실시간 감지 목록 불러오기
    initSSE();          // SSE 연결
};

// 7. 메인 컨트롤 및 초기화
$(document).ready(function() {
	let currentDroneId = '${droneId}';
    const switchIntervalTime = 20000;
    
 	// 💡 최초 진입 시 데이터 로딩 및 SSE 연결 (1회만 호출)
    window.initStreamPage();
 	
 	// 💡 현재 접속한 페이지가 스트리밍 페이지(/stream)인지 확인
    const isStreamPage = window.location.pathname.endsWith('/control/stream') || window.location.pathname.endsWith('/stream');

 	// 최초 진입 시 영상 로드 성공 감지
    $('#stream-video').on('load', function() {
        const placeholder = this.closest('.stream-placeholder');
        if (placeholder) {
            $(placeholder).find('.stream-loading-box, .stream-notice-box').remove();
        }
        $(this).show();
        
        if ($('.stream-header-info .live-badge').length === 0) {
            $('.stream-header-info').prepend('<span class="live-badge">LIVE</span>');
        }
    });
 	
 	function handleAutoSwitch(isOn) {
        if (autoSwitchTimer) {
            clearInterval(autoSwitchTimer);
            autoSwitchTimer = null;
        }
     	// 💡 /stream 페이지이고, 스위치가 ON일 때만 타이머를 가동!
        if (isOn && isStreamPage) {
            autoSwitchTimer = setInterval(moveToNextDrone, switchIntervalTime);
        }
    }

    function moveToNextDrone() {
        $.ajax({
            url: ctx + '/drone/api/list',
            type: 'GET',
            dataType: 'json',
            success: function(drones) {
                const flyingDrones = drones.filter(function(d) {
                    return d.droneStatus === '비행';
                });
                
                if (flyingDrones.length <= 1) return;

                const currentIndex = flyingDrones.findIndex(function(d) {
                    return d.droneId === currentDroneId;
                });
                const nextIndex = (currentIndex + 1) % flyingDrones.length;
                const nextDrone = flyingDrones[nextIndex];
                
             	// 1. 현재 드론 ID 갱신
                currentDroneId = nextDrone.droneId;
             	
             	// 💡 2. 영상 교체 시 에러 핸들러(onerror)를 새 드론 ID와 함께 다시 바인딩!
                const $video = $('#stream-video');
             	$video.attr('data-drone-id', currentDroneId); // 현재 시점의 값을 DOM에 박아둠
                const placeholder = $video.closest('.stream-placeholder')[0];
             	
             	// 💡 전환 시 기존에 남아있던 로딩 박스나 에러 안내 박스 모두 청소
                if (placeholder) {
                    $(placeholder).find('.stream-loading-box, .stream-notice-box').remove();
                    
                    // 새로운 로딩 스피너 부착
                    const loadingHtml = `
                        <div class="stream-loading-box">
                            <i class="fa-solid fa-spinner fa-spin"></i>
                            <span>스트리밍 연결 중...</span>
                        </div>
                    `;
                    $(placeholder).prepend(loadingHtml);
                }
                
             	// 💡 다음 드론 영상으로 바뀔 때 기존 영상 숨기고 로딩 스피너 다시 생성
                $video.hide();
             	
             	// 에러 핸들러 연결
                $video[0].onerror = function() {
				    // DOM에서 직접 읽어오므로 변수 스코프 문제 발생 안 함
				    const droneId = this.getAttribute('data-drone-id');
				    handleStreamError(this, droneId);
				};
                				
             	// 💡 새 영상 로드 성공 시 로딩 박스 제거 및 영상 노출
                $video.off('load').on('load', function() {
                    const ph = this.closest('.stream-placeholder');
                    if (ph) {
                        const lBox = ph.querySelector('.stream-loading-box');
                        if (lBox) lBox.remove();
                    }
                    $(this).show();
                });
             	
                $video.attr('src', nextDrone.url);
                
             	// 3. 드론 이름 및 구역명 텍스트 교체 및 주소창 갱신
                $('.drone-title').text(' [ ' + nextDrone.droneId + ' ] 실시간 스트리밍');
                $('#drone-id').text(nextDrone.droneId);
                $('#ddrone-zone').text(nextDrone.zoneName);
                
                // 4. URL 주소창 갱신 (새로고침 없이 주소만 변경하여 뒤로가기 지원)
                const newUrl = ctx + '/control/stream?id=' + nextDrone.droneId + '&zone=' + encodeURIComponent(nextDrone.zoneName);
                history.replaceState(null, '', newUrl); // pushState 대신 replaceState를 쓰면 뒤로가기 히스토리가 지저분해지는 걸 막을 수 있습니다.
                
             	// 💡 5. 비동기로 다음 드론이 넘어갈 때 하단 감지/조치 이력 목록도 함께 갱신!
                if (typeof getSituationList === 'function') {
                    getSituationList();
                }
                
                // 6. 화면 전환 알림 토스트 띄우기
                showToast('🔄 [ ' + nextDrone.droneId + ' ] 화면으로 자동 전환되었습니다.', 'info');
            }
        });
    }

 	// [초기화 실행 흐름]
    // 1. localStorage에서 자동전환 여부를 읽어옴
    const isAutoOn = localStorage.getItem('droneAutoSwitch') === 'true';
    $('#auto-switch-toggle').prop('checked', isAutoOn);
    
 	// 2. 스트리밍 페이지라면 저장된 설정값에 따라 타이머 즉시 재시작!
    handleAutoSwitch(isAutoOn);

    // 순회 관제 토글
    $('#auto-switch-toggle').on('change', function(e) {
        const isChecked = $(this).is(':checked');
        localStorage.setItem('droneAutoSwitch', isChecked);
        handleAutoSwitch(isChecked);

        if (e.originalEvent) {
            const msg = isChecked 
                ? '🔄 자동 전환 모드가 시작되었습니다. (20초 주기)' 
                : '⏸️ 자동 전환 모드가 해제되었습니다.';
            showToast(msg, 'info');
        }
    });

    // 단순 스위치 알림 바인딩
    function bindToggleToast(selector, label) {
        $(selector).on('change', function(e) {
            if (!e.originalEvent) return;
            var isChecked = $(this).is(':checked');
            showToast(label + (isChecked ? '가 켜졌습니다.' : '가 꺼졌습니다.'), 'info');
        });
    }

    bindToggleToast('#btn-toggle-overlay', '💫 오버레이 효과');
    bindToggleToast('#btn-toggle-count', '👥 사람 수 표시');
    bindToggleToast('#btn-toggle-bbox', '🐾 바운딩 박스 표시');

    // 민감도 설정
    $('.panels').on('click', '.sens-btn', function() {
        $('.sens-btn').removeClass('active');
        $(this).addClass('active');

        var level = $(this).data('sens-level');
        var levelNames = {
            'low': '저고도(100.0)',
            'mid': '기본(150.0)',
            'high': '고고도(200.0)'
        };
        
        var selectedText = levelNames[level] || '기본(150.0)';
        showToast('⚙️ 민감도가 [' + selectedText + ']로 변경되었습니다.', 'info');
    });

    // 오감지 버튼 10초 비활성화 로직
    $('#btn-report-misdetection').on('click', function() {
        var $btn = $(this);
        if ($btn.prop('disabled')) return;

        $btn.prop('disabled', true);
        showToast('⚠️ 오감지 처리를 수행합니다.', 'warning');

        var remaining = 10;
        $btn.text('처리중 (' + remaining + '초)');

        var countdown = setInterval(function() {
            remaining--;
            if (remaining > 0) {
                $btn.text('처리중 (' + remaining + '초)');
            } else {
                clearInterval(countdown);
                $btn.prop('disabled', false).text('오감지');
            }
        }, 1000);
    });
});

// 💡 SPA 환경에서 상단 헤더 메뉴 등을 눌러 다른 화면으로 넘어갈 때 자동 전환 모드 강제 OFF
$(document).on('click', '.header-link', function() {
    localStorage.setItem('droneAutoSwitch', 'false');
    if (autoSwitchTimer) {
        clearInterval(autoSwitchTimer);
        autoSwitchTimer = null;
    }
});

// 뒤로가기/앞으로가기(BFCache) 및 사이드바 이동 복원 대응
window.addEventListener('pageshow', function(event) {
    // event.persisted가 true이면 브라우저가 캐시된 페이지를 복원한 상태
    if (event.persisted) {
    	window.initStreamPage();
    }
});

// 다른 탭에 갔다 돌아왔을 때 자동 갱신
document.addEventListener('visibilitychange', function() {
    if (document.visibilityState === 'visible') {
    	window.initStreamPage();
    }
});

// 8. 전체화면 토글 이벤트 핸들러
$(document).on('click', '#btnFullscreen', function() {
    const $placeholder = $(this).closest('.stream-placeholder');
    const placeholderEl = $placeholder[0];
    if (!placeholderEl) return;

    const isFullscreen = !!(document.fullscreenElement || document.webkitFullscreenElement || document.msFullscreenElement);

    if (!isFullscreen) {
        if (placeholderEl.requestFullscreen) {
            placeholderEl.requestFullscreen();
        } else if (placeholderEl.webkitRequestFullscreen) {
            placeholderEl.webkitRequestFullscreen();
        } else if (placeholderEl.msRequestFullscreen) {
            placeholderEl.msRequestFullscreen();
        }
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        }
    }
});

// 전체화면 상태 변경 감지
$(document).on('fullscreenchange webkitfullscreenchange MSFullscreenChange', function() {
    const isFullscreen = !!(document.fullscreenElement || document.webkitFullscreenElement || document.msFullscreenElement);
    const $btn = $('#btnFullscreen');
    
    if (!$btn.length) return;

    if (isFullscreen) {
        $btn.find('.icon-expand').hide();
        $btn.find('.icon-compress').show();
        $btn.attr('title', '전체화면 종료');
    } else {
        $btn.find('.icon-expand').show();
        $btn.find('.icon-compress').hide();
        $btn.attr('title', '전체화면');
    }
});
</script>