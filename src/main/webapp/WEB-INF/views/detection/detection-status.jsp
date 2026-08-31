<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="detection-container">
    
    <!-- 1. 상단 대시보드 영역 -->
    <div class="dashboard-card">
        <div class="dashboard-panel active" data-tab-panel="danger">
            <div class="panel-placeholder">감지 이력 대시보드</div>
        </div>
        <div class="dashboard-panel" data-tab-panel="instruction">
            <div class="panel-placeholder">지시 현황 대시보드</div>
        </div>
        <div class="dashboard-panel" data-tab-panel="close">
            <div class="panel-placeholder">종료 이력 대시보드</div>
        </div>
        <div class="dashboard-panel" data-tab-panel="report">
            <div class="panel-placeholder">보고 현황 대시보드</div>
        </div>

        <!-- 대시보드 우측 하단 버튼 구역 -->
        <div class="dashboard-action-btns">
            <button type="button" class="btn-action">업무지시</button>
            <button type="button" class="btn-action">긴급보고</button>
        </div>
    </div>

    <!-- 2. 탭 메뉴 영역 -->
    <div class="tab-menu-bar">
        <button type="button" class="tab-btn active" data-tab="danger">감지 이력</button>
        <button type="button" class="tab-btn" data-tab="instruction">지시 현황</button>
        <button type="button" class="tab-btn" data-tab="close">종료 이력</button>
        <button type="button" class="tab-btn" data-tab="report">보고 현황</button>
    </div>

    <!-- 3. 검색폼 영역 -->
    <div class="search-form-card">
        <div class="search-panel active" data-tab-panel="danger">
            <div class="panel-placeholder">감지 이력 검색폼</div>
        </div>
        <div class="search-panel" data-tab-panel="instruction">
            <div class="panel-placeholder">지시 현황 검색폼</div>
        </div>
        <div class="search-panel" data-tab-panel="close">
            <div class="panel-placeholder">종료 이력 검색폼</div>
        </div>
        <div class="search-panel" data-tab-panel="report">
            <div class="panel-placeholder">보고 현황 검색폼</div>
        </div>
    </div>

    <!-- 4. 하단 목록 영역 (탭별 분기) -->
    <div class="list-card">
    
    
		        <!-- 감지 이력 목록 패널 -->
		<div class="list-panel active" data-tab-panel="danger">
		    <!-- 상단 헤더 (제목 + 총 건수 + 수동 등록 버튼) -->
		    <div class="panel-header-wrap">
		        <div class="panel-title-group">
		            <h3><i class="fa-solid fa-list-check"></i>객체 감지 이력</h3>
		            <span class="total-count-badge" id="total-count">총 2건</span>
		        </div>
		        <button type="button" class="btn-manual-event">+ 수동 이벤트 등록</button>
		    </div>
		
		    <!-- 테이블 영역 -->
		    <div class="table-responsive">
		        <table class="custom-table">
		            <thead>
		                <tr>
		                    <th>NO</th>
		                    <th>감지 유형</th>
		                    <th>감지 일시</th>
		                    <th>위험 등급</th>
		                    <th>위험 유형</th>
		                    <th>구역명</th>
		                    <th>처리 상태</th>
		                    <th>상세</th>
		                </tr>
		            </thead>
		            <tbody id="detection-list-tbody">
		                <!-- JS에서 동적 렌더링 -->
		            </tbody>
		        </table>
		    </div>
		
		  
		</div>

        <!-- 지시 현황 패널 영역 -->
		<div class="list-panel" data-tab-panel="instruction">
		    <div class="panel-header-wrap">
		        <div class="panel-title-group">
		            <h3>📋 업무 지시 이력</h3>
		            <span id="instruction-total-count" class="total-count-badge">총 2건</span>
		        </div>
		    </div>
		    
		
		    <div class="table-container">
		        <table class="custom-table" style="width: 100%; border-collapse: collapse; text-align: center;">
		            <thead>
		                <tr style="background-color: #1e293b; color: #cbd5e1; height: 40px;">
		                    <th>이력번호</th>
		                    <th>처리상태</th>
		                    <th>업무유형</th>
		                    <th>구역명</th>
		                    <th>제목</th>
		                    <th>작성자</th>
		                    <th>작성일시</th>
		                    <th>상세</th>
		                </tr>
		            </thead>
		            <tbody id="instruction-list-tbody">
		                <!-- detection.js의 renderInstructionList()를 통해 동적 생성됨 -->
		            </tbody>
		        </table>
		    </div>
		</div>

        <!-- 종료 이력 패널 영역 -->
			<div class="list-panel" data-tab-panel="close">
			    <!-- 상단 헤더 영역 -->
			    <div class="panel-header-wrap">
			        <div class="panel-title-group">
			            <h3>📑 종료 이력</h3>
			            <span id="closed-total-count" class="total-count-badge">총 0건</span>
			        </div>
			    </div>
			
			    <!-- 테이블 영역 -->
			    <div class="table-container">
			        <table class="custom-table">
			            <thead>
			                <tr>
			                    <th>이력번호</th>
			                    <th>처리상태</th>
			                    <th>업무유형</th>
			                    <th>구역명</th>
			                    <th>제목</th>
			                    <th>작성자</th>
			                    <th>작성일시</th>
			                    <th>상세</th>
			                </tr>
			            </thead>
			            <tbody id="closed-list-tbody">
			                <!-- detection.js를 통해 동적 생성 -->
			            </tbody>
			        </table>
			    </div>
			</div>

        <!-- 보고 현황 목록 패널 -->
			<div class="list-panel" data-tab-panel="report">
			    <!-- 상단 헤더 영역 -->
			    <div class="panel-header-wrap">
			        <div class="panel-title-group">
			            <h3>📢 상황 및 긴급 보고 이력</h3>
			            <span id="report-total-count" class="total-count-badge">총 0건</span>
			        </div>
			    </div>
			
			    <!-- 테이블 영역 -->
			    <div class="table-container">
			        <table class="custom-table">
			            <thead>
			                <tr>
			                    <th>이력번호</th>
			                    <th>처리상태</th>
			                    <th>위험유형</th>
			                    <th>구역명</th>
			                    <th>제목</th>
			                    <th>작성자</th>
			                    <th>작성일시</th>
			                    <th>상세</th>
			                </tr>
			            </thead>
			            <tbody id="report-list-tbody">
			                <!-- detection.js를 통해 동적 생성 -->
			            </tbody>
			        </table>
			    </div>
			</div>

	</div> <!-- list-card 종료 -->	

</div>

<!-- 분리한 외부 자바스크립트 파일 호출 (실제 경로에 맞춰 수정) -->
<script src="${pageContext.request.contextPath}/resources/js/detection.js"></script>