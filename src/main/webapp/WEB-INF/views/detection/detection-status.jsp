<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="detection-container">
    <!-- 1. 상단 대시보드 영역 -->
    <div class="dashboard-card">
        <!-- 감지 이력 대시보드 영역 -->
        <div class="dashboard-panel active" data-tab-panel="danger">
            <div class="summary-card-grid">
                <!-- 전체 감지이력 -->
                <div class="summary-card total">
                    <div class="card-icon"><i class="fa-solid fa-layer-group"></i></div>
                    <div class="card-info">
                        <span class="card-title">전체 감지이력</span>
                        <span class="card-value" id="danger-total-count">0</span>
                    </div>
                </div>

                <!-- 자동감지 -->
                <div class="summary-card auto">
                    <div class="card-icon"><i class="fa-solid fa-robot"></i></div>
                    <div class="card-info">
                        <span class="card-title">자동감지</span>
                        <span class="card-value" id="danger-auto-count">0</span>
                    </div>
                </div>

                <!-- 수동감지 -->
                <div class="summary-card manual">
                    <div class="card-icon"><i class="fa-solid fa-hand"></i></div>
                    <div class="card-info">
                        <span class="card-title">수동감지</span>
                        <span class="card-value" id="danger-manual-count">0</span>
                    </div>
                </div>

                <!-- 긴급보고 -->
                <div class="summary-card emergency">
                    <div class="card-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div class="card-info">
                        <span class="card-title">긴급보고</span>
                        <span class="card-value" id="danger-emer-count">0</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="dashboard-panel" data-tab-panel="instruction">
		    <div class="summary-card-grid">
		        <!-- 총 조치건 -->
		        <div class="summary-card total">
		            <div class="card-icon"><i class="fa-solid fa-clipboard-list"></i></div>
		            <div class="card-info">
		                <span class="card-title">총 조치건</span>
		                <!-- ✨ ID 변경: instruction-dash-total -->
		                <span class="card-value" id="instruction-dash-total">0</span>
		            </div>
		        </div>
		
		        <!-- 조치 중 -->
		        <div class="summary-card auto">
		            <div class="card-icon"><i class="fa-solid fa-spinner"></i></div>
		            <div class="card-info">
		                <span class="card-title">조치 중</span>
		                <span class="card-value" id="instruction-dash-progress">0</span>
		            </div>
		        </div>
		
		        <!-- 조치 완료 -->
		        <div class="summary-card manual">
		            <div class="card-icon"><i class="fa-solid fa-circle-check"></i></div>
		            <div class="card-info">
		                <span class="card-title">조치 완료</span>
		                <span class="card-value" id="instruction-dash-complete">0</span>
		            </div>
		        </div>
		
		        <!-- 미해결 -->
		        <div class="summary-card emergency">
		            <div class="card-icon"><i class="fa-solid fa-circle-exclamation"></i></div>
		            <div class="card-info">
		                <span class="card-title">미해결</span>
		                <span class="card-value" id="instruction-dash-unresolved">0</span>
		            </div>
		        </div>
		    </div>
		</div>
        <div class="dashboard-panel" data-tab-panel="close">
            <div class="panel-placeholder">종료 이력 대시보드</div>
        </div>
        <div class="dashboard-panel" data-tab-panel="report">
    <div class="summary-card-grid">
        <!-- 총 긴급건 -->
        <div class="summary-card total">
            <div class="card-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
            <div class="card-info">
                <span class="card-title">총 긴급건</span>
                <span class="card-value" id="report-dash-total">0</span>
            </div>
        </div>

        <!-- 즉시 대응 필요 -->
        <div class="summary-card emergency">
            <div class="card-icon"><i class="fa-solid fa-circle-radiation"></i></div>
            <div class="card-info">
                <span class="card-title">즉시 대응 필요</span>
                <span class="card-value" id="report-dash-pending">0</span>
            </div>
        </div>

        <!-- 긴급 조치 중 -->
        <div class="summary-card auto">
            <div class="card-icon"><i class="fa-solid fa-truck-medical"></i></div>
            <div class="card-info">
                <span class="card-title">긴급 조치 중</span>
                <span class="card-value" id="report-dash-progress">0</span>
            </div>
        </div>

        <!-- 긴급 조치 완료 -->
        <div class="summary-card manual">
            <div class="card-icon"><i class="fa-solid fa-shield-check"></i></div>
            <div class="card-info">
                <span class="card-title">긴급 조치 완료</span>
                <span class="card-value" id="report-dash-complete">0</span>
            </div>
        </div>
    </div>
</div>
    </div>

    <!-- 2. 탭 메뉴 영역 -->
    <div class="tab-menu-bar">
	    <button type="button" class="tab-btn active" data-tab="danger" onclick="switchTab('danger', this)">감지 이력</button>
	    <button type="button" class="tab-btn" data-tab="instruction" onclick="switchTab('instruction', this)">조치 현황</button>
	    <button type="button" class="tab-btn" data-tab="close" onclick="switchTab('close', this)">종료 이력</button>
	    <button type="button" class="tab-btn" data-tab="report" onclick="switchTab('report', this)">긴급상황 조치 이력</button>
	</div>

    <!-- 3. 공통 검색폼 영역 -->
    <div class="search-card-container">
	    <!-- ✨ 2. searchForm ID 수정 -->
	    <form id="searchForm" onsubmit="return false;">
	        <div class="search-grid">
	        	
	        	<!-- 1행: 이력번호 / 구역명 -->
	        	<div class="search-item">
	                <label for="search-no">이력번호</label>
	              	<input type="text" id="search-no" name="situNo" class="form-control" placeholder="입력하세요"/>
	            </div>
	            
	            <div class="search-item">
	                <label for="search-zone">구역명</label>
	                <input type="text" id="search-zone" name="zoneName" class="form-control" placeholder="입력하세요"/>
	            </div>
	            
	            <div class="search-item empty-item"></div>
	            
	            <!-- 2행: 위험유형 / 위험단계 / 조치상태 -->
	             <div class="search-item">
	                <label for="search-danger-level">위험단계</label>
	                <select id="search-danger-level" name="dngrLevel" class="form-control">
	                    <option value="">전체</option>
	                    <option value="관심">관심</option>
	                    <option value="주의">주의</option>
	                    <option value="경계">경계</option>
	                    <option value="심각">심각</option>
	                    <option value="판단불가">판단불가</option>
	                </select>
	            </div>
	            
	            <div class="search-item">
	                <label for="search-danger-type">위험유형</label>
	                <select id="search-danger-type" name="dngrType" class="form-control">
	                    <option value="">전체</option>
	                    <option value="인파위험">인파위험</option>
	                    <option value="야생동물">야생동물</option>
	                    <option value="인명사고">인명사고</option>
	                    <option value="시설고장/파손">시설고장/파손</option>
	                    <option value="시설점검">시설점검</option>
	                    <option value="연계필요">연계필요</option>
	                    <option value="기타">기타</option>
	                </select>
	            </div>
	            
	            <div class="search-item" id="search-status-item">
	                <label for="search-status">조치상태</label>
	                <select id="search-status" name="situStatus" class="form-control">
	                    <option value="">전체</option>
	                    <option value="감지">감지</option>
	                    <option value="조치">조치</option>
	                    <option value="조치완료">조치완료</option>
	                    <option value="미해결">미해결</option>
	                    <option value="취소">취소</option>
	                    <option value="APPROVE">승인</option>
	                    <option value="REJECT">반려</option>
	                </select>
	            </div>
				
				<!-- 3행: 발견인 / 조치인 / 검색버튼 -->
	            <div class="search-item" id="search-finder-item">
	                <label for="search-finder">드론/발견인</label>
	                <input type="text" id="search-finder" name="finder" class="form-control" placeholder="입력하세요"/>
	            </div>
	
	            <div class="search-item" id="search-worker-item" style="display: none;">
	                <label for="search-worker">조치인</label>
	                <input type="text" id="search-worker" name="worker" class="form-control" placeholder="입력하세요" />
	            </div>
	
	            <!-- ✨ 3. type="submit"으로 변경 -->
	            <div class="search-item search-btn-wrapper">
	                <button type="button" id="btn-reset" class="btn-reset" onclick="resetSearchForm()">초기화</button>
					<button type="button" id="btn-search" class="btn-search" onclick="loadData(currentTab, 1)">검색</button>
	            </div>
	        </div>
	    </form>
	</div>

    <!-- 4. 하단 목록 영역 -->
    <div class="list-card">
    
		<!-- 감지 이력 목록 패널 -->
		<div class="list-panel active" data-tab-panel="danger">
		    <div class="panel-header-wrap">
		        <div class="panel-title-group">
		            <h3><i class="fa-solid fa-list-check"></i> 감지 이력</h3>
		            <!-- ✨ 4. 목록 헤더 ID 수정 (대시보드 상단 ID와의 충돌 방지) -->
		            <span class="total-count-badge" id="danger-list-total-count">총 0건</span>
		        </div>
		    </div>
		
		    <div class="table-responsive">
		        <table class="custom-table">
					<thead>
					    <tr>
					        <th>NO</th>
					        <th>감지 유형</th>
					        <th>감지 일시</th>
					        <th>위험 단계</th>
					        <th>위험 유형</th>
					        <th>구역명</th>
					        <th>드론/발견인</th>
					        <th>조치 상태</th>
					        <th>상세</th>
					    </tr>
					</thead>
		            <tbody id="detection-list-tbody">
		                <!-- JS에서 동적 렌더링 -->
		            </tbody>
		        </table>
		    </div>
			
			<div id="danger-pagination"></div>
		</div>

        <!-- 조치 현황 패널 영역 -->
		<div class="list-panel" data-tab-panel="instruction">
		    <div class="panel-header-wrap">
		        <div class="panel-title-group">
		            <h3><i class="fa-solid fa-list-check"></i> 조치 현황</h3>
		            <span id="instruction-total-count" class="total-count-badge">총 0건</span>
		        </div>
		    </div>
		    
		    <div class="table-container">
		        <table class="custom-table">
		            <thead>
		                <tr>
		                    <th>NO</th>
					        <th>드론/발견인</th>
					        <th>발생 일시</th>
					        <th>위험 단계</th>
					        <th>위험 유형</th>
					        <th>구역명</th>
					        <th>조치인</th>
					        <th>조치 상태</th>
					        <th>조치 시작 일시</th>
					        <th>조치 종료 일시</th>
					        <th>상세</th>
		                </tr>
		            </thead>
		            <tbody id="instruction-list-tbody">
		            </tbody>
		        </table>
		    </div>
		    
			<div id="instruction-pagination"></div>
		</div>

        <!-- 종료 이력 패널 영역 -->
		<div class="list-panel" data-tab-panel="close">
			<!-- 상단 헤더 영역 -->
			<div class="panel-header-wrap">
				<div class="panel-title-group">
					<h3><i class="fa-solid fa-list-check"></i> 종료 이력</h3>
					<span id="closed-total-count" class="total-count-badge">총 0건</span>
				</div>
			</div>
			
			<!-- 테이블 영역 -->
			<div class="table-container">
				<table class="custom-table">
					<thead>
						<tr>
							<th>NO</th>
							<th>감지 유형</th>
							<th>위험 단계</th>
							<th>위험 유형</th>
							<th>구역명</th>
							<th>감지 일시</th>
							<th>조치 시작 일시</th>
							<th>조치 종료 일시</th>
							<th>조치 상태</th>
							<th>상세</th>
						</tr>
					</thead>
					<tbody id="closed-list-tbody">
						<!-- detection.js를 통해 동적 생성 -->
					</tbody>
				</table>
			</div>
			<!-- 페이징 영역 컨테이너 -->
			<div id="close-pagination"></div>
		</div>

        <!-- 긴급상황 조치 이력 목록 패널 -->
		<div class="list-panel" data-tab-panel="report">
		    <div class="panel-header-wrap">
		        <div class="panel-title-group">
		            <h3><i class="fa-solid fa-triangle-exclamation"></i> 긴급상황 조치 이력</h3>
		            <span id="report-total-count" class="total-count-badge">총 0건</span>
		        </div>
		    </div>
		
		    <div class="table-container">
		        <table class="custom-table">
		            <thead>
		                <tr>
		                    <th>NO</th>
					        <th>감지 유형</th>
					        <th>감지 일시</th>
					        <th>위험 단계</th>
					        <th>위험 유형</th>
					        <th>구역명</th>
							<th>드론/발견인</th>
					        <th>조치 상태</th>
					        <th>상세</th>
		                </tr>
		            </thead>
		            <tbody id="report-list-tbody">
		            </tbody>
		        </table>
		    </div>
		      
			<!-- 페이징 영역 컨테이너 -->
			<div id="report-pagination"></div>
				
		</div>

	</div> <!-- list-card 종료 -->
</div>

<script src="${pageContext.request.contextPath}/resources/js/detection.js"></script>