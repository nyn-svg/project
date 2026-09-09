package com.spring.controller; // 프로젝트 패키지 경로에 맞게 수정

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.AgentTaskDTO;
import com.spring.dto.UserDTO;
import com.spring.service.AgentTaskService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/agent")
public class AgentController {

	@Autowired
    private AgentTaskService agentTaskService;

	// 안전요원 메인 페이지 이동
	@GetMapping("/main")
	public String agentMainPage(HttpSession session, Model model) {
	    String loginUserId = (String) session.getAttribute("userId");

	    if (loginUserId == null) {
	        loginUserId = "agent01"; // 테스트용 기본 ID
	    }
	    
	    UserDTO user = agentTaskService.findByUserId(loginUserId);
	    model.addAttribute("user", user);
	    return "agent/agentMain"; 
	}
    
 // 상황 보고 페이지 이동
    @GetMapping("/report")
    public String agentReportPage() {
        return "agent/agentReport";
    }
    
 // 긴급 보고 페이지 이동
    @GetMapping("/emergency")
    public String agentEmergencyPage() {
        return "agent/agentEmergency"; 
    }
    
 // 보고 등록 완료 페이지 이동
    @GetMapping("/report/complete")
    public String agentReportCompletePage() {
        return "agent/agentReportComplete"; 
    }
    
 // 업무 이력 조회 페이지
    @GetMapping("/history")
    public String agentHistoryPage(Model model) {
        List<AgentTaskDTO> taskList = agentTaskService.getTaskList();  
        model.addAttribute("taskList", taskList);
        return "agent/agentHistory";
    }
    
 // 업무 등록 페이지 이동
    @GetMapping("/task/register")
    public String agentTaskRegisterPage() {
        return "agent/agentTaskRegister";
    }
    
 // 업무 등록 처리
    @PostMapping("/task/register")
    public String registerTask(AgentTaskDTO dto) {
        agentTaskService.registerTask(dto);
        return "redirect:/agent/history";
    }
    
 // 업무 수정 페이지 이동
    @GetMapping("/taskEdit")
    public String agentTaskEditPage(@RequestParam("id") Long taskId, Model model) {
        AgentTaskDTO task = agentTaskService.getTaskById(taskId);
        System.out.println("=== 넘겨받은 taskId: " + taskId);
        System.out.println("=== DB에서 조회된 task: " + task);  
        model.addAttribute("task", task);
        return "agent/agentTaskEdit";
    }
    
 // 업무 수정 처리
    @PostMapping("/taskEdit")
    public String modifyTask(AgentTaskDTO dto) {
        boolean result = agentTaskService.modifyTask(dto);      
        return "redirect:/agent/history";
    }
    
 // 근무 상태 변경 페이지 이동 (GET)
    @GetMapping("/status/edit")
    public String agentStatusEditPage(HttpSession session, Model model) {
        String loginUserId = (String) session.getAttribute("userId");
        if (loginUserId == null) loginUserId = "agent01";

        UserDTO user = agentTaskService.findByUserId(loginUserId);
        model.addAttribute("user", user);

        return "agent/agentStatusEdit"; 
    }

    // 근무 상태 변경 처리 (POST)
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

    
/* ======================================보류==============================================*/
 // 무한 스크롤용 REST API (목록 + 전체 개수 반환)
    @GetMapping("/history/more")
    @ResponseBody
    public Map<String, Object> getMoreTasks(
            @RequestParam(value = "offset", defaultValue = "0") int offset,
            @RequestParam(value = "limit", defaultValue = "4") int limit,
            @RequestParam(value = "taskArea", required = false) String taskArea,
            @RequestParam(value = "taskType", required = false) String taskType,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate) {

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        paramMap.put("taskArea", taskArea);
        paramMap.put("taskType", taskType);
        paramMap.put("keyword", keyword);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate", endDate);

        // 1. 목록 데이터 조회
        List<AgentTaskDTO> taskList = agentTaskService.getTaskListPaged(paramMap);
        
        // 2. 검색 조건에 맞는 전체 개수 조회
        int totalCount = agentTaskService.getTaskListCount(paramMap);

        // 3. 두 데이터를 하나로 묶어서 반환
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("tasks", taskList);
        resultMap.put("totalCount", totalCount);

        return resultMap;
    }
    
    
 // 안전순찰 페이지
    @GetMapping("/patrol")
    public String agentInfoPage(HttpSession session, Model model) {
        String loginUserId = (String) session.getAttribute("userId");

        if (loginUserId == null) {
            loginUserId = "agent01"; 
        }

        UserDTO user = agentTaskService.findByUserId(loginUserId);
        model.addAttribute("user", user);
        return "agent/agentPatrol"; 
    }
    
}