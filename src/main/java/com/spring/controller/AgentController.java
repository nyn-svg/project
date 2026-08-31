package com.spring.controller; // 프로젝트 패키지 경로에 맞게 수정

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/agent")
public class AgentController {

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
    
 // 업무 이력 조회 페이지 이동
    @GetMapping("/history")
    public String agentHistoryPage() {
        return "agent/agentHistory"; // WEB-INF/views/agent/agentHistory.jsp
    }
    
 // 업무 등록 페이지 이동
    @GetMapping("/task/register")
    public String agentTaskRegisterPage() {
        return "agent/agentTaskRegister"; // WEB-INF/views/agent/agentTaskRegister.jsp
    }
}