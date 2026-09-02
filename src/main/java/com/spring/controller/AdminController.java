package com.spring.controller; // 프로젝트 패키지 경로에 맞게 수정

import java.util.List;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.dto.UserDTO; // 프로젝트 DTO 경로에 맞게 수정
import com.spring.service.AdminService; // 관리자 전용 Service (또는 AgentTaskService)

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService; // 관리자 전용 서비스 DI

    /**
     * 관리자 메인 대시보드 페이지 이동
     * RequestMapping: GET /admin/main
     */
    @GetMapping("/main")
    public String adminMainPage(HttpSession session, Model model) {
        
        // 1. 관리자 권한 세션 체크 (필요시 활성화)
        /*
        String role = (String) session.getAttribute("role");
        if (role == null || !role.contains("ROLE_ADMIN")) {
            return "redirect:/login";
        }
        */

        // 2. 대시보드 상단 요약 통계 데이터 조회
        int totalAgentCount = adminService.getTotalAgentCount();  // 전체 요원 수
        int onDutyCount     = adminService.getOnDutyAgentCount(); // 근무중 요원 수
        int breakCount      = adminService.getBreakAgentCount();  // 휴식/외출 요원 수
        int offDutyCount    = adminService.getOffDutyAgentCount(); // 퇴근 요원 수

        // 3. 실시간 안전요원 목록 조회
        List<UserDTO> agentList = adminService.getAllAgentList();

        // 4. Model 객체에 데이터 전달
        model.addAttribute("totalAgentCount", totalAgentCount);
        model.addAttribute("onDutyCount", onDutyCount);
        model.addAttribute("breakCount", breakCount);
        model.addAttribute("offDutyCount", offDutyCount);
        model.addAttribute("agentList", agentList);

        // 5. 관리자 메인 JSP 경로 반환
        return "admin/adminMain"; // WEB-INF/views/admin/adminMain.jsp
    }
}