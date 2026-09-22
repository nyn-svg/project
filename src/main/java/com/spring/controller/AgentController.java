package com.spring.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
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
	@Value("${savedPath.upload.files}") // 이미지 경로
	private String uploadPath;

	/* 공통 로직: 세션에서 로그인된 사용자 ID 추출 (없으면 기본값 "agent01") */
	private String getLoginUserId(HttpSession session) {
		String loginUserId = (String) session.getAttribute("userId");
		return (loginUserId != null) ? loginUserId : "agent01";
	}

	/* ==========[공통 알림]============= */
	@GetMapping(value = "/sse/connect", produces = "text/event-stream")
	@ResponseBody
	public SseEmitter connectSse() {
		return sseService.subscribe();
	}

	@PostMapping("/situation/accept")
	@ResponseBody
	public Map<String, Object> acceptSituation(@RequestParam("situNo") String situNo, HttpSession session) {
		Map<String, Object> resultMap = new HashMap<>();
		try {
			SituationDTO situation = situationService.getSituationBySituNo(situNo);
			if (situation != null) {
				situation.setSituStatus("조치");
				situation.setWorker(getLoginUserId(session));

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
		AgentDTO user = agentService.getAgentInfo(getLoginUserId(session));
		model.addAttribute("user", user);
		return "agent/agentMain";
	}

	// 근무 상태 변경 페이지
	@GetMapping("/status/edit")
	public String agentStatusEditPage(HttpSession session, Model model) {
		AgentDTO user = agentService.getAgentInfo(getLoginUserId(session));
		model.addAttribute("user", user);
		return "agent/agentStatusEdit";
	}

	// 근무 상태 변경
	@PostMapping("/status/edit")
	public String updateWorkStatus(@RequestParam("workStatus") String workStatus, HttpSession session) {
		agentService.changeAgentStatus(getLoginUserId(session), workStatus);
		return "redirect:/agent/main";
	}

	// 알림 보관함
	@GetMapping("/report")
	public String agentReportPage() {
		return "agent/agentReport";
	}

	// 비상연락망
	@GetMapping("/emergency-contacts")
	@ResponseBody
	public List<EmergencyContactDTO> getEmergencyContacts() {
		return emergencyContactService.getContactList();
	}

	// 긴급 보고
	@GetMapping("/emergency")
	public String agentEmergencyPage(@RequestParam(value = "situNo", required = false) String situNo,
			HttpSession session, Model model) {

		AgentDTO user = agentService.getAgentInfo(getLoginUserId(session));
		model.addAttribute("user", user);

		if (situNo != null && !situNo.trim().isEmpty()) {
			SituationDTO situation = situationService.getSituationBySituNo(situNo);
			model.addAttribute("situation", situation);
			model.addAttribute("isEdit", true);
		} else {
			model.addAttribute("isEdit", false);
		}

		return "agent/agentEmergency";
	}

	// 보고 등록 완료 페이지
	@GetMapping("/report/complete")
	public String agentReportCompletePage() {
		return "agent/agentReportComplete";
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/login";
	}

	/* ==========[안전순찰 페이지]============= */
	@GetMapping("/patrol")
	public String agentInfoPage(HttpSession session, Model model) {
		UserDTO user = agentService.findByUserId(getLoginUserId(session));
		model.addAttribute("user", user);

		List<Map<String, Object>> todayList = checklistService.getTodayPatrolByArea(user.getWorkArea());
		model.addAttribute("todayList", todayList);

		return "agent/agentPatrol";
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
			masterDTO.setInspector(getLoginUserId(session));

			int normalCount = 0;
			int warnCount = 0;

			if (masterDTO.getDetailList() != null) {
				for (SafetyCheckDetailDTO detail : masterDTO.getDetailList()) {
					String status = detail.getStatusCode();
					
					if ("정상".equals(status) || "NORMAL".equals(status)) {
						normalCount++;
					} else if ("주의".equals(status) || "WARN".equals(status) || "위험".equals(status) || "DANGER".equals(status)) {
						warnCount++;
					}
				}
			}

			int totalCount = normalCount + warnCount;
			checklistService.insertSafetyCheck(masterDTO);

			// 관제/관리자 화면으로 이벤트 전송
			sseService.sendEvent("CHECKLIST_SUBMITTED", "NEW_CHECKLIST");

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

	// 사전점검 완료 화면 이동
	@GetMapping("/safetyCheck/complete")
	public String agentSafetyCheckCompletePage(HttpSession session, Model model) {
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

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		paramMap.put("actionStatus", actionStatus);
		paramMap.put("userId", getLoginUserId(session));

		List<SituationDTO> taskList = situationService.getTaskListPaged(paramMap);
		int totalCount = situationService.getTaskListCount(paramMap);

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("tasks", taskList);
		resultMap.put("totalCount", totalCount);

		return resultMap;
	}

	@GetMapping("/history")
	public String agentHistoryPage(Model model) {
		return "agent/agentHistory";
	}

	@GetMapping("/taskEdit")
	public String agentTaskEditPage(@RequestParam("situNo") String situNo, Model model) {
		SituationDTO situation = situationService.getSituationBySituNo(situNo);
		model.addAttribute("task", situation);

		SimpleDateFormat cstSdf = new SimpleDateFormat("yyyy-MM-dd a hh:mm");

		if (situation != null && situation.getStartDate() != null) {
			model.addAttribute("customStartDate", cstSdf.format(situation.getStartDate()));
		} else {
			model.addAttribute("customStartDate", "기록 없음");
		}

		return "agent/agentTaskEdit";
	}

	// 조치 보고 수정
	@PostMapping("/taskEdit")
	public String modifyTask(@ModelAttribute SituationDTO dto, @RequestParam("situStatus") String situStatus,
			@RequestParam(value = "endDate", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date endDate,
			@RequestParam(value = "photo", required = false) org.springframework.web.multipart.MultipartFile photo, // ✨
																													// 파일
																													// 파라미터
																													// 추가
			HttpSession session) {
		try {
			dto.setWorker(getLoginUserId(session));
			dto.setEndDate(endDate);

			// ====== 📸 3번째 이미지의 파일 업로드 처리 로직 이식 =====
			if (photo != null && !photo.isEmpty()) {
				File uploadDir = new File(uploadPath);
				if (!uploadDir.exists()) {
					uploadDir.mkdirs(); // 폴더가 없으면 생성
				}

				// 파일명 중복 방지를 위한 UUID 파일명 생성
				String originalFilename = photo.getOriginalFilename();
				String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;

				// 서버 디렉토리에 파일 저장
				File destFile = new File(uploadPath, savedFilename);
				photo.transferTo(destFile);

				// DTO에 저장된 파일명 세팅 (안전요원은 조치사진이므로 workImage에 세팅)
				dto.setWorkImage(savedFilename);
			} else {
				// 사진이 첨부되지 않았다면 기존 이미지 유지 또는 빈값 처리
				dto.setWorkImage("");
			}
			// ========================================================

			if ("조치완료".equals(situStatus) || "미조치 종결".equals(situStatus)) {
				dto.setSituStatus("조치완료");
				situationService.modifySituation(dto);
				situationService.setEnd(dto.getSituNo());
			} else {

				dto.setSituStatus("조치");
				situationService.modifySituation(dto);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "redirect:/agent/history";
	}
}