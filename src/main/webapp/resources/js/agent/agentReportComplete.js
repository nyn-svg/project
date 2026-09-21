document.addEventListener('DOMContentLoaded', function() {
    // 1. 현재 브라우저 주소창(URL)의 파라미터 파싱 시작
    var urlParams = new URLSearchParams(window.location.search);
    
    // 2. 파라미터 키값 매핑 (값이 없을 경우 기본 대체값 처리)
    var situNo = urlParams.get('situNo') || '발급 오류'; 
    var dngrType = urlParams.get('dngrType') || '-';
    var dngrLevel = urlParams.get('dngrLevel') || '-';
    var zoneName = urlParams.get('zoneName') || '-';

    // 3. 실시간 날짜 포맷팅 (감지일시 연동)
    var now = new Date();
    var year = now.getFullYear();
    var month = String(now.getMonth() + 1).padStart(2, '0');
    var day = String(now.getDate()).padStart(2, '0');
    var hours = String(now.getHours()).padStart(2, '0');
    var minutes = String(now.getMinutes()).padStart(2, '0');
    var formattedTime = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;

    // 4. HTML 화면 요소(DOM)를 안전하게 찾아 데이터 바인딩 실행
    var elSituNo = document.getElementById('resSituNo');
    var elDngrType = document.getElementById('resDngrType');
    var elDngrLevel = document.getElementById('resDngrLevel');
    var elZoneName = document.getElementById('resZoneName');
    var elTime = document.getElementById('resFormattedTime');

    if (elSituNo) {
        elSituNo.innerText = situNo;

    }
    
    if (elDngrType) elDngrType.innerText = dngrType;
    if (elDngrLevel) elDngrLevel.innerText = dngrLevel;
    if (elZoneName) elZoneName.innerText = zoneName;
    if (elTime) elTime.innerText = formattedTime;
});
