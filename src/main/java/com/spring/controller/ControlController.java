package com.spring.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.spring.dto.ChecklistItemDTO;
import com.spring.dto.DetectRequestDTO;
import com.spring.dto.DroneDTO;
import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.dto.SituationDTO;
import com.spring.service.AnimalStateService;
import com.spring.service.ChecklistService;
import com.spring.service.DensityStateService;
import com.spring.service.DroneService;
import com.spring.service.SituationService;
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
	private DensityStateService densityStateService;
	
	@Autowired
	private AnimalStateService animalStateService;

	@Autowired
	private SituationService situationService;
	
	@Autowired
    private SseService sseService; // 2. SseService 자동 주입
	
	@Value("${savedPath.upload.files}")
    private String uploadPath;

    // 1. (구)메인 진입
    @GetMapping("/control/main")
    public String index(Model model) {
        model.addAttribute("contentPage", "/WEB-INF/views/control/controlMainContent.jsp");
        return "control/controlMain";
    }
    
    // 실시간 감지 페이지 이동 (첫 페이지)
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
    
    @PostMapping("/api/sse/stream")
    @ResponseBody // 화면(JSP) 이동이 아닌 데이터 응답
    public ResponseEntity<String> receiveStreamData(@RequestBody DetectRequestDTO requestData) {
    	String droneId = requestData.getDroneId();
        double density = requestData.getDensity();
        
        // 1. 화면(stream.jsp)으로 실시간 데이터 브로드캐스팅
        sseService.sendEvent("stream-data", requestData);
        
        // 2. 밀집도 위험 단계와 5초 지속 판별 및 자동 등록
        String densityDngrLevel = densityStateService.checkDensityAutoRegist(droneId, density);
        if (densityDngrLevel != null) {
            SituationDTO situation = new SituationDTO();
            situation.setDroneId(droneId);
            
            // 드론 정보에서 zoneName 조회 후 세팅
            DroneDTO drone = droneService.getDroneById(droneId);
            if (drone != null) {
            	situation.setZoneName(drone.getZoneName());
            } else {
            	situation.setZoneName("인식불가");
            }

            situation.setSituType("자동감지");
            situation.setDngrType("인파위험");
            situation.setDngrLevel(densityDngrLevel);
            situation.setSituStatus("감지");
            
            String content = String.format(
            		"해당 구역에서 밀집도 약 %.1f%% [%s]가 지속 감지되었습니다.%n" +
            	    "현장을 확인하시고 사전 가이드라인에 준수하여 조치해 주시기 바랍니다.%n" +
            	    "(본 이력은 자동 생성되어 사실과 다를 수 있습니다.)", 
            	    density, densityDngrLevel);
            situation.setSituContent(content);
            
            // 💡 스냅샷 이미지 파일로 저장 후 DTO 세팅
            String savedImageName = requestSnapshot(droneId);
            situation.setSituImage(savedImageName);

            // DB 등록 및 SSE 자동 발송
            if (situationService.registerSituation(situation)) {
                SituationController.clearSituationCache();
            }
        }
        
        // 3. 야생동물 위험 단계 판별 및 자동 등록
        boolean hasValidAnimal = requestData.isAnimal() // requestData.isAnimal()의 유효성 검증
        					  && requestData.getAnimals() != null 
        					  && !requestData.getAnimals().isEmpty(); // requestData.getAnimals()의 유효성 검증
        
        if (animalStateService.checkAnimalAutoRegist(droneId, hasValidAnimal)) {
            String animalDngrLevel = animalStateService.checkAnimalDngrLevel(droneId, true);
            String animalName = animalStateService.getAnimalName(requestData.getAnimals());
            
            SituationDTO situation = new SituationDTO();
            situation.setDroneId(droneId);
            
            DroneDTO drone = droneService.getDroneById(droneId);
            if (drone != null) {
            	situation.setZoneName(drone.getZoneName());
            } else {
            	situation.setZoneName("인식불가");
            }

            situation.setSituType("자동감지");
            situation.setDngrType("야생동물");
            situation.setDngrLevel(animalDngrLevel);
            situation.setSituStatus("감지");
            
            // 💡 스냅샷 이미지 파일로 저장 후 DTO 세팅
            String savedImageName = requestSnapshot(droneId);
            situation.setSituImage(savedImageName);
            
            String content = String.format(
            		"해당 구역에서 야생동물 [%s]가 감지되었습니다.%n" +
            	    "현장을 확인하시고 사전 가이드라인에 준수하여 조치해 주시기 바랍니다.%n" +
            	    "(본 이력은 자동 생성되어 사실과 다를 수 있습니다.)", 
            	    animalName);
            situation.setSituContent(content);

            if (situationService.registerSituation(situation)) {
                SituationController.clearSituationCache();
            }
        }
        
        return ResponseEntity.ok("Data received successfully from " + droneId);
    }
    
    // 💡 Spring에서 Flask로 스냅샷 이미지를 요청하는 헬퍼 메소드
    private String requestSnapshot(String droneId) {
        try {
        	// 1. DB에서 드론 정보 조회
            DroneDTO drone = droneService.getDroneById(droneId);
            if (drone == null || drone.getUrl() == null || drone.getUrl().trim().isEmpty()) {
                System.err.println("[" + droneId + "] 드론의 스트리밍 URL 정보가 없습니다.");
                return null;
            }
            
            // 2. drone.getUrl() (예: http://localhost:5001/stream/video_feed) 뒤에 /api/snapshot 붙여서 요청 주소 생성
            String flaskUrl = drone.getUrl().trim() + "/api/snapshot";
            
            // 3. RestTemplate 호출로 Flask 서버로부터 Base64 이미지 문자열 응답 받기
            RestTemplate restTemplate = new RestTemplate();
            String base64Image = restTemplate.getForObject(flaskUrl, String.class);
            
            // 받아온 Base64를 저장소에 저장 후 저장된 파일명 반환
            return saveBase64Image(base64Image);
            
        } catch (Exception e) {
            System.err.println("[" + droneId + "] Flask 스냅샷 요청 실패: " + e.getMessage());
            return null; // 실패 시 이미지 없이 등록 처리
        }
    }
    
    // 💡 Base64 문자열을 파일로 디코딩하여 저장하는 헬퍼 메서드
    private String saveBase64Image(String base64Str) {
        if (base64Str == null || base64Str.trim().isEmpty()) {
            return null;
        }

        try {
            // "data:image/jpeg;base64," 헤더 제거
            if (base64Str.contains(",")) {
                base64Str = base64Str.split(",")[1];
            }

            byte[] imageBytes = Base64.getDecoder().decode(base64Str);

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String savedFilename = UUID.randomUUID().toString() + "_auto_snapshot.jpg";
            File destFile = new File(uploadPath, savedFilename);

            try (FileOutputStream fos = new FileOutputStream(destFile)) {
                fos.write(imageBytes);
            }

            return savedFilename;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
	// 메모리 전용 자동신고 로그 리스트
 	private static final List<Map<String, Object>> autoReportList = Collections.synchronizedList(new ArrayList<>());

 	public static List<Map<String, Object>> getAutoReportList() {
 	    return autoReportList;
 	}
 	
 	// 자동신고 메모리 리스트 조회 API
 	@GetMapping("/api/auto-report/list")
 	@ResponseBody
 	public List<Map<String, Object>> getAutoReportApiList() {
 	    return autoReportList;
 	}

 	// 자동신고 메모리 로그 삭제 API
 	@PostMapping("/api/auto-report/delete")
 	@ResponseBody
 	public ResponseEntity<String> deleteAutoReportLog(@RequestParam("id") String id) {
 	    autoReportList.removeIf(item -> id.equals(item.get("id")));
 	    return ResponseEntity.ok("SUCCESS");
 	}
 	
 	// 오감지 처리
 	@PostMapping("/api/misdetect")
 	@ResponseBody
 	public ResponseEntity<Map<String, Object>> misdetect(@RequestParam(value="droneId", required=false) String droneId) {
 	    Map<String, Object> result = new HashMap<>();
 	    boolean success = situationService.handleMisdetection(droneId);
 	    
 	    if(success) {
 	    	SituationController.clearSituationCache();
 	    }
 	    
 	    result.put("success", success);
 	    result.put("message", success ? "오감지 처리가 완료되었습니다." : "처리할 자동감지 이력이 없습니다.");
 	    
 	    return ResponseEntity.ok(result);
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