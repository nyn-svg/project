<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="detection-container">
    
    <!-- 1. 상단 대시보드 영역 -->
    <div class="dashboard-card">
        <div class="dashboard-panel active" data-tab-panel="danger">
            <div class="panel-placeholder">감지 이력 대시보드</div>
        </div>
        <div class="dashboard-panel" data-tab-panel="instruction">
            <div class="panel-placeholder">조치 현황 대시보드</div>
        </div>
        <div class="dashboard-panel" data-tab-panel="close">
            <div class="panel-placeholder">종료 이력 대시보드</div>
        </div>
        <div class="dashboard-panel" data-tab-panel="report">
            <div class="panel-placeholder">긴급상황 조치 대시보드</div>
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
	    <form id="search-form" onsubmit="return false;">
	        <div class="search-grid">
	        	
	        	<!-- 1행: 이력번호 / 구역명 / (공백 채움용) -->
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
	                <label for="search-danger-type">위험유형</label>
	                <select id="search-danger-type" name="dngrType" class="form-control">
	                    <option value="">선택하세요</option>
	                    <option value="인파위험">인파위험</option>
	                    <option value="야생동물">야생동물</option>
	                    <option value="인명사고">인명사고</option>
	                    <option value="시설고장/파손">시설고장/파손</option>
	                    <option value="시설점검">시설점검</option>
	                    <option value="연계필요">연계필요</option>
	                    <option value="기타">기타</option>
	                </select>
	            </div>
	            
	            <div class="search-item">
	                <label for="search-danger-level">위험단계</label>
	                <select id="search-danger-level" name="dngrLevel" class="form-control">
	                    <option value="">선택하세요</option>
	                    <option value="관심">관심</option>
	                    <option value="주의">주의</option>
	                    <option value="경계">경계</option>
	                    <option value="심각">심각</option>
	                    <option value="판단불가">판단불가</option>
	                </select>
	            </div>
	            
	            <div class="search-item">
	                <label for="search-status">조치상태</label>
	                <select id="search-status" name="situStatus" class="form-control">
	                    <option value="">선택하세요</option>
	                    <option value="감지">감지</option>
	                    <option value="조치">조치</option>
	                    <option value="조치완료">조치완료</option>
	                    <option value="미해결">미해결</option>
	                    <option value="취소">취소</option>
	                    <option value="APPROVE">승인</option>
	                    <option value="REJECT">반려</option>
	                </select>
	            </div>
				
				<!-- 3행: 발견인 / 조치인(동적 제어) / 검색버튼 -->
	            <div class="search-item">
	                <label for="search-finder">발견인</label>
	                <input type="text" id="search-finder" name="finder" class="form-control" placeholder="입력하세요"/>
	            </div>
	
	            <div class="search-item" id="search-worker-item" style="display: none;">
	                <label for="search-worker">조치인</label>
	                <input type="text" id="search-worker" name="worker" class="form-control" placeholder="입력하세요" />
	            </div>
	
	            <!-- 검색 버튼 -->
	            <div class="search-item search-btn-wrapper">
	                <button type="button" id="btn-search" class="btn-search">검색</button>
	            </div>
	        </div>
	    </form>
	</div>

    <!-- 4. 하단 목록 영역 (탭별 분기) -->
    <div class="list-card">
    
		<!-- 감지 이력 목록 패널 -->
		<div class="list-panel active" data-tab-panel="danger">
		    <!-- 상단 헤더 (제목 + 총 건수 + 수동 등록 버튼) -->
		    <div class="panel-header-wrap">
		        <div class="panel-title-group">
		            <h3><i class="fa-solid fa-list-check"></i> 감지 이력</h3>
		            <span class="total-count-badge" id="total-count">총 0건</span>
		        </div>
		    </div>
		
		    <!-- 테이블 영역 -->
		    <div class="table-responsive">
		        <table class="custom-table">
		            <!-- 테이블 헤더 통일 (모든 탭 동일하게 적용) -->
					<thead>
					    <tr>
					        <th>NO</th>
					        <th>감지 유형</th>
					        <th>감지 일시</th>
					        <th>위험 단계</th>
					        <th>위험 유형</th>
					        <th>구역명</th>
					        <th>조치 상태</th>
					        <th>상세</th>
					    </tr>
					</thead>
		            <tbody id="detection-list-tbody">
		                <!-- JS에서 동적 렌더링 -->
		            </tbody>
		        </table>
		    </div>
			
			<!-- 페이징 영역 컨테이너 -->
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
					        <th>발견인</th>
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
		                <!-- detection.js의 renderInstructionList()를 통해 동적 생성됨 -->
		            </tbody>
		        </table>
		    </div>
		    
		    <!-- 페이징 영역 컨테이너 -->
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
						        <th>감지 일시</th>
						        <th>종료 일시</th>
						        <th>위험 단계</th>
						        <th>위험 유형</th>
						        <th>구역명</th>
						        <th>발견인</th>
						        <th>조치인</th>
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
			    <!-- 상단 헤더 영역 -->
			    <div class="panel-header-wrap">
			        <div class="panel-title-group">
			            <h3><i class="fa-solid fa-triangle-exclamation"></i> 긴급상황 조치 이력</h3>
			            <span id="report-total-count" class="total-count-badge">총 0건</span>
			        </div>
			    </div>
			
			    <!-- 테이블 영역 -->
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
						        <th>조치 상태</th>
						        <th>상세</th>
			                </tr>
			            </thead>
			            <tbody id="report-list-tbody">
			                <!-- detection.js를 통해 동적 생성 -->
			            </tbody>
			        </table>
			    </div>
			    
			    <!-- 페이징 영역 컨테이너 -->
				<div id="report-pagination"></div>
				
			</div>

	</div> <!-- list-card 종료 -->

</div>

<!-- 분리한 외부 자바스크립트 파일 호출 (실제 경로에 맞춰 수정) -->
<script src="${pageContext.request.contextPath}/resources/js/detection.js"></script>