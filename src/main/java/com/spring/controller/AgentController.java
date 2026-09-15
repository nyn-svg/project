package com.spring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.spring.dto.AgentDTO;
import com.spring.dto.ChecklistItemDTO;
import com.spring.dto.EmergencyContactDTO;
import com.spring.dto.SafetyCheckDetailDTO;
import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.dto.SituationDTO;
import com.spring.dto.UserDTO;
import com.spring.service.AgentService;
import com.spring.service.ChecklistService;
import com.spring.service.EmergencyContactService;
import com.spring.service.SituationService;
import com.spring.service.SseService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/agent")
public class AgentController {

	@Autowired
	private AgentService agentService;
	@Autowired
	private ChecklistService checklistService;
	@Autowired
	private EmergencyContactService emergencyContactService;
	@Autowired
	private SituationService situationService;
	@Autowired
	private SseService sseService;

	/* ==========[공통 알림]============= */
	@GetMapping(value = "/sse/connect", produces = "text/event-stream")
	@ResponseBody 
	public SseEmitter connectSse() {
		return sseService.subscribe();
	}

	@PostMapping("/situation/accept")
	@ResponseBody
	public Map<String, Object> acceptSituation(@RequestParam("situNo") String situNo,
			jakarta.servlet.http.HttpSession session) {
		Map<String, Object> resultMap = new HashMap<>();
		try {
			String loginUserId = (String) session.getAttribute("userId");
			if (loginUserId == null)
				loginUserId = "agent01"; 

			SituationDTO situation = situationService.getSituationBySituNo(situNo);
			if (situation != null) {
				situation.setSituStatus("조치");
				situation.setWorker(loginUserId);
				
				situationService.modifySituation(situation);
				situationService.setStart(situNo); 

				resultMap.put("success", true);
			} else {
				resultMap.put("success", false);
				resultMap.put("message", "존재하지 않는 이력입니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("success", false);
			resultMap.put("message", "서버 오류 발생");
		}
		return resultMap;
	}
	

	/* ==========[메인 페이지]============= */
	@GetMapping("/main")
	public String agentMainPage(HttpSession session, Model model) {
		String loginUserId = (String) session.getAttribute("userId");
		if (loginUserId == null)
			loginUserId = "agent01";

		AgentDTO user = agentService.getAgentInfo(loginUserId);
		model.addAttribute("user", user); 
		return "agent/agentMain";
	}

	// 근무 상태 변경 페이지
	@GetMapping("/status/edit")
	public String agentStatusEditPage(HttpSession session, Model model) {
		String loginUserId = (String) session.getAttribute("userId");
		if (loginUserId == null)
			loginUserId = "agent01";

		AgentDTO user = agentService.getAgentInfo(loginUserId);
		model.addAttribute("user", user);
		return "agent/agentStatusEdit";
	}

	// 근무 상태 변경 처리
	@PostMapping("/status/edit")
	public String updateWorkStatus(@RequestParam("workStatus") String workStatus, HttpSession session) {
		String loginUserId = (String) session.getAttribute("userId");
		if (loginUserId == null)
			loginUserId = "agent01";

		agentService.changeAgentStatus(loginUserId, workStatus);
		return "redirect:/agent/main";
	}

	// 비상연락망 목록 조회 API
	@GetMapping("/emergency-contacts")
	@ResponseBody
	public List<EmergencyContactDTO> getEmergencyContacts() {
		return emergencyContactService.getContactList();
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/login";
	}

	/* ==========[안전순찰 페이지]============= */
	@GetMapping("/patrol")
	public String agentInfoPage(HttpSession session, Model model) {
	    String loginUserId = (String) session.getAttribute("userId");
	    if (loginUserId == null) loginUserId = "agent01";

	    UserDTO user = agentService.findByUserId(loginUserId);
	    model.addAttribute("user", user);

	    String workArea = user.getWorkArea(); 
	    List<Map<String, Object>> todayList = checklistService.getTodayPatrolByArea(workArea);
	    
	    model.addAttribute("todayList", todayList);

	    return "agent/agentPatrol";
	}

	// 긴급 보고
	@GetMapping("/emergency")
	public String agentEmergencyPage() {
		return "agent/agentEmergency";
	}
	
	// 보고 등록 완료 페이지
	@GetMapping("/report/complete")
	public String agentReportCompletePage() {
		return "agent/agentReportComplete";
	}

	// 사전점검
	@GetMapping("/safetyCheck")
	public String safetyCheckPage(Model model) {
	    List<ChecklistItemDTO> checklist = checklistService.getItemsByTarget("AGENT");
	    model.addAttribute("checklist", checklist);
	    return "agent/agentsafetyCheck";
	}

	// 사전점검 작성 결과
	@PostMapping("/safetyCheck/submit")
	@ResponseBody
	public Map<String, Object> submitSafetyCheck(@RequestBody SafetyCheckMasterDTO masterDTO, HttpSession session) {
	    Map<String, Object> resultMap = new HashMap<>();

	    try {
	        String loginUserId = (String) session.getAttribute("userId");
	        if (loginUserId == null) loginUserId = "agent01";

	        masterDTO.setInspector(loginUserId);

	        int normalCount = 0;
	        int warnCount = 0;

	        // SafetyCheckDetailDTO 사용
	        if (masterDTO.getDetailList() != null) {
	            for (SafetyCheckDetailDTO detail : masterDTO.getDetailList()) {
	                
	                // 선택한 상태 값 확인 (정상 vs 보완필요)
	                String status = detail.getStatusCode();
	                
	                if ("NORMAL".equals(status) || "정상".equals(status)) {
	                    normalCount++;
	                } else {
	                    warnCount++;
	                }
	            }
	        }

	        int totalCount = normalCount + warnCount;

	        // TODO: 관리자 팀에서 ChecklistService에 insert 메소드 추가 시 주석 해제 연결
	        checklistService.insertSafetyCheck(masterDTO);

	        // 완료 화면 전달용 데이터 세션 저장
	        session.setAttribute("totalCount", totalCount);
	        session.setAttribute("normalCount", normalCount);
	        session.setAttribute("warnCount", warnCount);

	        resultMap.put("success", true);
	        resultMap.put("message", "점검 보고가 정상적으로 완료되었습니다.");

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("success", false);
	        resultMap.put("message", "점검 보고 제출 중 오류가 발생했습니다.");
	    }

	    return resultMap;
	}

	// 3. 사전점검 완료 화면 이동
	@GetMapping("/safetyCheck/complete")
	public String agentReportCompletePage(HttpSession session, Model model) {
	    // 세션에 저장된 통계 데이터 전달
	    model.addAttribute("totalCount", session.getAttribute("totalCount"));
	    model.addAttribute("normalCount", session.getAttribute("normalCount"));
	    model.addAttribute("warnCount", session.getAttribute("warnCount"));

	    return "agent/agentsafetyCheckComplete";
	}

	/* ==========[조치보고 페이지]============= */
	@GetMapping("/history/more")
	@ResponseBody
	public Map<String, Object> getMoreTasks(@RequestParam(value = "offset", defaultValue = "0") int offset,
			@RequestParam(value = "limit", defaultValue = "4") int limit,
			@RequestParam(value = "actionStatus", required = false, defaultValue = "ALL") String actionStatus,
			HttpSession session) { 

		String loginUserId = (String) session.getAttribute("userId");
		if (loginUserId == null) loginUserId = "agent01";

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		paramMap.put("actionStatus", actionStatus); 
		paramMap.put("userId", loginUserId); 

		List<SituationDTO> taskList = situationService.getTaskListPaged(paramMap);
		int totalCount = situationService.getTaskListCount(paramMap);

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("tasks", taskList);
		resultMap.put("totalCount", totalCount);

		return resultMap;
	}

	@GetMapping("/report")
	public String agentReportPage() {
		return "agent/agentReport";
	}

	@GetMapping("/history")
	public String agentHistoryPage(Model model) {
		return "agent/agentHistory";
	}

	@GetMapping("/taskEdit")
	public String agentTaskEditPage(@RequestParam("situNo") String situNo, Model model) {
		SituationDTO situation = situationService.getSituationBySituNo(situNo);
		model.addAttribute("task", situation); 
		
		java.text.SimpleDateFormat cstSdf = new java.text.SimpleDateFormat("yyyy-MM-dd a hh:mm");
		
		if (situation != null && situation.getStartDate() != null) {
			String customStartStr = cstSdf.format(situation.getStartDate());
			model.addAttribute("customStartDate", customStartStr); 
		} else {
			model.addAttribute("customStartDate", "기록 없음");
		}
		
		return "agent/agentTaskEdit";
	}

	@PostMapping("/taskEdit")
	public String modifyTask(HttpServletRequest request, HttpSession session) {
		try {
			// 1. 파라미터 수동 제어 추출 (400 예러 원천 봉쇄)
			String situNo = request.getParameter("situNo");
			String situStatus = request.getParameter("situStatus");
			String workContent = request.getParameter("workContent");
			String rawEndDate = request.getParameter("endDate");
			
			String loginUserId = (String) session.getAttribute("userId");
			if (loginUserId == null) loginUserId = "agent01";

			// 2. 다른 팀원분들의 기존 설계 DTO에 바인딩
			SituationDTO dto = new SituationDTO();
			dto.setSituNo(situNo);
			dto.setWorker(loginUserId);
			dto.setWorkContent(workContent);

			// 3. [탭 연동 정렬] 무한 스크롤 카운트 조건절 규칙인 '조치완료' 문자열 기호로 완벽 일치화
			if ("COMPLETED".equals(situStatus) || "조치완료".equals(situStatus) || "완료".equals(situStatus)) {
				dto.setSituStatus("조치완료"); 
				situationService.setEnd(situNo); // 마감 완료 날짜 자동 연동 호출
			} else {
				dto.setSituStatus("조치");
			}

			// 4. 완료 시간 문자열 -> Date 객체 파싱 매핑
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
			if (rawEndDate != null && !rawEndDate.trim().isEmpty()) {
				dto.setEndDate(sdf.parse(rawEndDate)); 
			}

			dto.setWorkImage("");

			// 5. 공통 서비스 호출 인터페이스 위임 실행
			try {
				situationService.modifySituation(dto); 
			} catch (Exception e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:/agent/history";
	}
}
