<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>행사장 안전관리 가이드 매뉴얼</title>
    
    <!-- 아이콘 폰트 (FontAwesome) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background-color: #0b132b;
            color: #f8fafc;
            font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* 1. Vanta 3D 애니메이션 배경 레이어 */
        #vanta-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 1;
        }

        /* 2. 최외각 컨테이너 레이어 */
        .guide-wrapper {
            position: relative;
            z-index: 2;
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 24px;
            box-sizing: border-box;
        }

        /* 3. 상단 헤더 (Glassmorphism 적용) */
        .guide-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(56, 189, 248, 0.25);
            border-radius: 18px;
            padding: 20px 28px;
            margin-bottom: 32px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4),
                        0 0 20px rgba(56, 189, 248, 0.1);
        }

        .header-title {
            font-size: 22px;
            font-weight: 700;
            color: #ffffff;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 14px;
            letter-spacing: -0.5px;
        }

        .title-icon {
            color: #38bdf8;
            filter: drop-shadow(0 0 8px rgba(56, 189, 248, 0.6));
        }

        .btn-login {
            background: linear-gradient(135deg, #0284c7 0%, #2563eb 100%);
            border: 1px solid rgba(56, 189, 248, 0.4);
            color: #ffffff;
            padding: 10px 22px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 4px 15px rgba(2, 132, 199, 0.35);
        }

        .btn-login:hover {
            background: linear-gradient(135deg, #0369a1 0%, #1d4ed8 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(56, 189, 248, 0.5);
            filter: brightness(1.1);
        }

        /* 4. 섹션 제목 스타일 */
        .guide-section {
            margin-bottom: 36px;
        }

        .section-title {
            font-size: 19px;
            font-weight: 700;
            margin: 0 0 16px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: -0.3px;
        }

        .title-blue { color: #38bdf8; text-shadow: 0 0 12px rgba(56, 189, 248, 0.3); }
        .title-orange { color: #fb923c; text-shadow: 0 0 12px rgba(251, 146, 60, 0.3); }
        .title-red { color: #f87171; text-shadow: 0 0 12px rgba(248, 113, 113, 0.3); }

        .section-header-wrap {
            display: flex;
            align-items: baseline;
            gap: 12px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }

        .section-subtext {
            font-size: 13px;
            color: #94a3b8;
        }

        /* 5. 카드 그리드 레이아웃 */
        .card-grid {
            display: grid;
            gap: 20px;
        }

        .grid-3 {
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
        }

        /* 6. 공통 가이드 카드 */
        .guide-card {
            background: rgba(15, 23, 42, 0.55);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 24px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.35);
            transition: all 0.3s ease;
        }

        .guide-card:hover {
            border-color: rgba(56, 189, 248, 0.35);
            transform: translateY(-3px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5),
                        0 0 20px rgba(56, 189, 248, 0.12);
        }

        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: #f1f5f9;
            margin: 0 0 16px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            padding-bottom: 12px;
        }

        .card-title i {
            color: #38bdf8;
        }

        /* 리스트 스타일 */
        .guide-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .guide-list li {
            font-size: 13.5px;
            color: #cbd5e1;
            line-height: 1.6;
            position: relative;
            padding-left: 18px;
        }

        .guide-list li::before {
            content: '•';
            position: absolute;
            left: 0;
            color: #38bdf8;
            font-size: 18px;
            line-height: 1;
            top: 2px;
        }

        .guide-list strong {
            color: #f8fafc;
        }

        /* 7. 대처 요령 단계 배지 */
        .step-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 16px;
            letter-spacing: 0.3px;
        }

        .badge-step1 {
            background: rgba(249, 115, 22, 0.15);
            color: #fb923c;
            border: 1px solid rgba(249, 115, 22, 0.35);
            box-shadow: 0 0 10px rgba(249, 115, 22, 0.15);
        }

        .badge-step2 {
            background: rgba(234, 179, 8, 0.15);
            color: #facc15;
            border: 1px solid rgba(234, 179, 8, 0.35);
            box-shadow: 0 0 10px rgba(234, 179, 8, 0.15);
        }

        .badge-step3 {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.35);
            box-shadow: 0 0 10px rgba(239, 68, 68, 0.15);
        }

        /* 8. 비상연락망 테이블 */
        .table-card {
            padding: 20px 22px;
        }

        .contact-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 6px;
            font-size: 13px;
        }

        .contact-table th {
            background: rgba(0, 0, 0, 0.35);
            color: #94a3b8;
            font-weight: 600;
            text-align: left;
            padding: 10px 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .contact-table td {
            padding: 11px 12px;
            color: #e2e8f0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        }

        .contact-table tbody tr:hover {
            background: rgba(255, 255, 255, 0.04);
        }
    </style>
</head>
<body class="guide-body">

    <!-- Vanta 3D 배경 캔버스 -->
    <div id="vanta-bg"></div>

    <div class="guide-wrapper">
        <!-- 1. 상단 헤더 (타이틀 및 로그인 버튼) -->
        <header class="guide-header">
            <h1 class="header-title">
                <i class="fa-solid fa-bullhorn title-icon"></i>
                행사장 안전관리 가이드 매뉴얼
            </h1>
            <sec:authorize access="isAnonymous()">
                <button type="button" class="btn-login" onclick="location.href='${pageContext.request.contextPath}/login'">
                    <i class="fa-solid fa-right-to-bracket"></i> 로그인
                </button>
            </sec:authorize>
        </header>

        <!-- 메인 콘텐츠 영역 -->
        <main class="guide-content">

            <!-- 2. 행사장 필수 안전수칙 -->
            <section class="guide-section">
                <h2 class="section-title title-blue">
                    <i class="fa-solid fa-shield-virus"></i> 1. 행사장 필수 안전수칙
                </h2>
                <div class="card-grid grid-3">
                    <!-- 수칙 카드 1 -->
                    <div class="guide-card">
                        <h3 class="card-title"><i class="fa-solid fa-people-group"></i> 1) 인파 밀집 제어 수칙</h3>
                        <ul class="guide-list">
                            <li>
                                <strong>일방통행 전환:</strong> 단위 면적당(1m²) 적정 인원 초과 시 이동 동선을 일방통행으로 즉시 전환
                            </li>
                            <li>
                                <strong>대기열 관리:</strong> 관람객 대기열 펜스 설치 간격 준수 및 유지 관리 지침 적용
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
                    <h2 class="section-title title-orange">
                        <i class="fa-solid fa-triangle-exclamation"></i> 2. 위험사건 발생 시 대처요령
                    </h2>
                    <span class="section-subtext">※ 주요 위험 유형: 압사(인파 밀집) 위험, 화재, 지역 특성 위험</span>
                </div>
                <div class="card-grid grid-3">
                    <!-- Step 1 -->
                    <div class="guide-card step-card">
                        <div class="step-badge badge-step1"><i class="fa-solid fa-bell"></i> 1단계: 상황 전파</div>
                        <ul class="guide-list">
                            <li>종합상황실 즉시 무전 보고</li>
                            <li>행사장 내 스피커 및 전광판을 통한 비상 대피 방송 송출</li>
                        </ul>
                    </div>

                    <!-- Step 2 -->
                    <div class="guide-card step-card">
                        <div class="step-badge badge-step2"><i class="fa-solid fa-person-walking-arrow-right"></i> 2단계: 대피 유도</div>
                        <ul class="guide-list">
                            <li>경호 및 안전 요원을 비상구 및 탈출로에 전진 배치</li>
                            <li>유도봉을 활용한 역류 방지 및 분산 대피 동선 제어 가이드 수행</li>
                        </ul>
                    </div>

                    <!-- Step 3 -->
                    <div class="guide-card step-card">
                        <div class="step-badge badge-step3"><i class="fa-solid fa-hand-stop"></i> 3단계: 현장 통제</div>
                        <ul class="guide-list">
                            <li>119/112 구급차 및 경찰차 진입로 확보를 위한 바리케이드 제거</li>
                            <li>추가 민간인 진입 차단선 및 현장 통제</li>
                        </ul>
                    </div>
                </div>
            </section>

            <!-- 4. 비상연락망 매트릭스 -->
            <section class="guide-section">
                <h2 class="section-title title-red">
                    <i class="fa-solid fa-phone-volume"></i> 3. 비상연락망 매트릭스
                </h2>
                <div class="card-grid grid-3">
                    <!-- 연락망 1: 행사 주최측 -->
                    <div class="guide-card table-card">
                        <h3 class="card-title"><i class="fa-solid fa-building-user"></i> 행사 주최측 연락망</h3>
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
                        <h3 class="card-title"><i class="fa-solid fa-building-shield"></i> 유관기관 공식 연락망</h3>
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
                        <h3 class="card-title"><i class="fa-solid fa-truck-medical"></i> 의료 인프라</h3>
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

    <!-- Vanta.js 및 Three.js 라이브러리 CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vanta@latest/dist/vanta.net.min.js"></script>

    <!-- Vanta 이펙트 실행 스크립트 -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            VANTA.NET({
                el: "#vanta-bg",
                mouseControls: true,
                touchControls: true,
                gyroControls: false,
                minHeight: 200.00,
                minWidth: 200.00,
                scale: 1.00,
                scaleMobile: 1.00,
                color: 0x38bdf8,          // 관제 테마 네온 블루
                backgroundColor: 0x060d1f, // 깊이감 있는 파란 바탕색
                points: 10.00,            // 포인트 밀도
                maxDistance: 20.00,
                spacing: 16.00
            });
        });
    </script>
</body>
</html>