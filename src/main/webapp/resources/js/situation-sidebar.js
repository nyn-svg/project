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

    // 💡 1. [신규 추가] 페이지 진입 시 기존 긴급보고 이력을 불러오는 함수
    function loadEmergencyList() {
        const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';
        
        fetch(basePath + '/total/api/list')
            .then(response => response.json())
            .then(data => {
                if (!data || data.length === 0) return;

                // '긴급보고' 유형만 필터링 (최신순 정렬)
                const emergencyList = data.filter(item => item.situType === '긴급보고');
                
                // 컨테이너 초기화
                if (listContainer) listContainer.innerHTML = '';
                totalCount = 0;

                // 기존 이력들을 하나씩 카드로 추가 (isNew = false)
                emergencyList.forEach(item => {
                    addSituationCard(item, false);
                });
            })
            .catch(err => console.error("기존 긴급보고 목록 로드 실패:", err));
    }

    // 💡 2. 페이지 로드 시 즉시 기존 긴급보고 목록 조회 실행
    loadEmergencyList();

    // SSE 수신 연결
    const eventSource = new EventSource(window.contextPath + '/api/sse/subscribe');
    const quickBadge = document.getElementById('quick-agent-badge');
    const agentNavBtn = document.getElementById('btn-nav-agent');
    const panelAgent = document.getElementById('panel-agent');

    eventSource.addEventListener('situation-report', function (e) {
        try {
            const data = JSON.parse(e.data);
            addSituationCard(data, true); // 실시간 카드 추가
            triggerSidebarAlert();        // 사이드바 알림(반짝임+뱃지) 호출
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

        // 시각 표시 (실시간 이벤트는 '방금 전', 기존 로드 건은 situDate 표시)
        const displayTime = isNew ? '방금 전' : (data.situDate ? new Date(data.situDate).toLocaleTimeString() : '방금 전');

        card.innerHTML = `
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                <span style="font-weight: bold; color: #fff; font-size: 13px;">
                    [${data.zoneName || '미지정'}] ${data.dngrType || '상황보고'} ${photoIcon}
                </span>
                <span style="font-size: 11px; color: #888;">${displayTime}</span>
            </div>
            <div style="font-size: 12px; color: #bbb; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                ${data.situContent || '내용 없음'}
            </div>
            <div style="font-size: 11px; color: #666; margin-top: 4px;">
                보고자: ${data.finder || 'SYSTEM'}
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
        console.log("Opening Modal for data:", data);

        document.getElementById('situ-modal-dngr-type').textContent = data.dngrType || '위험 상황';
        document.getElementById('situ-modal-zone').textContent = data.zoneName || '-';
        document.getElementById('situ-modal-user').textContent = data.finder || 'SYSTEM';
        document.getElementById('situ-modal-time').textContent = data.situDate || '방금 전';
        document.getElementById('situ-modal-content').textContent = data.situContent || '내용 없음';

        const imgWrapper = document.getElementById('situ-modal-img-wrapper');
        const imgTag = document.getElementById('situ-modal-img');

        const basePath = (typeof window.contextPath !== 'undefined') ? window.contextPath : '';
        const imageName = data.situImage || data.workImage;

        if (imgWrapper && imgTag) {
            if (imageName && imageName.trim() !== '') {
                imgTag.src = basePath + '/upload/' + imageName;
                imgWrapper.style.display = 'block';
            } else {
                imgTag.src = '';
                imgWrapper.style.display = 'none';
            }
        }

        // 모달 표시
        if (situModal) {
            situModal.style.display = 'flex';
        }

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
        const agentNavBtn = document.getElementById('btn-nav-agent') || document.querySelector('[data-target="panel-agent"]');
        const quickBadge = document.getElementById('quick-agent-badge');
        const panelAgent = document.getElementById('panel-agent');

        const isPanelActive = panelAgent && panelAgent.classList.contains('active');

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