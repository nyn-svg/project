document.addEventListener('DOMContentLoaded', function() {
    // URL 파라미터 파싱
    var urlParams = new URLSearchParams(window.location.search);
    
    // 🚨 가짜 번호 대신, 서버가 전송해 준 진짜 DB 이력번호(SITU_로 시작하는 고유키) 매핑
    var situNo = urlParams.get('situNo') || '발급 오류'; 
    var dngrType = urlParams.get('dngrType') || '-';
    var dngrLevel = urlParams.get('dngrLevel') || '-';
    var zoneName = urlParams.get('zoneName') || '-';

    // 실시간 날짜 포맷팅 (감지일시 자동입력 대변 시각 연동)
    var now = new Date();
    var year = now.getFullYear();
    var month = String(now.getMonth() + 1).padStart(2, '0');
    var day = String(now.getDate()).padStart(2, '0');
    var hours = String(now.getHours()).padStart(2, '0');
    var minutes = String(now.getMinutes()).padStart(2, '0');
    var formattedTime = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;

    // 요약 카드 뷰 레이어에 바인딩
    document.getElementById('resSituNo').innerText = situNo;
    document.getElementById('resDngrType').innerText = dngrType;
    document.getElementById('resDngrLevel').innerText = dngrLevel;
    document.getElementById('resZoneName').innerText = zoneName;
    document.getElementById('resFormattedTime').innerText = formattedTime;
});