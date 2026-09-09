document.addEventListener('DOMContentLoaded', function() {
    // 1. URL 파라미터 읽기
    var urlParams = new URLSearchParams(window.location.search);
    var type = urlParams.get('type') || '인파 밀집';
    var area = urlParams.get('area') || 'A구역';

    // 2. 현재 시간 생성 (YYYY-MM-DD HH:mm)
    var now = new Date();
    var year = now.getFullYear();
    var month = String(now.getMonth() + 1).padStart(2, '0');
    var day = String(now.getDate()).padStart(2, '0');
    var hours = String(now.getHours()).padStart(2, '0');
    var minutes = String(now.getMinutes()).padStart(2, '0');
    var formattedTime = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;

    // 3. 랜덤 보고 번호 생성 (예: RPT-20260520-1234)
    var randomNum = Math.floor(1000 + Math.random() * 9000);
    var reportNo = 'RPT-' + year + month + day + '-' + randomNum;

    // 4. 화면 요소에 값 채워넣기
    var infoValues = document.querySelectorAll('.info-card .info-value');
    if (infoValues.length >= 4) {
        infoValues[0].innerText = type;        // 보고 유형
        infoValues[1].innerText = area;        // 발생 구역
        infoValues[2].innerText = formattedTime; // 등록 시간
        infoValues[3].innerText = reportNo;      // 보고 번호
    }
});