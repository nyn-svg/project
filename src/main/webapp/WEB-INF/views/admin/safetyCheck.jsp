<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 1. 최외각 컨테이너 (html, head, body 태그 전면 제거) -->
<div class="safety-container">
    <div class="safety-card">
    
        <!-- 1. 페이지 타이틀 영역 -->
        <div class="page-header">
            <div>
                <h2 class="page-title">분야별 안전점검 체크리스트</h2>
                <p class="page-subtitle">행정안전부 지침 기반</p>
            </div>
            
            <!-- 우측 상단 전체 점검 요약 대시보드 -->
            <div class="summary-dashboard">
                <div class="summary-label">전체 점검 요약</div>
                <div class="summary-cards">
                    <div class="card">
                        <span class="card-title">전체 항목</span>
                        <span class="card-value" id="count-total">20</span>
                    </div>
                    <div class="card">
                        <span class="card-title">점검 완료</span>
                        <span class="card-value" id="count-done">0</span>
                    </div>
                    <div class="card">
                        <span class="card-title"><i class="fa-solid fa-circle-check text-success"></i> 정상</span>
                        <span class="card-value text-success" id="count-normal">0</span>
                    </div>
                    <div class="card">
                        <span class="card-title"><i class="fa-solid fa-triangle-exclamation text-warning"></i> 주의</span>
                        <span class="card-value text-warning" id="count-warning">0</span>
                    </div>
                    <div class="card">
                        <span class="card-title"><i class="fa-solid fa-circle-xmark text-danger"></i> 위험</span>
                        <span class="card-value text-danger" id="count-danger">0</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. 점검 설정 필터 및 액션 버튼 영역 -->
        <div class="filter-bar">
            <div class="filter-group">
                <label for="checkDate">점검일자</label>
                <input type="date" id="checkDate" class="input-control" value="2025-09-01">

                <label for="checkRound">점검용</label>
                <select id="checkRound" class="select-control">
                    <option value="1">1차 점검 (10:00)</option>
                    <option value="2">2차 점검 (14:00)</option>
                    <option value="3">3차 점검 (18:00)</option>
                </select>

                <label for="inspector">점검자</label>
                <input type="text" id="inspector" class="input-control width-sm" value="김관리">
            </div>

            <div class="action-buttons">
                <button type="button" class="btn btn-primary" id="btn-save">
                    <i class="fa-solid fa-floppy-disk"></i> 점검결과 저장
                </button>
                <button type="button" class="btn btn-outline" id="btn-print">
                    <i class="fa-solid fa-print"></i> 출력 / PDF
                </button>
            </div>
        </div>

        <!-- 3. 체크리스트 테이블 영역 -->
        <div class="checklist-table-wrapper">
            <table class="checklist-table">
                <thead>
                    <tr>
                        <th class="col-category">분야 / 점검 항목</th>
                        <th class="col-status">정상</th>
                        <th class="col-status">주의</th>
                        <th class="col-status">위험</th>
                        <th class="col-status">해당없음</th>
                        <th class="col-remark">비고</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- 섹션 1: 인파 밀집 및 수송 관리 -->
                    <tr class="section-header">
                        <td colspan="6"><i class="fa-solid fa-users"></i> 1. 인파 밀집 및 수송 관리</td>
                    </tr>
                    <tr>
                        <td class="item-text">• 비상 대피로 확보: 관람객 이동 동선 및 비상 대피로에 병목 현상이나 장애물이 없는가?</td>
                        <td class="text-center"><input type="radio" name="item_1" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_1" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_1" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_1" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 안전요원 적정 배치: 주요 밀집 예상 구역(계단, 경사로, 연결 통로)에 안내 및 통제 인원이 배치되었는가?</td>
                        <td class="text-center"><input type="radio" name="item_2" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_2" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_2" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_2" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 일시적 인파 분산 대책: 주요 이동 통로의 일방통행 안내판 및 차단 펜스가 정상 설치되었는가?</td>
                        <td class="text-center"><input type="radio" name="item_3" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_3" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_3" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_3" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 비상 차량 동선: 구급차 및 소방차 전용 진출입로가 확보되어 진입에 방해가 없는가?</td>
                        <td class="text-center"><input type="radio" name="item_4" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_4" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_4" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_4" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>

                    <!-- 섹션 2: 시설물 및 무대 안전 -->
                    <tr class="section-header">
                        <td colspan="6"><i class="fa-solid fa-building-shield"></i> 2. 시설물 및 무대 안전</td>
                    </tr>
                    <tr>
                        <td class="item-text">• 구조물 고정 상태: 무대 장치, 조명탑, 대형 스피커 등이 강풍에 견디도록 견고하게 고정되었는가?</td>
                        <td class="text-center"><input type="radio" name="item_5" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_5" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_5" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_5" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 관람객 접근 차단: 무대 전면 및 고전압 설비 주변에 관람객 접근 방지용 안전펜스가 설치되었는가?</td>
                        <td class="text-center"><input type="radio" name="item_6" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_6" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_6" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_6" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 바닥재 및 경사로: 바닥 덮개 상태가 양호하며 미끄러짐/넘어짐 방지 조치가 되어 있는가?</td>
                        <td class="text-center"><input type="radio" name="item_7" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_7" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_7" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_7" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 임시 가설물 안전성: 부스, 자일 등 임시 천막 구조물의 결속 상태가 양호한가?</td>
                        <td class="text-center"><input type="radio" name="item_8" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_8" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_8" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_8" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>

                    <!-- 섹션 3: 가스 및 소방 안전 -->
                    <tr class="section-header">
                        <td colspan="6"><i class="fa-solid fa-fire-extinguisher"></i> 3. 가스 및 소방 안전 (특수 효과 포함)</td>
                    </tr>
                    <tr>
                        <td class="item-text">• 소방 장비 배치: 화재 발생 시 사용할 소화기가 주요 지점별로 눈에 띄게 비치되었는가?</td>
                        <td class="text-center"><input type="radio" name="item_9" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_9" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_9" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_9" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 가스용기 관리: LPG/가스용기가 직사광선을 피해 전통 방호 케이지 및 고정 장치로 보호되고 있는가?</td>
                        <td class="text-center"><input type="radio" name="item_10" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_10" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_10" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_10" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 가스 누출 차단기: 가스 사용 부스 내 누출 경보기 및 자동 차단 장치가 정상 가동되는가?</td>
                        <td class="text-center"><input type="radio" name="item_11" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_11" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_11" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_11" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 특수효과 연출 안전: 무대 폭죽/연화 사용 시 관람석 간의 법정 안전거리가 확보되었는가?</td>
                        <td class="text-center"><input type="radio" name="item_12" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_12" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_12" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_12" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>

                    <!-- 섹션 4: 전기 및 관제 설비 -->
                    <tr class="section-header">
                        <td colspan="6"><i class="fa-solid fa-bolt"></i> 4. 전기 및 관제 설비 연동</td>
                    </tr>
                    <tr>
                        <td class="item-text">• 전선 및 배선 상태: 관람객 동선 상에 누출된 전선이 없으며 덮개(몰드)가 씌워져 있는가?</td>
                        <td class="text-center"><input type="radio" name="item_13" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_13" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_13" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_13" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 누전차단기 작동: 발동기 및 분전함 내 누전차단기가 정격 용량대로 설치 및 작동하는가?</td>
                        <td class="text-center"><input type="radio" name="item_14" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_14" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_14" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_14" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• CCTV 및 모니터링: 밀집 위험지역 모니터링용 CCTV 카메라 수신 상태가 양호한가?</td>
                        <td class="text-center"><input type="radio" name="item_15" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_15" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_15" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_15" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 비상 방송 연동: 비상 상황 시 전체 관람객에게 즉시 안내 방송을 송출할 장비가 준비되었는가?</td>
                        <td class="text-center"><input type="radio" name="item_16" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_16" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_16" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_16" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>

                    <!-- 섹션 5: 응급 의료 및 야간 피난 관리 -->
                    <tr class="section-header">
                        <td colspan="6"><i class="fa-solid fa-kit-medical"></i> 5. 응급 의료 및 야간 피난 관리</td>
                    </tr>
                    <tr>
                        <td class="item-text">• 현장 의무실 운영: 현장 임시 의무실 위치가 시인성이 좋고 의료진 및 구급약품이 대기 중인가?</td>
                        <td class="text-center"><input type="radio" name="item_17" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_17" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_17" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_17" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 비상 연락망 체계: 인근 지정 병원 및 소방서/경찰서 간 핫라인이 개설되어 있는가?</td>
                        <td class="text-center"><input type="radio" name="item_18" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_18" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_18" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_18" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 야간 조명 및 피난선: 야간 피난 유도등, 비상 조명등, 피난 안내 표시판의 전원이 정상인가?</td>
                        <td class="text-center"><input type="radio" name="item_19" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_19" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_19" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_19" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                    <tr>
                        <td class="item-text">• 위생 및 환경 관리: 먹거리 부스 위생 상태 및 쓰레기/집수 시설이 안전하게 관리되고 있는가?</td>
                        <td class="text-center"><input type="radio" name="item_20" value="NORMAL" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_20" value="WARN" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_20" value="DANGER" class="radio-status"></td>
                        <td class="text-center"><input type="radio" name="item_20" value="NONE" class="radio-status"></td>
                        <td><input type="text" class="input-remark" placeholder="비고를 입력하세요"></td>
                    </tr>
                </tbody>
            </table>
        </div>

    </div>
</div>

<!-- 전용 JS 호출 전 Context Path 선언 및 스크립트 불러오기 -->
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/resources/js/admin/safetyCheck.js?v=1.1"></script>