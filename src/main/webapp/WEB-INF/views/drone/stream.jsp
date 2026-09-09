<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/drone-stream.css">

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
	                <img id="stream-video" src="${drone.url}" onerror="showToastError(this, '${droneId}')" alt="실시간 스트리밍" />
	            	
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
	    <div class="control-panel-right">
	    	<!-- 순회 관제 모드 -->
		    <div class="control-card auto-switch-card">
		        <span id="auto-switch-label">자동 전환 모드</span>
		        <label class="switch">
		            <input type="checkbox" id="auto-switch-toggle" role="switch" aria-labelledby="auto-switch-label">
		            <span class="slider round"></span>
		        </label>
		    </div>
	
	        <!-- 1. 드론 정보 카드 -->
	        <div class="control-card drone-info-card">
	            <div class="card-title" id="drone-name-display">${droneId}</div>
	            <div class="info-row">
	                <span>배터리</span>
	                <span class="info-value" id="drone-battery-display">70%</span>
	            </div>
	            <div class="info-row">
	                <span>구역명</span>
	                <span class="info-value" id="drone-zone-display">${zoneName}</span>
	            </div>
	        </div>
	
	        <!-- 2. 밀집도 카드 -->
	        <div class="control-card density-card">
	            <div class="card-header">
	                <span class="card-title">밀집도</span>
	                <div class="density-value-box">
	                    <span id="density-rate-display">00</span>%
	                </div>
	            </div>
	
	            <!-- 오버레이 및 사람 수 표시 스위치 그룹 (간격 일체화) -->
				<div class="toggle-group-box">
				    <div class="toggle-row-item">
				        <span id="overlay-label">오버레이 효과</span>
				        <label class="switch">
				            <input type="checkbox" id="btn-toggle-overlay" role="switch" aria-labelledby="overlay-label" checked>
				            <span class="slider round"></span>
				        </label>
				    </div>
				    <div class="toggle-row-item">
				        <span id="count-label">사람 수 표시</span>
				        <label class="switch">
				            <input type="checkbox" id="btn-toggle-count" role="switch" aria-labelledby="count-label" checked>
				            <span class="slider round"></span>
				        </label>
				    </div>
				</div>
	
	            <!-- 민감도 설정 -->
	            <div class="sensitivity-panel">
	                <div class="sensitivity-label">민감도 설정</div>
	                <div class="sensitivity-grid">
	                    <button type="button" class="sens-btn" data-level="low">저고도<br><small>100.0</small></button>
	                    <button type="button" class="sens-btn active" data-level="mid">기본<br><small>150.0</small></button>
	                    <button type="button" class="sens-btn" data-level="high">고고도<br><small>200.0</small></button>
	                </div>
	            </div>
	        </div>
	        
	        <!-- 3. 야생동물 감지 카드 -->
	        <div class="control-card wildlife-card">
	            <div class="card-header">
	                <span class="card-title">야생동물</span>
	                <span class="danger-badge" id="wildlife-risk-level">심각</span>
	            </div>
	
	            <!-- 야생동물 바운딩 박스 스위치 -->
	            <div class="toggle-group-box" style="margin-bottom: 8px;">
	                <div class="toggle-row-item">
	                    <span id="bbox-label">바운딩 박스</span>
	                    <label class="switch">
	                        <input type="checkbox" id="btn-toggle-bbox" role="switch" aria-labelledby="bbox-label" checked>
	                        <span class="slider round"></span>
	                    </label>
	                </div>
	            </div>
	
	            <div class="wildlife-body">
	                <div class="detection-info">
	                    <div>객체명 : <strong id="detected-object-name" style="color: #f8fafc;">고라니</strong></div>
	                    <div>신뢰도 : <span id="detected-confidence">72</span>%</div>
	                </div>
	                <button type="button" class="misdetect-btn" id="btn-report-misdetection">오감지</button>
	            </div>
	        </div>
	
	        <!-- 4. 자동 신고 카드 -->
			<div class="control-card report-card">
			    <div class="card-header">
			        <div class="card-title">자동 신고</div>
			    </div>
			    
			    <!-- 이력 목록 스크롤 & 고정 영역 -->
			    <div class="report-list-wrapper" id="report-list-wrapper">
			        
			        <!-- 이력 아이템 1 -->
			        <div class="report-status-box">
			            <div class="report-box-header">
			                <span class="status-text">소방서 신고 완료</span>
			                <span class="status-time">2026-08-27 09:58</span>
			                <button class="btn-report-close" onclick="deleteReportItem(this)" title="삭제">&times;</button>
			            </div>
			            <div class="report-box-msg">유선으로 신고유무 확인 바랍니다.</div>
			        </div>
			
			        <!-- 이력 아이템 2 -->
			        <div class="report-status-box">
			            <div class="report-box-header">
			                <span class="status-text">경찰서 신고 완료</span>
			                <span class="status-time">2026-08-27 10:15</span>
			                <button class="btn-report-close" onclick="deleteReportItem(this)" title="삭제">&times;</button>
			            </div>
			            <div class="report-box-msg">관할 파출소에 위치 정보 전달 완료.</div>
			        </div>
			        
			        <!-- 이력 아이템 3 -->
			        <div class="report-status-box">
			            <div class="report-box-header">
			                <span class="status-text">예시 화면</span>
			                <span class="status-time">2026-08-27 10:15</span>
			                <button class="btn-report-close" onclick="deleteReportItem(this)" title="삭제">&times;</button>
			            </div>
			            <div class="report-box-msg">DB와 연동되지 않습니다. 아직</div>
			        </div>
			
			    </div>
			</div>
	    </div>
   	</div> <!-- .stream-top-content 끝 -->

	<!-- [하단 영역] 감지 이력 테이블 -->
	<div class="detection-history-section">
	    <div class="history-header">
	        <div class="header-title-box">
	            <i class="fa-solid fa-list-check title-icon"></i>
	            <h3 class="title-text">실시간 객체 감지 이력</h3>
	            <span class="count-badge" id="totalHistoryCount">총 0건</span>
	        </div>
	        <div class="header-action-box">
	            <button type="button" class="btn-manual-register" id="btnManualRegister">
	                <i class="fa-solid fa-plus"></i> 수동 이벤트 등록
	            </button>
	        </div>
	    </div>

	    <div class="history-table-wrapper">
	        <table class="history-table">
	            <thead>
	                <tr>
	                    <th style="width: 50px;">NO</th>
	                    <th>감지 유형</th>
	                    <th style="width: 140px;">감지 일시</th>
	                    <th style="width: 90px;">위험 등급</th>
	                    <th>위험 유형</th>
	                    <th style="width: 100px;">구역명</th>
	                    <th style="width: 100px;">처리 상태</th>
	                    <th style="width: 80px;">상세</th>
	                </tr>
	            </thead>
	            <tbody id="detectionHistoryBody">
	                <tr>
	                    <td>1</td>
	                    <td>자동</td>
	                    <td>2026-08-30 14:22:10</td>
	                    <td><span class="badge danger-high">심각</span></td>
	                    <td> 인구 밀집 </td>
	                    <td>광장</td>
	                    <td><span class="badge status-unconfirmed">미확인</span></td>
	                    <td><button class="btn-detail"><i class="fa-solid fa-magnifying-glass"></i></button></td>
	                </tr>
	                <tr>
	                    <td>2</td>
	                    <td>수동</td>
	                    <td>2026-08-30 14:18:05</td>
	                    <td><span class="badge danger-mid">경계</span></td>
	                    <td> 야생 동물 출현 </td>
	                    <td>광장</td>
	                    <td><span class="badge status-in-progress">조치중</span></td>
	                    <td><button class="btn-detail"><i class="fa-solid fa-magnifying-glass"></i></button></td>
	                </tr>
	            </tbody>
	        </table>
	    </div>

	    <div class="history-footer-legend">
	        <span class="legend-title"><i class="fa-solid fa-circle-info"></i> 처리 상태 범례:</span>
	        <div class="legend-items">
	            <span class="legend-item"><span class="badge status-unconfirmed">미확인</span> 신규 감지 (확인 필요)</span>
	            <span class="legend-item"><span class="badge status-in-progress">조치중</span> 관제원 현장 확인/조치 중</span>
	            <span class="legend-item"><span class="badge status-completed">완료</span> 상황 종료 및 조치 완료</span>
	            <span class="legend-item"><span class="badge status-false-alarm">오탐</span> 잘못된 감지 이벤트</span>
	        </div>
	    </div>
	</div>

</div>

<script>
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

// 2. 스트리밍 에러 전용 함수
function showToastError(imgElement, droneId) {
    if (imgElement) {
        imgElement.onerror = null;
        imgElement.style.display = 'none';
    }
    showToast('⚠️ [ ' + droneId + ' ] 스트리밍 서버 응답 없음', 'error');
}

// 3. 자동 신고 알림 삭제
function deleteReportItem(btn) {
    const itemBox = btn.closest('.report-status-box');
    const wrapper = itemBox.parentElement;
    
    itemBox.remove();
    
    if (wrapper.querySelectorAll('.report-status-box').length === 0) {
        wrapper.innerHTML = '<div class="empty-report-msg">자동 신고 이력이 없습니다.</div>';
    }
}

// 4. 메인 컨트롤 및 스위치 바인딩
$(document).ready(function() {
    const ctx = window.contextPath || '';
    const currentDroneId = '${droneId}';
    const switchIntervalTime = 20000;
    let autoSwitchTimer = null;

    function handleAutoSwitch(isOn) {
        if (autoSwitchTimer) {
            clearInterval(autoSwitchTimer);
            autoSwitchTimer = null;
        }
        if (isOn) {
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

                location.href = ctx + '/drone/stream?id=' + nextDrone.droneId + '&zone=' + encodeURIComponent(nextDrone.zoneName);
            }
        });
    }

    // 초기 상태 로드
    const isAutoOn = localStorage.getItem('droneAutoSwitch') === 'true';
    $('#auto-switch-toggle').prop('checked', isAutoOn);
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

    // 단순 스위치 알림 바인딩 (중복 제거)
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
    $('.sensitivity-grid').on('click', '.sens-btn', function() {
        $('.sens-btn').removeClass('active');
        $(this).addClass('active');

        var level = $(this).data('level');
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

// 5. 전체화면 토글 이벤트 핸들러
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