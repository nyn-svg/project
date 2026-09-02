<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>행사장 안전관리 가이드 매뉴얼</title>
    <!-- 아이콘 폰트 (FontAwesome) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 커스텀 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/guideMain.css">
</head>
<body class="guide-body">

    <div class="guide-wrapper">
        <!-- 1. 상단 헤더 (타이틀 및 로그인 버튼) -->
        <header class="guide-header">
            <h1 class="header-title">
                <i class="fa-solid fa-bullhorn title-icon"></i>
                행사장 안전관리 가이드 매뉴얼
            </h1>
            <button type="button" class="btn-login" onclick="location.href='${pageContext.request.contextPath}/login'">
                로그인
            </button>
        </header>

        <!-- 메인 콘텐츠 영역 -->
        <main class="guide-content">

            <!-- 2. 행사장 필수 안전수칙 -->
            <section class="guide-section">
                <h2 class="section-title title-blue">1. 행사장 필수 안전수칙</h2>
                <div class="card-grid grid-3">
                    <!-- 수칙 카드 1 -->
                    <div class="guide-card">
                        <h3 class="card-title"><i class="fa-solid fa-people-group"></i> 1) 인파 밀집 제어 수칙</h3>
                        <ul class="guide-list">
                            <li>
                                <strong>일방통행 전환:</strong> 단위 면적당($1\text{m}^2$) 적정 인원 초과 시 이동 동선을 일방통행으로 즉시 전환
                            </li>
                            <li>
                                <strong>대기열 관리:</strong> 관람객 대기열(Queuing) 펜스 설치 간격 준수 및 유지 관리 지침 적용
                            </li>
                        </ul>
                    </div>

                    <!-- 수칙 카드 2 -->
                    <div class="guide-card">
                        <h3 class="card-title"><i class="fa-solid fa-warehouse"></i> 2) 임시 시설물 안전 수칙</h3>
                        <ul class="guide-list">
                            <li>
                                <strong>접근 통제:</strong> 야외 무대 구조물, 조명탑, 고전압 배선 구역 접근 통제 기준 준수
                            </li>
                            <li>
                                <strong>기상 악화 대응:</strong> 강풍/호우 발생 시 임시 시설물 즉시 철거 및 운영 중단 판단 매뉴얼 적용
                            </li>
                        </ul>
                    </div>

                    <!-- 수칙 카드 3 -->
                    <div class="guide-card">
                        <h3 class="card-title"><i class="fa-solid fa-ban"></i> 3) 공통 금지사항</h3>
                        <ul class="guide-list">
                            <li>
                                <strong>반입 금지:</strong> 행사장 내 불꽃놀이 및 인화성 물질 반입 전면 제한
                            </li>
                            <li>
                                <strong>동선 확보:</strong> 주요 관람객 이동 동선 내 적치물 전면 금지 시각화 지침
                            </li>
                        </ul>
                    </div>
                </div>
            </section>

            <!-- 3. 위험사건 발생 시 대처요령 -->
            <section class="guide-section">
                <div class="section-header-wrap">
                    <h2 class="section-title title-orange">2. 위험사건 발생 시 대처요령</h2>
                    <span class="section-subtext">※ 주요 위험 유형: 압사(인파 밀집) 위험, 화재, 지역 특성 위험</span>
                </div>
                <div class="card-grid grid-3">
                    <!-- Step 1 -->
                    <div class="guide-card step-card">
                        <div class="step-badge badge-step1">1단계: 상황 전파</div>
                        <ul class="guide-list">
                            <li>종합상황실 즉시 무전 보고</li>
                            <li>행사장 내 스피커 및 전광판을 통한 비상 대피 방송 송출</li>
                        </ul>
                    </div>

                    <!-- Step 2 -->
                    <div class="guide-card step-card">
                        <div class="step-badge badge-step2">2단계: 대피 유도</div>
                        <ul class="guide-list">
                            <li>경호 및 안전 요원을 비상구 및 탈출로에 전진 배치</li>
                            <li>유도봉을 활용한 역류 방지 및 분산 대피 동선 제어 가이드 수행</li>
                        </ul>
                    </div>

                    <!-- Step 3 -->
                    <div class="guide-card step-card">
                        <div class="step-badge badge-step3">3단계: 현장 통제</div>
                        <ul class="guide-list">
                            <li>119/112 구급차 및 경찰차 진입로 확보를 위한 바리케이드 제거</li>
                            <li>추가 민간인 진입 차단선(Cordon) 설정 및 현장 통제</li>
                        </ul>
                    </div>
                </div>
            </section>

            <!-- 4. 비상연락망 매트릭스 -->
            <section class="guide-section">
                <h2 class="section-title title-red">3. 비상연락망 매트릭스</h2>
                <div class="card-grid grid-3">
                    <!-- 연락망 1: 행사 주최측 -->
                    <div class="guide-card table-card">
                        <h3 class="card-title">행사 주최측 연락망</h3>
                        <table class="contact-table">
                            <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>연락처 / 채널</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>종합상황실 직통</td>
                                    <td>02-1234-5678</td>
                                </tr>
                                <tr>
                                    <td>총괄 유선 연락처</td>
                                    <td>010-1234-5678</td>
                                </tr>
                                <tr>
                                    <td>무전기 채널</td>
                                    <td>CH 01 (메인 관제)</td>
                                </tr>
                                <tr>
                                    <td>Zone A 팀장</td>
                                    <td>010-2222-3333</td>
                                </tr>
                                <tr>
                                    <td>Zone B/C 팀장</td>
                                    <td>010-4444-5555</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 연락망 2: 유관기관 -->
                    <div class="guide-card table-card">
                        <h3 class="card-title">유관기관 공식 연락망</h3>
                        <table class="contact-table">
                            <thead>
                                <tr>
                                    <th>기관명</th>
                                    <th>연락처</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>관할 경찰서 (경비과)</td>
                                    <td>112 / 02-111-1122</td>
                                </tr>
                                <tr>
                                    <td>관할 소방서 (현장지휘대)</td>
                                    <td>119 / 02-333-1199</td>
                                </tr>
                                <tr>
                                    <td>지자체 재난안전대책본부</td>
                                    <td>02-120 (당직실)</td>
                                </tr>
                                <tr>
                                    <td>민간 경비업체 본부</td>
                                    <td>02-999-8888</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 연락망 3: 의료 인프라 -->
                    <div class="guide-card table-card">
                        <h3 class="card-title">의료 인프라</h3>
                        <table class="contact-table">
                            <thead>
                                <tr>
                                    <th>시설 구분</th>
                                    <th>위치 및 연락처</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>현장 임시 의무실</td>
                                    <td>행사장 A구역 남측 (내선 104)</td>
                                </tr>
                                <tr>
                                    <td>권역응급의료센터</td>
                                    <td>02-777-7777</td>
                                </tr>
                                <tr>
                                    <td>닥터헬기 인계점(LZ)</td>
                                    <td>행사장 동측 헬리포트</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>

        </main>
    </div>

</body>
</html>