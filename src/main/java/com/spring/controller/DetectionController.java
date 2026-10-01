package com.spring.controller; // 프로젝트의 실제 패키지 경로로 수정해주세요.

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.SituationDTO;
import com.spring.service.SituationService;

@Controller
@RequestMapping("/detection")
public class DetectionController {
	
	@Autowired
    private SituationService situationService;
	
	// 탭별 목록 및 페이징 조회 API
	@GetMapping("/api/list")
	@ResponseBody
	public Map<String, Object> getDetectionApiList(@RequestParam(value = "tabType", defaultValue = "danger") String tabType,
	        									   @RequestParam(value = "page", defaultValue = "1") int page,
	        									   @RequestParam(value = "limit", defaultValue = "10") int limit,
	        									   @RequestParam(value = "situNo", required = false) String situNo,
	        									   @RequestParam(value = "zoneName", required = false) String zoneName,
	        									   @RequestParam(value = "dngrType", required = false) String dngrType,
	        									   @RequestParam(value = "dngrLevel", required = false) String dngrLevel,
	        									   @RequestParam(value = "situStatus", required = false) String situStatus,
	        									   @RequestParam(value = "finder", required = false) String finder,
	        									   @RequestParam(value = "worker", required = false) String worker) {

	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("tabType", tabType);
	    paramMap.put("offset", (page - 1) * limit);
	    paramMap.put("limit", limit);
	    
	    // 상세 검색 파라미터 바인딩
	    paramMap.put("situNo", situNo);
	    paramMap.put("zoneName", zoneName);
	    paramMap.put("dngrType", dngrType);
	    paramMap.put("dngrLevel", dngrLevel);
	    paramMap.put("situStatus", situStatus);
	    paramMap.put("finder", finder);
	    paramMap.put("worker", worker);

	    List<SituationDTO> list = situationService.getSituationListPaged(paramMap);
	    int totalCount = situationService.getSituationCountPaged(paramMap);

	    Map<String, Object> response = new HashMap<>();
	    response.put("list", list);
	    response.put("totalCount", totalCount);
	    response.put("currentPage", page);
	    response.put("totalPages", (int) Math.ceil((double) totalCount / limit));

	    return response;
	}

	// 상단 대시보드 요약 카운트 API
	@GetMapping("/api/dashboard-summary")
	@ResponseBody
	public Map<String, Object> getDashboardSummary() {
	    // 감지 유형별 요약(전체/자동/수동/긴급) 데이터 반환으로 변경
	    return situationService.getDangerDashboardSummary();
	}
	
	// 조치 현황 대시보드 요약 API
	@GetMapping("/api/instruction-dashboard-summary")
	@ResponseBody
	public Map<String, Object> getInstructionDashboardSummary() {
	    return situationService.getInstructionDashboardSummary();
	}
	
	// 4. 긴급상황 조치 이력 대시보드 요약 API
    @GetMapping("/api/report-dashboard-summary")
    @ResponseBody
    public Map<String, Object> getReportDashboardSummary() {
        return situationService.getReportDashboardSummary();
    }
}