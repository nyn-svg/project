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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.ChecklistItemDTO;
import com.spring.dto.DroneDTO;
import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.service.ChecklistService;
import com.spring.service.DroneService;
import com.spring.service.SseService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ControlController {
	
	@Autowired
	private DroneService droneService;
	
	@Autowired
	private ChecklistService checklistService;
	
	@Autowired
    private SseService sseService; // 2. SseService 자동 주입

    // 1. 메인 첫 진입
    @GetMapping("/control/main")
    public String index(Model model) {
        model.addAttribute("contentPage", "/WEB-INF/views/control/controlMainContent.jsp");
        return "control/controlMain";
    }
    
    // 실시간 감지 페이지 이동
    @GetMapping("/control/realtime")
    public String realtimePage(Model model) {
    	
    	model.addAttribute("contentPage", "/WEB-INF/views/control/realtime.jsp");
    	model.addAttribute("currentMenu", "realtime");
        return "control/controlMain"; 
    }

    // 2. 드론 관제 화면
    @GetMapping("/control/stream")
    public String droneStream(@RequestParam(value = "id", required = false) String droneId,
    						  @RequestParam(value = "zone", required = false) String zoneName, HttpServletRequest request, Model model) {

        model.addAttribute("droneId", droneId);
        model.addAttribute("zoneName", zoneName);
        
        DroneDTO drone = droneService.getDroneById(droneId);
    	model.addAttribute("drone", drone);

        String viewPath = "/WEB-INF/views/control/stream.jsp";

        // AJAX 비동기 요청 시 JSP 조각만 응답
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            return "control/stream";
        }

        // 새로고침/직접접속 시 전체 껍데기 + 요청한 페이지 경로 전달
        model.addAttribute("contentPage", viewPath);
        return "control/controlMain";
    }
    
    // 위험 감지 관리 페이지 이동
    @GetMapping("/detection")
    public String detectionStatusPage(Model model) {
        
        // 메인 레이아웃(main.jsp)의 <jsp:include page="${contentPage}" /> 에 주입될 경로
        model.addAttribute("contentPage", "/WEB-INF/views/detection/detection-status.jsp");
        
        // 상단 헤더 메뉴 active 처리를 위한 구분값 (필요 시 활용)
        model.addAttribute("currentMenu", "detection");

        // 메인 레이아웃 JSP 파일명을 리턴 (예: main, index, layout 등 프로젝트 설정명에 맞게 지정)
        return "control/controlMain"; 
    }
    
 // 관제사 체크리스트 목록 AJAX 조회 API
    @GetMapping("/control/checklist/api/list")
    @ResponseBody
    public List<ChecklistItemDTO> getControlChecklist() {
        // DB에서 TARGET_TYPE = 'CONTROL'인 항목 10개를 가져옵니다.
        return checklistService.getItemsByTarget("CONTROL");
    }
    
 // 관제사 체크리스트 결과 저장 API
    @PostMapping("/control/checklist/api/submit")
    @ResponseBody
    public Map<String, Object> submitControlChecklist(@RequestBody SafetyCheckMasterDTO masterDTO, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 로그인 사용자 확인
            String inspector = (String) session.getAttribute("userId");
            if (inspector == null || inspector.isEmpty()) {
                inspector = "control";
            }
            masterDTO.setInspector(inspector);

            // DB 저장이 성공했는지 확인
            boolean isSuccess = checklistService.insertSafetyCheck(masterDTO);

            if (isSuccess) {
                // 3. DB 저장 성공 즉시 실시간 SSE 이벤트 알림 전송 🚀
                sseService.sendEvent("CHECKLIST_SUBMITTED", "NEW_CHECKLIST");

                result.put("success", true);
                result.put("message", "체크리스트가 성공적으로 저장되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "저장 처리에 실패했습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        }

        return result;
    }
}