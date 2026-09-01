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
import com.spring.service.AgentTaskService;

@Controller
@RequestMapping("/agent")
public class AgentController {
	
	@Autowired
    private AgentTaskService agentTaskService;

    // 안전요원 메인 페이지 이동
    @GetMapping("/main")
    public String agentMainPage() {
        // WEB-INF/views/agent/agentMain.jsp 를 호출합니다.
        return "agent/agentMain"; 
    }
    
 // 상황 보고 페이지 이동
    @GetMapping("/report")
    public String agentReportPage() {
        return "agent/agentReport"; // WEB-INF/views/agent/agentReport.jsp 호출
    }
    
 // 긴급 보고 페이지 이동
    @GetMapping("/emergency")
    public String agentEmergencyPage() {
        return "agent/agentEmergency"; // WEB-INF/views/agent/agentEmergency.jsp
    }
    
 // 보고 등록 완료 페이지 이동
    @GetMapping("/report/complete")
    public String agentReportCompletePage() {
        return "agent/agentReportComplete"; // WEB-INF/views/agent/agentReportComplete.jsp
    }
    
 // 업무 이력 조회 페이지 (GET)
    @GetMapping("/history") // 프로젝트에서 사용 중인 이력 페이지 URL 경로
    public String agentHistoryPage(Model model) {
        
        // 1. DB에서 전체 업무 이력 목록 가져오기
        List<AgentTaskDTO> taskList = agentTaskService.getTaskList();
        
        // 2. JSP로 목록 데이터 전달 ("taskList"라는 이름으로 전달)
        model.addAttribute("taskList", taskList);
        
        // 3. 이력 조회 JSP 파일명 리턴
        return "agent/agentHistory"; // 실제 JSP 파일 경로/파일명에 맞게 수정
    }
    
 // 업무 등록 페이지 이동
    @GetMapping("/task/register")
    public String agentTaskRegisterPage() {
        return "agent/agentTaskRegister"; // WEB-INF/views/agent/agentTaskRegister.jsp
    }
 // 업무 등록 처리 (POST)
    @PostMapping("/task/register")
    public String registerTask(AgentTaskDTO dto) {
        agentTaskService.registerTask(dto);
        return "redirect:/agent/history"; // 등록 후 목록 페이지로 이동 (프로젝트 URL에 맞게 변경 가능)
    }
    
 // 업무 수정 페이지 이동
    @GetMapping("/taskEdit")
    public String agentTaskEditPage(@RequestParam("id") Long taskId, Model model) {
        // 1. DB에서 넘어온 ID로 상세 데이터 조회
        AgentTaskDTO task = agentTaskService.getTaskById(taskId);
        
        // 💡 디버깅용 로그: 콘솔창에서 task 객체 및 taskId가 제대로 들어오는지 확인!
        System.out.println("=== 넘겨받은 taskId: " + taskId);
        System.out.println("=== DB에서 조회된 task: " + task);
        
        // 2. JSP로 전달할 이름("task")이 ${task.taskId}와 일치해야 합니다.
        model.addAttribute("task", task);
        
        return "agent/agentTaskEdit";
    }
 // 업무 수정 처리 (POST)
    @PostMapping("/taskEdit")
    public String modifyTask(AgentTaskDTO dto) {
        // 1. 서비스의 modifyTask 실행 (DB UPDATE)
        boolean result = agentTaskService.modifyTask(dto);
        
        // 2. 수정 완료 후 업무 목록 페이지로 이동
        return "redirect:/agent/history"; // 기존 목록 URL 경로로 설정
    }
    
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
}