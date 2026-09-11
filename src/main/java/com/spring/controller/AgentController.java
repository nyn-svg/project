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

import com.spring.dto.AgentTaskDTO;
import com.spring.dto.ChecklistItemDTO;
import com.spring.dto.SafetyCheckDetailDTO;
import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.dto.UserDTO;
import com.spring.service.AgentTaskService;
import com.spring.service.ChecklistService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/agent")
public class AgentController {

	@Autowired
	private AgentTaskService agentTaskService;
	@Autowired
	private ChecklistService checklistService;

	/* ==========[메인 페이지]============= */
	@GetMapping("/main")
	public String agentMainPage(HttpSession session, Model model) {
		String loginUserId = (String) session.getAttribute("userId");
		if (loginUserId == null) loginUserId = "agent01";

		UserDTO user = agentTaskService.findByUserId(loginUserId);
		model.addAttribute("user", user);
		return "agent/agentMain";
	}

	// 근무 상태 변경 페이지
	@GetMapping("/status/edit")
	public String agentStatusEditPage(HttpSession session, Model model) {
		String loginUserId = (String) session.getAttribute("userId");
		if (loginUserId == null) loginUserId = "agent01";

		UserDTO user = agentTaskService.findByUserId(loginUserId);
		model.addAttribute("user", user);
		return "agent/agentStatusEdit";
	}

	// 근무 상태 변경
	@PostMapping("/status/edit")
	public String updateWorkStatus(@RequestParam("workStatus") String workStatus, HttpSession session) {
		String loginUserId = (String) session.getAttribute("userId");
		if (loginUserId == null) loginUserId = "agent01";
		agentTaskService.updateWorkStatus(loginUserId, workStatus);
		return "redirect:/agent/main";
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

		UserDTO user = agentTaskService.findByUserId(loginUserId);
		model.addAttribute("user", user);
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
	public Map<String, Object> getMoreTasks(
			@RequestParam(value = "offset", defaultValue = "0") int offset,
			@RequestParam(value = "limit", defaultValue = "4") int limit,
			@RequestParam(value = "actionStatus", required = false, defaultValue = "ALL") String actionStatus) {

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		paramMap.put("actionStatus", actionStatus); // 상태 파라미터 전달

		List<AgentTaskDTO> taskList = agentTaskService.getTaskListPaged(paramMap);
		int totalCount = agentTaskService.getTaskListCount(paramMap);

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
		List<AgentTaskDTO> taskList = agentTaskService.getTaskList();
		model.addAttribute("taskList", taskList);
		return "agent/agentHistory";
	}

	@GetMapping("/task/register")
	public String agentTaskRegisterPage() {
		return "agent/agentTaskRegister";
	}

	@PostMapping("/task/register")
	public String registerTask(AgentTaskDTO dto) {
		agentTaskService.registerTask(dto);
		return "redirect:/agent/history";
	}

	@GetMapping("/taskEdit")
	public String agentTaskEditPage(@RequestParam("id") Long taskId, Model model) {
		AgentTaskDTO task = agentTaskService.getTaskById(taskId);
		model.addAttribute("task", task);
		return "agent/agentTaskEdit";
	}

	@PostMapping("/taskEdit")
	public String modifyTask(AgentTaskDTO dto) {
		boolean result = agentTaskService.modifyTask(dto);
		return "redirect:/agent/history";
	}
}