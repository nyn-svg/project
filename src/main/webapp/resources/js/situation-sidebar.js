document.addEventListener('DOMContentLoaded', function () {
    const listContainer = document.getElementById('situation-list-container');
    const countBadge = document.getElementById('situ-count-badge');
    
    // 모달 요소 참조
    const situModal = document.getElementById('situation-modal');
    const btnCloseModal = document.getElementById('btn-situ-modal-close');
    const btnConfirmModal = document.getElementById('btn-situ-modal-confirm');

    let totalCount = 0;
	
	// 읽지 않은 보고 건수 관리 변수
	let unreadCount = 0;
	
    // SSE 수신 연결
    const eventSource = new EventSource(window.contextPath + '/api/sse/subscribe');
	const quickBadge = document.getElementById('quick-agent-badge');
	const agentNavBtn = document.getElementById('btn-nav-agent');
	const panelAgent = document.getElementById('panel-agent');

	eventSource.addEventListener('situation-report', function (e) {
	    try {
	        const data = JSON.parse(e.data);
	        addSituationCard(data, true); // 카드 추가
	        triggerSidebarAlert();        // ★ 사이드바 알림(반짝임+뱃지) 호출 필수!
	    } catch (err) {
	        console.error("Data parse error:", err);
	    }
	});
    eventSource.onerror = function (err) {
        console.error('SSE connection error:', err);
    };

    // 카드 동적 생성 및 이벤트 연결
    function addSituationCard(data, isNew) {
        totalCount++;
        if (countBadge) countBadge.textContent = totalCount + '건';

        const card = document.createElement('div');
        card.className = 'situ-card';
        card.style.cssText = `
            background: #252830;
            border-left: 4px solid #e74c3c;
            border-radius: 6px;
            padding: 10px 12px;
            cursor: pointer;
            transition: all 0.2s ease;
            user-select: none;
            margin-bottom: 2px;
        `;

        // 마우스 호버 효과
        card.addEventListener('mouseenter', function() {
            card.style.background = '#2d323e';
        });
        card.addEventListener('mouseleave', function() {
            card.style.background = '#252830';
        });

        const photoIcon = data.situImage 
            ? `<i class="fa-solid fa-image" style="color: #3498db; margin-left: 6px;" title="사진 첨부됨"></i>` 
            : '';

        card.innerHTML = `
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                <span style="font-weight: bold; color: #fff; font-size: 13px;">
                    [${data.zoneName || '미지정'}] ${data.dngrType || '상황보고'} ${photoIcon}
                </span>
                <span style="font-size: 11px; color: #888;">방금 전</span>
            </div>
            <div style="font-size: 12px; color: #bbb; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                ${data.situContent || '내용 없음'}
            </div>
            <div style="font-size: 11px; color: #666; margin-top: 4px;">
                보고자: ${data.userId || 'agent'}
            </div>
        `;

        // ★ 카드 클릭 이벤트 핵심 바인딩
        card.addEventListener('click', function (e) {
            e.stopPropagation();
            openSituationModal(data);
        });

        if (listContainer) {
            listContainer.insertBefore(card, listContainer.firstChild);
        }
    }

    // 모달 오픈 함수
    function openSituationModal(data) {
        console.log("Opening Modal for data:", data); // 브라우저 콘솔 확인용

        document.getElementById('situ-modal-dngr-type').textContent = data.dngrType || '위험 상황';
        document.getElementById('situ-modal-zone').textContent = data.zoneName || '-';
        document.getElementById('situ-modal-user').textContent = data.userId || '-';
        document.getElementById('situ-modal-time').textContent = data.situDate || '방금 전';
        document.getElementById('situ-modal-content').textContent = data.situContent || '내용 없음';

        const imgWrapper = document.getElementById('situ-modal-img-wrapper');
        const imgTag = document.getElementById('situ-modal-img');

        // 사진이 있을 경우 서버 리소스 경로 지정
        if (data.situImage) {
            imgTag.src = window.contextPath + '/resources/upload/situation/' + data.situImage;
            imgWrapper.style.display = 'block';
        } else {
            imgWrapper.style.display = 'none';
            imgTag.src = '';
        }

        // 모달 표시 (flex로 중앙 정렬)
        if (situModal) {
            situModal.style.display = 'flex';
        }

        // 지도의 해당 구역/핀으로 이동/하이라이트 함수 연동 (존재할 경우)
        if (typeof window.highlightMapZone === 'function') {
            window.highlightMapZone(data.zoneName);
        }
    }

    // 모달 닫기 이벤트 핸들러
    function closeModal() {
        if (situModal) situModal.style.display = 'none';
    }

    if (btnCloseModal) btnCloseModal.addEventListener('click', closeModal);
    if (btnConfirmModal) btnConfirmModal.addEventListener('click', closeModal);

    if (situModal) {
        situModal.addEventListener('click', function (e) {
            if (e.target === situModal) closeModal();
        });
    }
	
	function triggerSidebarAlert() {
	    // ID로 찾거나, 없으면 data-target 속성으로 버튼을 찾음
	    const agentNavBtn = document.getElementById('btn-nav-agent') || document.querySelector('[data-target="panel-agent"]');
	    const quickBadge = document.getElementById('quick-agent-badge');
	    const panelAgent = document.getElementById('panel-agent');

	    // 패널이 현재 활성화(열림) 상태인지 확인 (프로젝트의 패널 열림 class명 확인 필요: 보통 'active' 또는 'show')
	    const isPanelActive = panelAgent && panelAgent.classList.contains('active');

	    // 패널이 닫혀있을 때만 뱃지 수치 증가 및 반짝임 적용
	    if (!isPanelActive) {
	        unreadCount++;
	        if (quickBadge) {
	            quickBadge.textContent = unreadCount > 99 ? '99+' : unreadCount;
	            quickBadge.style.display = 'inline-block';
	        }
	        if (agentNavBtn) {
	            agentNavBtn.classList.add('blink-active');
	        }
	    }
	}

	// 관제사가 상황보고 탭을 누르면 알림 끄기
	document.addEventListener('click', function(e) {
	    const agentBtn = e.target.closest('[data-target="panel-agent"]');
	    if (agentBtn) {
	        unreadCount = 0;
	        const quickBadge = document.getElementById('quick-agent-badge');
	        if (quickBadge) quickBadge.style.display = 'none';
	        agentBtn.classList.remove('blink-active');
	    }
	});
	
});