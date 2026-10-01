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
												   @RequestParam(value = "searchType", required = false) String searchType,
												   @RequestParam(value = "keyword", required = false) String keyword) {

	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("tabType", tabType);
	    paramMap.put("offset", (page - 1) * limit);
	    paramMap.put("limit", limit);
	    paramMap.put("searchType", searchType);
	    paramMap.put("keyword", keyword);

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
	    Map<String, Object> result = new HashMap<>();
	    
	    // 각각의 탭 카운트 세팅
	    Map<String, Object> paramMap = new HashMap<>();
	    
	    paramMap.put("tabType", "danger");
	    result.put("dangerCount", situationService.getSituationCountPaged(paramMap));
	    
	    paramMap.put("tabType", "instruction");
	    result.put("instructionCount", situationService.getSituationCountPaged(paramMap));
	    
	    paramMap.put("tabType", "close");
	    result.put("closeCount", situationService.getSituationCountPaged(paramMap));
	    
	    paramMap.put("tabType", "report");
	    result.put("reportCount", situationService.getSituationCountPaged(paramMap));

	    return result;
	}
}