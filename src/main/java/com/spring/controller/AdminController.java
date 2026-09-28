package com.spring.controller; // 프로젝트 패키지 경로에 맞게 수정

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.spring.dto.UserDTO; // 프로젝트 DTO 경로에 맞게 수정
import com.spring.service.AdminService; // 관리자 전용 Service (또는 AgentTaskService)
import com.spring.service.SseService;
import com.spring.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private AdminService adminService; // 관리자 전용 서비스 DI

	@Autowired
	private UserService userService; // 사용자/안전요원 관리 서비스 DI
	
	@Autowired
	private SseService sseService;

	/**
	 * 관리자 메인 대시보드 페이지 이동 RequestMapping: GET /admin/main
	 */
	@GetMapping("/main")
	public String adminMainPage(HttpSession session, Model model) {

	    // 1. KPI 4종 DB 데이터 조회
	    int uncheckedRiskCount = adminService.getUncheckedRiskCount();     // 미확인 위험 이력
	    int unreadEmergencyCount = adminService.getUnreadEmergencyCount(); // 미확인 긴급보고
	    int onDutyCount = adminService.getOnDutyAgentCount();              // 근무중 안전요원
	    int flyingDroneCount = adminService.getFlyingDroneCount();          // 비행중 드론

	    // 2. Model 객체에 저장
	    model.addAttribute("uncheckedRiskCount", uncheckedRiskCount);
	    model.addAttribute("unreadEmergencyCount", unreadEmergencyCount);
	    model.addAttribute("onDutyCount", onDutyCount);
	    model.addAttribute("flyingDroneCount", flyingDroneCount);

	    return "admin/adminMain";
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
	 * 전체 사용자 목록 AJAX 조회 (JSON)
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
	    
	    if (result) {
	        // 수정 및 비활성화 성공 시 SSE 실시간 이벤트 전송
	        sseService.sendEvent("AGENT_STATUS_CHANGE", userDto);
	    }
	    
	    response.put("success", result);
	    return ResponseEntity.ok(response);
	}
	
	@GetMapping("/checklist")
	public String checklistManagementPage(HttpSession session, Model model) {
	    // 본문 JSP 경로 지정
	    model.addAttribute("contentPage", "/WEB-INF/views/admin/checklistManagement.jsp");
	    
	    return "layout/mainLayout";
	}
	
	@GetMapping("/fieldAction")
	public String fieldActionPage(HttpSession session, Model model) {
	    // 현장 조치 전용 본문 JSP 경로 지정
	    model.addAttribute("contentPage", "/WEB-INF/views/admin/fieldAction.jsp");
	    
	    return "layout/mainLayout";
	}
	
	
	@RestController
	@RequestMapping("/admin/api/logs")
	public class AdminLogStreamController {

	    // 연결된 클라이언트(관리자 화면) 스레드 세이프 리스트
	    private static final List<SseEmitter> emitters = new CopyOnWriteArrayList<>();

	    /**
	     * 실시간 터미널 로그 SSE 구독 연결
	     */
	    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	    public SseEmitter subscribeTerminalLog() {
	        // 타임아웃 30분 설정
	        SseEmitter emitter = new SseEmitter(30 * 60 * 1000L);
	        emitters.add(emitter);

	        // 연결 해제 및 타임아웃 처리
	        emitter.onCompletion(() -> emitters.remove(emitter));
	        emitter.onTimeout(() -> emitters.remove(emitter));
	        emitter.onError((e) -> emitters.remove(emitter));

	        // 최초 연결 시 환영 메시지 전송
	        try {
	            Map<String, String> initData = new HashMap<>();
	            initData.put("type", "INFO");
	            initData.put("message", "실시간 관제 데이터 스트리밍 파이프라인 연결 완료");
	            emitter.send(SseEmitter.event().name("log").data(initData));
	        } catch (IOException e) {
	            emitters.remove(emitter);
	        }

	        return emitter;
	    }

	    /**
	     * 시스템 전역에서 호출하여 실시간 관제 로그를 관리자 화면으로 푸시하는 정적/서비스 메서드
	     * 예: AdminLogStreamController.broadcastLog("WARN", "C구역 밀집도 초과 감지");
	     */
	    public static void broadcastLog(String type, String message) {
	        Map<String, String> logData = new HashMap<>();
	        logData.put("type", type);     // INFO, WARN, DANGER, ACTION
	        logData.put("message", message);

	        for (SseEmitter emitter : emitters) {
	            try {
	                emitter.send(SseEmitter.event().name("log").data(logData));
	            } catch (IOException e) {
	                emitters.remove(emitter);
	            }
	        }
	    }
	}


}