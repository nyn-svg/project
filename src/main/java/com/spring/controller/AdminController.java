package com.spring.controller; // 프로젝트 패키지 경로에 맞게 수정

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.UserDTO; // 프로젝트 DTO 경로에 맞게 수정
import com.spring.service.AdminService; // 관리자 전용 Service (또는 AgentTaskService)
import com.spring.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private AdminService adminService; // 관리자 전용 서비스 DI

	@Autowired
	private UserService userService; // 사용자/안전요원 관리 서비스 DI

	/**
	 * 관리자 메인 대시보드 페이지 이동 RequestMapping: GET /admin/main
	 */
	@GetMapping("/main")
	public String adminMainPage(HttpSession session, Model model) {

		// 1. 관리자 권한 세션 체크 (필요시 활성화)
		/*
		 * String role = (String) session.getAttribute("role"); if (role == null ||
		 * !role.contains("ROLE_ADMIN")) { return "redirect:/login"; }
		 */

		// 2. 대시보드 상단 요약 통계 데이터 조회
		int totalAgentCount = adminService.getTotalAgentCount(); // 전체 요원 수
		int onDutyCount = adminService.getOnDutyAgentCount(); // 근무중 요원 수
		int breakCount = adminService.getBreakAgentCount(); // 휴식/외출 요원 수
		int offDutyCount = adminService.getOffDutyAgentCount(); // 퇴근 요원 수

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

	/**
	 * 관제구역 관리 페이지 이동 RequestMapping: GET /admin/areaManagement
	 */
	@GetMapping("/areaManagement")
	public String areaManagementPage(HttpSession session, Model model) {

	    // 초기 관제구역 목록 조회 (필요시 서비스 연결)
	    // List<AreaDTO> areaList = adminService.getAreaList();
	    // model.addAttribute("areaList", areaList);

	    // 1. 메인 레이아웃에 들어갈 본문 contentPage 지정
	    model.addAttribute("contentPage", "/WEB-INF/views/admin/areaManagement.jsp");

	    // 2. 메인 레이아웃 JSP 리턴
	    return "layout/mainLayout"; // 사용중이신 메인 레이아웃 경로
	}

	@GetMapping("/userManagement")
	public String userManagementPage(HttpSession session, Model model) {
		// 본문 JSP 경로 지정
	    model.addAttribute("contentPage", "/WEB-INF/views/admin/userManagement.jsp");
	    
	    return "layout/mainLayout"; // WEB-INF/views/admin/userManagement.jsp
	}

	/**
	 * 전체 안전요원 목록 AJAX 조회 (JSON)
	 */
	@GetMapping("/api/agents")
	@ResponseBody
	public ResponseEntity<List<UserDTO>> getAgentList() {
		List<UserDTO> list = userService.getAgentList();
		return ResponseEntity.ok(list);
	}

	/**
	 * 신규 안전요원 등록 REST API
	 */
	@PostMapping("/api/agents")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> registerAgent(@RequestBody UserDTO userDto) {
		Map<String, Object> response = new HashMap<>();
		boolean result = userService.registerAgent(userDto);
		response.put("success", result);
		return ResponseEntity.ok(response);
	}

	/**
	 * 안전요원 정보 수정 REST API
	 */
	@PutMapping("/api/agents")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateAgent(@RequestBody UserDTO userDto) {
		Map<String, Object> response = new HashMap<>();
		boolean result = userService.modifyAgent(userDto);
		response.put("success", result);
		return ResponseEntity.ok(response);
	}

	/*
	 * ========================================== [참고] 향후 카카오맵 좌표 및 구역 CRUD 처리를 위한
	 * REST API 예시 (필요 시 주석 제거 및 DTO/Service 연동)
	 * ==========================================
	 */

	/*
	 * // 1. 관제구역 목록 AJAX 조회 (JSON)
	 * 
	 * @GetMapping("/api/areas")
	 * 
	 * @ResponseBody public ResponseEntity<List<AreaDTO>> getAreaList() {
	 * List<AreaDTO> list = adminService.getAreaList(); return
	 * ResponseEntity.ok(list); }
	 * 
	 * // 2. 관제구역 저장/수정 (JSON 좌표 데이터 수신)
	 * 
	 * @PostMapping("/api/areas/save")
	 * 
	 * @ResponseBody public ResponseEntity<Map<String, Object>>
	 * saveArea(@RequestBody AreaDTO areaDto) { Map<String, Object> response = new
	 * HashMap<>(); boolean isSuccess = adminService.saveArea(areaDto);
	 * 
	 * response.put("success", isSuccess); response.put("message", isSuccess ?
	 * "구역이 성공적으로 저장되었습니다." : "저장에 실패했습니다.");
	 * 
	 * return ResponseEntity.ok(response); }
	 * 
	 * // 3. 관제구역 삭제
	 * 
	 * @DeleteMapping("/api/areas/{areaId}")
	 * 
	 * @ResponseBody public ResponseEntity<Map<String, Object>>
	 * deleteArea(@PathVariable("areaId") Long areaId) { Map<String, Object>
	 * response = new HashMap<>(); boolean isSuccess =
	 * adminService.deleteArea(areaId);
	 * 
	 * response.put("success", isSuccess); return ResponseEntity.ok(response); }
	 */

}