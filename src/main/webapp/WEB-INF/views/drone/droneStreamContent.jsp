<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 상단 관제 상태 바 -->
<div class="aurora-card" style="padding: 16px 24px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
    <div style="display: flex; align-items: center; gap: 12px;">
        <span style="font-size: 24px;">🛸</span>
        <div>
            <h2 style="font-size: 20px; font-weight: 700; color: #f8fafc; margin: 0;">
                드론 <c:out value="${param.id}" default="A" /> 실시간 스트리밍 관제
            </h2>
            <p style="font-size: 13px; color: #94a3b8; margin-top: 4px;">
                실시간 고화질 영상 수신 및 기체 상태 모니터링 중입니다.
            </p>
        </div>
    </div>
    
    <!-- LIVE 연결 상태 표시 -->
    <div style="display: flex; align-items: center; gap: 8px; background: rgba(34, 197, 94, 0.15); border: 1px solid rgba(34, 197, 94, 0.3); padding: 6px 14px; border-radius: 20px;">
        <span style="width: 8px; height: 8px; background-color: #22c55e; border-radius: 50%; display: inline-block;"></span>
        <span style="color: #4ade80; font-size: 13px; font-weight: 600;">LIVE CONNECTED</span>
    </div>
</div>

<!-- 메인 스트리밍 및 텔레메트리 레이아웃 -->
<div style="display: flex; gap: 20px; height: calc(100vh - 220px);">
    
    <!-- 1. 좌측: 메인 스트리밍 영상 플레이어 구역 -->
    <div class="aurora-card" style="flex: 3; display: flex; flex-direction: column; justify-content: center; align-items: center; position: relative; overflow: hidden; background: #000000;">
        <!-- 나중에 실제 <video> 또는 RTSP 스트리밍 태그가 들어갈 위치 -->
        <div style="text-align: center; color: #64748b;">
            <div style="font-size: 48px; margin-bottom: 12px;">📹</div>
            <p style="font-size: 16px; color: #38bdf8; font-weight: 600;">
                드론 <c:out value="${param.id}" default="A" /> 영상 스트리밍 수신 대기 중...
            </p>
            <p style="font-size: 13px; color: #64748b; margin-top: 6px;">RTSP / WebRTC Stream Feed</p>
        </div>

        <!-- OSDOverlay 정보 (선택사항) -->
        <div style="position: absolute; bottom: 16px; left: 16px; background: rgba(15, 23, 42, 0.75); backdrop-filter: blur(8px); padding: 8px 14px; border-radius: 8px; font-size: 12px; color: #cbd5e1;">
            FPS: <span style="color: #38bdf8;">60</span> | Resolution: <span style="color: #38bdf8;">1080p</span>
        </div>
    </div>

    <!-- 2. 우측: 드론 실시간 텔레메트리(상태 정보) 구역 -->
    <div class="aurora-card" style="flex: 1; padding: 20px; display: flex; flex-direction: column; gap: 16px;">
        <h3 style="font-size: 16px; font-weight: 700; color: #f8fafc; border-bottom: 1px solid rgba(255, 255, 255, 0.1); padding-bottom: 12px; margin: 0;">
            기체 데이터
        </h3>

        <!-- 상태 항목들 -->
        <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid rgba(255, 255, 255, 0.05);">
            <span style="color: #94a3b8; font-size: 13px;">배터리 잔량</span>
            <span style="color: #38bdf8; font-weight: 700; font-size: 14px;">87% 🔋</span>
        </div>

    </div>
</div>