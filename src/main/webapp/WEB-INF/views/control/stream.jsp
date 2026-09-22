<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 전체 화면 분할 컨테이너 -->
<div class="drone-stream-wrapper">

	<!-- [상단 영역] 비디오 스트리밍 + 우측 컨트롤 패널 -->
	<div class="stream-top-content">
	    
	    <!-- [상단-좌측 영역] 비디오 스트리밍 -->
	    <div class="stream-main-area">
	        <div class="stream-video-box">
	        	<div id="toast-container">
	        		<!-- 토스트 메시지 출력 공간 -->
	        	</div>
	            <div class="stream-header-info">
	                <span class="drone-title"> [ ${droneId} ] 실시간 스트리밍</span>
	            </div>
	            <div class="stream-placeholder">
	            	<!-- 💡 초기 로딩 스피너 박스 -->
	                <div class="stream-loading-box">
	                    <i class="fa-solid fa-spinner fa-spin"></i>
	                    <span>스트리밍 연결 중...</span>
	                </div>
	                
	                <img id="stream-video" src="${drone.url}" data-drone-id="${droneId}" crossorigin="anonymous" onerror="handleStreamError(this, this.getAttribute('data-drone-id'))" alt="실시간 스트리밍" />
	            	
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
                    <span class="card-title" id="drone-id">${droneId}</span>
                </div>
                <div class="card-body">
                    <div class="card-info">
                        <div>배터리 : <span class="card-info-value" id="drone-battery">70%</span></div>
                        <div>구역명 : <span class="card-info-value" id="drone-zone">${zoneName}</span></div>
                    </div>
                </div>
            </div>

            <!-- 2. 밀집도 카드 -->
            <div class="control-card density-info-card">
                <div class="card-header">
                    <span class="card-title">밀집도</span>
                    <div class="card-action density-value">
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
                            <button type="button" class="card-btn sens-btn" data-sens-level="low">저고도<br><small>100.0</small></button>
                            <button type="button" class="card-btn sens-btn active" data-sens-level="mid">기본<br><small>150.0</small></button>
                            <button type="button" class="card-btn sens-btn" data-sens-level="high">고고도<br><small>200.0</small></button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 3. 야생동물 감지 카드 -->
            <div class="control-card animal-info-card">
                <div class="card-header">
                    <span class="card-title">야생동물</span>
                    <div class="card-action">
                        <span class="danger-level-badge" id="danger-level">관심</span>
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
                        <div class="card-info">
                            <div>객체명 : <span class="card-info-value" id="object-name">고라니</span></div>
                            <div>신뢰도 : <span class="card-info-value" id="object-conf">72%</span></div>
                        </div>
                        <button type="button" class="card-btn misdetect-btn" id="misdetect">오감지</button>
                    </div>
                </div>
            </div>

            <!-- 4. 자동 신고 카드 -->
            <div class="control-card auto-report-card">
                <div class="card-header">
                    <span class="card-title">자동 신고</span>
                </div>
                <div class="card-body" id="report-list">
                    <!-- 이력 아이템 1 -->
			        <div class="report">
			            <div class="report-header">
			                <span class="report-title">소방서 신고 완료</span>
			                <span class="report-date">2026-08-27 09:58</span>
			                <button class="close-btn" title="삭제">&times;</button>
			            </div>
			            <div class="report-msg">유선으로 신고유무 확인 바랍니다.</div>
			        </div>
			        <!-- 이력 아이템 2 -->
			        <div class="report">
			            <div class="report-header">
			                <span class="report-title">경찰서 신고 완료</span>
			                <span class="report-date">2026-08-27 10:15</span>
			                <button class="close-btn" title="삭제">&times;</button>
			            </div>
			            <div class="report-msg">관할 파출소에 위치 정보 전달 완료.</div>
			        </div>
			        <!-- 이력 아이템 3 -->
			        <div class="report">
			            <div class="report-header">
			                <span class="report-title">예시 화면</span>
			                <span class="report-date">2026-08-27 10:15</span>
			                <button class="close-btn" title="삭제">&times;</button>
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
	            <button type="button" class="regist-btn" id="registSituation">
	                <i class="fa-solid fa-plus"></i> 수동 감지 등록
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
	            <span class="legend-item"><span class="badge status-canceled">취소</span> 오감지 이벤트 또는 조치 완료 전 조치 종료시킨 이벤트</span>
	        </div>
	    </div>
	</div>

</div>

<script>
//==========================================
// 1. 전역 상태 및 자원 관리 변수
//==========================================

// SSE 객체 전역 관리
let eventSource = null;
let sseReconnectTimer = null;
// 자동 전환 타이머 전역 관리
let autoSwitchTimer = null;
// 현재 드론아이디 전역 관리
let currentDroneId = null;

//==========================================
// 2. SPA 페이지 진입/복원 전역 초기화 함수
//==========================================

window.initStreamPage = function() {
	// 현재 지정된 드론아이디
	currentDroneId = '${droneId}';
	// localStorage에서 자동전환 여부 확인
	const isAutoOn = localStorage.getItem('droneAutoSwitch') === 'true';

	$('#auto-switch-toggle').prop('checked', isAutoOn);

	// 영상 로드 성공 감지 및 영상 표시
	$('#stream-video').off('load error').on('load', function() {
		const placeholder = this.closest('.stream-placeholder');
		if (placeholder) {
			$(placeholder).find('.stream-loading-box, .stream-notice-box').remove();
		}

		$(this).show();
     
		if ($('.stream-header-info .live-badge').length === 0) {
			$('.stream-header-info').prepend('<span class="live-badge">LIVE</span>');
		}
	}).on('error', function() {
		handleStreamError(this, currentDroneId);
	});

	handleAutoSwitch(isAutoOn); // 저장된 설정값에 따라 자동전환
	getSituationList(); // 실시간 감지/조치 이력 목록 조회
	initSSE(); // SSE 연결
}

//==========================================
// 3. SPA 페이지 이탈 시 자원 해제 함수
//==========================================

window.destroyStreamPage = function() {
	if (eventSource) {
		eventSource.close();
		eventSource = null;
	}
	if (sseReconnectTimer) {
		clearTimeout(sseReconnectTimer);
		sseReconnectTimer = null;
	}

	// 💡 SPA 환경에서 다른 화면으로 넘어갈 때 자동 전환 모드 강제 OFF
	if (autoSwitchTimer) {
		clearInterval(autoSwitchTimer);
		autoSwitchTimer = null;
	}
	localStorage.setItem('droneAutoSwitch', 'false');
};

//==========================================
// 4. 주요 비즈니스 로직 함수 모음
//==========================================

// 스트리밍 에러 전용 함수 (전역 관리)
function handleStreamError(imgElement, errorDroneId) {
	if (!imgElement) {
		return;
	}
     
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
		const errorHtml = '<div class="stream-notice-box error">'
						+ '<i class="fa-solid fa-plug-circle-xmark"></i>'
						+ '<span>[ ' + targetDroneId + ' ] 응답 없음 (점검 필요)</span>'
						+ '</div>';
		placeholder.insertAdjacentHTML('beforeend', errorHtml);
	}
}

// 자동 전환 타이머 관리
function handleAutoSwitch(isOn) {
	if (autoSwitchTimer) {
		clearInterval(autoSwitchTimer);
		autoSwitchTimer = null;
	}
 
	// 💡 현재 접속한 페이지가 스트리밍 페이지(/stream)인지 확인
	const isStreamPage = window.location.pathname.includes('/stream');
	// 💡 /stream 페이지이고, 스위치가 ON일 때만 타이머를 가동!
	if (isOn && isStreamPage) {
		autoSwitchTimer = setInterval(moveToNextDrone, 20000);
	}
}

// 자동전환 함수
function moveToNextDrone() {
	$.ajax({
		url: ctx + '/drone/api/list',
		type: 'GET',
		dataType: 'json',
		success: function(drones) {
			const flyingDrones = drones.filter(function(d) {
				return d.droneStatus === '비행';
			});
         
			if (flyingDrones.length <= 1) {
				return;
			}
         
			const currentIndex = flyingDrones.findIndex(function(d) {
				return d.droneId === currentDroneId;
			});
			const nextIndex = (currentIndex + 1) % flyingDrones.length;
			const nextDrone = flyingDrones[nextIndex];
         
			// 현재 드론아이디 갱신
			currentDroneId = nextDrone.droneId;
         
			// 💡 영상 교체 시 새 드론아이디와 바인딩
			const $video = $('#stream-video');
			$video.attr('data-drone-id', currentDroneId).hide(); // 현재 시점의 값을 DOM에 박아둠, 기존 영상 숨김
         
			const placeholder = $video.closest('.stream-placeholder');
			// 💡 전환 시 기존에 남아있던 로딩 박스나 에러 안내 박스 모두 청소
			if (placeholder) {
				$(placeholder).find('.stream-loading-box, .stream-notice-box').remove();
                 
				// 새로운 로딩 스피너 부착
				$(placeholder).prepend(`
					<div class="stream-loading-box">
						<i class="fa-solid fa-spinner fa-spin"></i>
						<span>스트리밍 연결 중...</span>
					</div>
				`);
			}
          	
			// src 변경 시 자동으로 위에서 등록한 load/error 실행됨
			$video.attr('src', nextDrone.url);

			// 드론 이름 및 구역명 텍스트 교체 및 주소창 갱신
			$('.drone-title').text(' [ ' + nextDrone.droneId + ' ] 실시간 스트리밍');
			$('#drone-id').text(nextDrone.droneId);
			$('#drone-zone').text(nextDrone.zoneName);

			// URL 주소창 갱신 (새로고침 없이 주소만 변경하여 뒤로가기 지원)
			const newUrl = ctx + '/control/stream?id=' + nextDrone.droneId + '&zone=' + encodeURIComponent(nextDrone.zoneName);
			history.replaceState(null, '', newUrl); // pushState 대신 replaceState를 쓰면 뒤로가기 히스토리가 지저분해지는 걸 막을 수 있습니다.
         
			// 화면 전환 알림 토스트 띄우기
			showToast('🔄 [ ' + nextDrone.droneId + ' ] 화면으로 자동 전환되었습니다.', 'info');
		}, error: function(xhr, status, error) {
			console.error('드론 목록 조회 실패 (자동전환 중):', error);
		}
	});
}

// 실시간 감지/조치 이력 목록 조회
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
             
			var html = '';
			situations.forEach(function(situation) {
				var currentLevelClass = levelClassMap[situation.dngrLevel] || 'danger-unknown';
				var currentStatusClass = statusClassMap[situation.situStatus] || 'status-canceled';
				
				html += '<tr>'
					 + '<td>' + situation.situNo + '</td>'
					 + '<td>' + situation.situType + '</td>'
					 + '<td>' + formatDate(situation.situDate) + '</td>'
					 + '<td><span class="badge ' + currentLevelClass + '">' + situation.dngrLevel + '</span></td>'
					 + '<td>' + situation.dngrType + '</td>'
					 + '<td>' + situation.zoneName + '</td>'
					 + '<td><span class="badge ' + currentStatusClass + '">' + situation.situStatus + '</span></td>'
					 + '<td><button type="button" class="detail-btn" data-situ-no="' + situation.situNo + '"><i class="fa-solid fa-magnifying-glass"></i></button></td>'
					 + '</tr>';
			});
			$tbody.append(html);
		}, error: function(err) {
			console.error('감지/조치 이력 목록 조회 실패:', err);
		}
	});
}

// SSE 연결 관리
function initSSE() {
	if (eventSource) {
		eventSource.close();
	}
	
	// 💡 수동 실행 시 기존에 동작 중이던 재연결 타이머를 반드시 해제
	if (sseReconnectTimer) {
		clearTimeout(sseReconnectTimer);
		sseReconnectTimer = null;
	}

	eventSource = new EventSource(ctx + '/api/sse/subscribe');

	// SSE로 하단 실시간 목록 갱신
 	// 'situation-alert(자동감지, 수동감지 등록)' 이벤트를 수신하면 목록 자동 갱신
 	eventSource.addEventListener('situation-alert', function(e) {
		getSituationList();
	});
 	// 'situation-report(긴급보고 등록)' 이벤트를 수신하면 목록 자동 갱신
	eventSource.addEventListener('situation-report', function(e) {
		getSituationList();
	});
	// 'situation-update(이력 수정/갱신)' 이벤트를 수신하면 목록 자동 갱신
	eventSource.addEventListener('situation-update', function(e) {
		getSituationList();
	});

	eventSource.onerror = function() {
		if (eventSource) {
				eventSource.close();
		}
		sseReconnectTimer = setTimeout(initSSE, 3000); // 3초 후 재연결
	};
}

// 'YYYY-MM-DD HH:mm:ss' 포맷으로 변환하는 함수
function formatDate(timestamp) {
	if (!timestamp) return '-';
 
	// ISO 문자열이나 숫자가 들어와도 Date 객체로 변환 가능하도록 처리
	const date = new Date(Number(timestamp) || timestamp);
	if (isNaN(date.getTime())) return timestamp; // 변환 실패 시 원본 그대로 출력

	const pad = function(num) { return num < 10 ? '0' + num : num; };

	var year = date.getFullYear();
	var month = pad(date.getMonth() + 1);
	var day = pad(date.getDate());
	var hours = pad(date.getHours());
	var minutes = pad(date.getMinutes());
	var seconds = pad(date.getSeconds());
	
	return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
}

// 범용 토스트 메시지 출력 함수
function showToast(message, type = 'info') {
	const container = document.getElementById('toast-container');
	if (!container) {
		return;
	}

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

// Flask 서버 설정 변경 API 호출
function sendToggleApi() {
	// 현재 img 태그 src 기반으로 API URL 생성
	// views.py 라우트: @stream.route('/video_feed/api/toggle', methods=['POST'])
	const videoSrc = $('#stream-video').attr('src') || '';
	// src URL에서 '/video_feed' 부분까지만 추출 후 '/api/toggle' 붙이기
	let toggleUrl = videoSrc.replace(/\/video_feed.*$/, '') + '/video_feed/api/toggle';

	// 1. 현재 화면 UI에서 최신 옵션 상태 수집
	const isShowDensity = $('#density-overlay-toggle').is(':checked');
	const isShowCount = $('#density-count-toggle').is(':checked');
	const isShowBbox = $('#animal-boxing-toggle').is(':checked');

	// 2. 현재 선택된 민감도 버튼에서 numeric 값 추출
	const activeSensLevel = $('.sens-btn.active').data('sens-level');
	const sensMap = {
		'low': 100.0,
		'mid': 150.0,
		'high': 200.0
	};
	const isMaxDensity = sensMap[activeSensLevel] || 150.0;

	// 3. Flask views.py로 전달할 JSON payload 구성
	const payload = {
		max_density: isMaxDensity,
		show_density: isShowDensity,
		show_count: isShowCount,
		show_bbox: isShowBbox
	};

	// 4. 비동기 HTTP 요청
	fetch(toggleUrl, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
		},
		body: JSON.stringify(payload)
	})
	.then(response => response.json())
	.then(data => {
		console.log('⚙️ Flask 스트리밍 설정 변경 완료:', data.settings);
	})
	.catch(error => console.error('❌ 설정 변경 API 에러 발생:', error));
}

//[공통] 팝업창 오픈 함수
function openPopup(url, windowName, width = 630, height = 830) {
    const left = (window.screen.width / 2) - (width / 2);
    const top = (window.screen.height / 2) - (height / 2);
    const windowOption = 'width=' + width + ', height=' + height + ', top=' + top + ', left=' + left + ', scrollbars=yes, resizable=yes';
    
    var pop = window.open(url, windowName, windowOption);
    if (pop) {
        pop.focus();
    }
}

//수동감지 등록 팝업
function openRegistPop() {
	// 1. 현재 화면의 구역명과 드론아이디 텍스트 가져오기
    const zoneName = document.getElementById('drone-zone').innerText;
    sessionStorage.setItem('regZoneName', zoneName);
    const droneId = document.getElementById('drone-id').innerText;
    sessionStorage.setItem('regDroneId', droneId);
    
 	// 2. 현재 스트리밍 <img> 태그의 화면 캡처하기
    const streamImg = document.getElementById('stream-video');
    try {
        const canvas = document.createElement('canvas');
        // 원본 이미지 크기에 맞춤
        canvas.width = streamImg.naturalWidth || 640; 
        canvas.height = streamImg.naturalHeight || 480;
        
        const ctx = canvas.getContext('2d');
        ctx.drawImage(streamImg, 0, 0, canvas.width, canvas.height);
        
        // Base64 문자열로 변환 (용량 최적화를 위해 JPEG, 80% 품질 설정)
        const base64Data = canvas.toDataURL('image/jpeg', 0.8); 
        sessionStorage.setItem('captureStreamImg', base64Data);
    } catch (e) {
        console.error('이미지 캡처 실패 (CORS 문제일 수 있음):', e);
        sessionStorage.removeItem('captureStreamImg');
    }

    // 3. 팝업 열기
    openPopup(ctx + '/detection/regist', 'Regist');
}

// 감지/조치 이력 상세페이지 팝업
function openDetailPop(situNo) {
    openPopup(ctx + '/detection/detail?no=' + situNo, 'Detail_' + situNo);
}

//==========================================
// 5. 전역 이벤트 위임 모음 (SPA 중복 방지)
//==========================================

// 전체화면 토글 이벤트 핸들러
$(document).off('click', '#btnFullscreen').on('click', '#btnFullscreen', function() {
	const placeholderEl = $(this).closest('.stream-placeholder')[0];
	if (!placeholderEl) {
		return;
	}

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
$(document).off('fullscreenchange webkitfullscreenchange MSFullscreenChange').on('fullscreenchange webkitfullscreenchange MSFullscreenChange', function() {
	const isFullscreen = !!(document.fullscreenElement || document.webkitFullscreenElement || document.msFullscreenElement);
	const $btn = $('#btnFullscreen');
	
	if (!$btn.length) {
		return;
	}

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

// 순회 관제 토글
$(document).off('change', '#auto-switch-toggle').on('change', '#auto-switch-toggle', function(e) {
	const isChecked = $(this).is(':checked');
	localStorage.setItem('droneAutoSwitch', isChecked);
	handleAutoSwitch(isChecked);

	if (e.originalEvent) {
		const msg = isChecked ? '🔄 자동 전환 모드가 시작되었습니다. (20초 주기)' 
							  : '⏸️ 자동 전환 모드가 해제되었습니다.';
		
		showToast(msg, 'info');
	}
});

// 민감도 설정
$(document).off('click', '.sens-btn').on('click', '.sens-btn', function() {
	$('.sens-btn').removeClass('active');
	$(this).addClass('active');
	
	var level = $(this).data('sens-level');
	
	const levelNames = {
		'low': '저고도(100.0)',
		'mid': '기본(150.0)',
		'high': '고고도(200.0)'
	};
	
	// 💡 Flask 서버로 변경된 민감도 전달
	sendToggleApi();
	
	var selectedText = levelNames[level] || 'UNKNOWN';
	showToast('⚙️ 민감도가 [' + selectedText + ']로 변경되었습니다.', 'info');
});

// 단순 스위치 알림 (SPA DOM 재생성 대응 전역 위임)
$(document).off('change', '#density-overlay-toggle, #density-count-toggle, #animal-boxing-toggle').on('change', '#density-overlay-toggle, #density-count-toggle, #animal-boxing-toggle', function(e) {
	if (!e.originalEvent) return;
	
	const labels = {
		'density-overlay-toggle': '💫 오버레이 효과',
		'density-count-toggle': '👥 사람 수 표시',
		'animal-boxing-toggle': '🐾 바운딩 박스 표시'
	};
	
	// 💡 Flask 서버로 변경된 민감도 전달
	sendToggleApi();
	
	const label = labels[this.id] || '옵션';
	const isChecked = $(this).is(':checked');
	showToast(label + (isChecked ? '가 켜졌습니다.' : '가 꺼졌습니다.'), 'info');
});

// 오감지 버튼 10초 비활성화 로직
$(document).off('click', '#misdetect').on('click', '#misdetect', function() {
	var $btn = $(this);
	if ($btn.prop('disabled')) {
		return;
	}
 
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

// 자동 신고 알림 삭제
$(document).off('click', '.close-btn').on('click', '.close-btn', function() {
	const $itemBox = $(this).closest('.report');
	if (!$itemBox.length) {
		return;
	}
	$itemBox.remove();

	const $wrapper = $itemBox.parent();
	// 남은 알림이 없으면 빈 상태 메시지 출력
	if ($wrapper.find('.report').length === 0) {
		$wrapper.html('<div class="empty-report-msg">자동 신고 이력이 없습니다.</div>');
	}
});

//수동 이벤트 등록 버튼 클릭 이벤트
$(document).off('click', '#registSituation').on('click', '#registSituation', function() {
    openRegistPop();
});

// 하단 감지 이력 상세보기 버튼 클릭 이벤트
$(document).off('click', '.detail-btn').on('click', '.detail-btn', function() {
	const situNo = $(this).data('situ-no');
	openDetailPop(situNo);
});
</script>