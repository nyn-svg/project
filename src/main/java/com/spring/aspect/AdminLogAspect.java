package com.spring.aspect;

import java.util.List;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.spring.annotation.AdminLog;
import com.spring.dto.DroneDTO;
import com.spring.dto.EmergencyContactDTO;
import com.spring.dto.SafetyCheckMasterDTO;
import com.spring.dto.SituationDTO;
import com.spring.dto.UserDTO;
import com.spring.mapper.DroneMapper;
import com.spring.mapper.EmergencyContactMapper;
import com.spring.mapper.SituationMapper;
import com.spring.mapper.UserMapper;
import com.spring.service.SseService;

@Aspect
@Component
public class AdminLogAspect {
	
	@Autowired
	private SituationMapper situationMapper;

    @Autowired
    private SseService sseService;

    @Autowired
    private DroneMapper droneMapper;

    @Autowired
    private EmergencyContactMapper emergencyContactMapper;
    
    @Autowired
    private UserMapper userMapper;

    /* =========================================================================
     * 1. 드론 정보 수정 전/후 비교
     * ========================================================================= */
    @Around("@annotation(adminLog) && execution(* com.spring.service.DroneServiceImpl.modifyDrone(..))")
    public Object logDroneUpdate(ProceedingJoinPoint pjp, AdminLog adminLog) throws Throwable {
        Object[] args = pjp.getArgs();
        DroneDTO oldDrone = null;
        DroneDTO newDrone = null;

        if (args != null && args.length > 0 && args[0] instanceof DroneDTO) {
            newDrone = (DroneDTO) args[0];
            try {
                oldDrone = droneMapper.findByDroneId(newDrone.getDroneId());
            } catch (Exception e) {}
        }

        Object result = pjp.proceed();

        if (result instanceof Boolean && (Boolean) result && oldDrone != null && newDrone != null) {
            StringBuilder changes = new StringBuilder();

            if (newDrone.getDroneStatus() != null && !newDrone.getDroneStatus().equals(oldDrone.getDroneStatus())) {
                changes.append("비행상태 [").append(oldDrone.getDroneStatus()).append("] ➔ [").append(newDrone.getDroneStatus()).append("] ");
            }
            if (newDrone.getActiveStatus() != null && !newDrone.getActiveStatus().equals(oldDrone.getActiveStatus())) {
                changes.append("활성상태 [").append(oldDrone.getActiveStatus()).append("] ➔ [").append(newDrone.getActiveStatus()).append("] ");
            }
            if (newDrone.getZoneName() != null && !newDrone.getZoneName().equals(oldDrone.getZoneName())) {
                changes.append("구역 [").append(oldDrone.getZoneName()).append("] ➔ [").append(newDrone.getZoneName()).append("] ");
            }

            String logMessage = (changes.length() > 0) 
                    ? "드론(" + newDrone.getDroneId() + ") " + changes.toString().trim() + " 변경되었습니다."
                    : "드론(" + newDrone.getDroneId() + ") 상세 정보가 수정되었습니다.";

            sseService.sendTerminalLog(adminLog.type(), logMessage);
        }

        return result;
    }

    /* =========================================================================
     * 2. 🎯 [비상연락망 수정 전/후 비교] EmergencyContactDTO 적용
     * ========================================================================= */
    @Around("@annotation(adminLog) && execution(* com.spring.service.EmergencyContactServiceImpl.modifyContact(..))")
    public Object logContactUpdate(ProceedingJoinPoint pjp, AdminLog adminLog) throws Throwable {
        Object[] args = pjp.getArgs();
        EmergencyContactDTO oldContact = null;
        EmergencyContactDTO newContact = null;

        if (args != null && args.length > 0 && args[0] instanceof EmergencyContactDTO) {
            newContact = (EmergencyContactDTO) args[0];
            try {
                List<EmergencyContactDTO> list = emergencyContactMapper.selectContactList();
                for (EmergencyContactDTO item : list) {
                    if (item.getContactId() != null && item.getContactId().equals(newContact.getContactId())) {
                        oldContact = item;
                        break;
                    }
                }
            } catch (Exception e) {}
        }

        Object result = pjp.proceed();

        if (result instanceof Boolean && (Boolean) result && newContact != null) {
            StringBuilder changes = new StringBuilder();

            if (oldContact != null) {
                // 🎯 EmergencyContactDTO 필드 비교 (category, title, phone, sortOrder)
                if (newContact.getCategory() != null && !newContact.getCategory().equals(oldContact.getCategory())) {
                    changes.append("분류 [").append(oldContact.getCategory()).append("] ➔ [").append(newContact.getCategory()).append("] ");
                }
                if (newContact.getTitle() != null && !newContact.getTitle().equals(oldContact.getTitle())) {
                    changes.append("항목명 [").append(oldContact.getTitle()).append("] ➔ [").append(newContact.getTitle()).append("] ");
                }
                if (newContact.getPhone() != null && !newContact.getPhone().equals(oldContact.getPhone())) {
                    changes.append("연락처 [").append(oldContact.getPhone()).append("] ➔ [").append(newContact.getPhone()).append("] ");
                }
                if (newContact.getSortOrder() != null && !newContact.getSortOrder().equals(oldContact.getSortOrder())) {
                    changes.append("정렬순서 [").append(oldContact.getSortOrder()).append("] ➔ [").append(newContact.getSortOrder()).append("] ");
                }
            }

            String targetTitle = (newContact.getTitle() != null) ? newContact.getTitle() : "비상연락망";
            String logMessage = (changes.length() > 0)
                    ? "비상연락망(" + targetTitle + ") " + changes.toString().trim() + " 변경되었습니다."
                    : "비상연락망(" + targetTitle + ") 정보가 수정되었습니다.";

            sseService.sendTerminalLog(adminLog.type(), logMessage);
        }

        return result;
    }
    
    /* =========================================================================
     * 🎯 [비상연락망 삭제 전 정보 조회 및 로그 처리]
     * ========================================================================= */
    @Around("@annotation(adminLog) && execution(* com.spring.service.EmergencyContactServiceImpl.removeContact(..))")
    public Object logContactRemove(ProceedingJoinPoint pjp, AdminLog adminLog) throws Throwable {
        Object[] args = pjp.getArgs();
        EmergencyContactDTO targetContact = null;

        // 1. 삭제 실행 전: 삭제될 데이터 미리 조회
        if (args != null && args.length > 0 && args[0] instanceof Long) {
            Long contactId = (Long) args[0];
            try {
                List<EmergencyContactDTO> list = emergencyContactMapper.selectContactList();
                for (EmergencyContactDTO item : list) {
                    if (item.getContactId() != null && item.getContactId().equals(contactId)) {
                        targetContact = item;
                        break;
                    }
                }
            } catch (Exception e) {}
        }

        // 2. 실제 DB 삭제 실행 (removeContact)
        Object result = pjp.proceed();

        // 3. 삭제 성공 시 상세 정보와 함께 SSE 로그 발송
        if (result instanceof Boolean && (Boolean) result) {
            String logMessage;
            if (targetContact != null) {
                String title = (targetContact.getTitle() != null) ? targetContact.getTitle() : "미상";
                String phone = (targetContact.getPhone() != null) ? targetContact.getPhone() : "";
                logMessage = "비상연락망 [" + title + " / " + phone + "] 항목이 삭제되었습니다.";
            } else {
                logMessage = "비상연락망(NO." + args[0] + ") 항목이 삭제되었습니다.";
            }

            sseService.sendTerminalLog(adminLog.type(), logMessage);
        }

        return result;
    }
    
    /* =========================================================================
     * 🎯 [상황 삭제 전 정보 조회 및 로그 처리]
     * ========================================================================= */
    @Around("@annotation(adminLog) && execution(* com.spring.service.SituationServiceImpl.removeSituation(..))")
    public Object logSituationRemove(ProceedingJoinPoint pjp, AdminLog adminLog) throws Throwable {
        Object[] args = pjp.getArgs();
        SituationDTO targetSitu = null;

        // 1. 삭제 실행 전: DB에서 삭제될 상황 정보 미리 조회
        if (args != null && args.length > 0 && args[0] != null) {
            String situNo = String.valueOf(args[0]);
            try {
                targetSitu = situationMapper.findBySituNo(situNo);
            } catch (Exception e) {}
        }

        // 2. 실제 DB 삭제 실행
        Object result = pjp.proceed();

        // 3. 삭제 성공 시 위험유형을 포함하여 SSE 로그 발송
        if (result instanceof Boolean && (Boolean) result) {
            String logMessage;
            if (targetSitu != null) {
                String dngrType = (targetSitu.getDngrType() != null) ? targetSitu.getDngrType() : "상황";
                logMessage = "상황[" + dngrType + "](NO." + targetSitu.getSituNo() + ") 정보가 삭제되었습니다.";
            } else {
                logMessage = "상황(NO." + args[0] + ") 정보가 삭제되었습니다.";
            }

            sseService.sendTerminalLog(adminLog.type(), logMessage);
        }

        return result;
    }
    
    /* =========================================================================
     * 🎯 [요원 정보 수정 전/후 비교] UserDTO 필드 전체 세부 비교
     * ========================================================================= */
    @Around("@annotation(adminLog) && execution(* com.spring.service.UserServiceImpl.modifyAgent(..))")
    public Object logAgentUpdate(ProceedingJoinPoint pjp, AdminLog adminLog) throws Throwable {
        Object[] args = pjp.getArgs();
        UserDTO oldUser = null;
        UserDTO newUser = null;

        if (args != null && args.length > 0 && args[0] instanceof UserDTO) {
            newUser = (UserDTO) args[0];
            try {
                List<UserDTO> list = userMapper.findAllUsers();
                for (UserDTO u : list) {
                    if (u.getUserId() != null && u.getUserId().equals(newUser.getUserId())) {
                        oldUser = u;
                        break;
                    }
                }
            } catch (Exception e) {}
        }

        Object result = pjp.proceed();

        if (result instanceof Boolean && (Boolean) result && newUser != null) {
            StringBuilder changes = new StringBuilder();

            if (oldUser != null) {
                // 🎯 UserDTO 주요 필드 비교 (이름, 연락처, 이메일, 권한, 근무상태, 담당구역, 근무시간)
                if (newUser.getUserName() != null && !newUser.getUserName().equals(oldUser.getUserName())) {
                    changes.append("이름 [").append(oldUser.getUserName()).append("] ➔ [").append(newUser.getUserName()).append("] ");
                }
                if (newUser.getPhone() != null && !newUser.getPhone().equals(oldUser.getPhone())) {
                    changes.append("연락처 [").append(oldUser.getPhone()).append("] ➔ [").append(newUser.getPhone()).append("] ");
                }
                if (newUser.getEmail() != null && !newUser.getEmail().equals(oldUser.getEmail())) {
                    changes.append("이메일 [").append(oldUser.getEmail()).append("] ➔ [").append(newUser.getEmail()).append("] ");
                }
                if (newUser.getRoleName() != null && !newUser.getRoleName().equals(oldUser.getRoleName())) {
                    changes.append("권한 [").append(oldUser.getRoleName()).append("] ➔ [").append(newUser.getRoleName()).append("] ");
                }
                if (newUser.getWorkStatus() != null && !newUser.getWorkStatus().equals(oldUser.getWorkStatus())) {
                    changes.append("근무상태 [").append(oldUser.getWorkStatus()).append("] ➔ [").append(newUser.getWorkStatus()).append("] ");
                }
                if (newUser.getWorkArea() != null && !newUser.getWorkArea().equals(oldUser.getWorkArea())) {
                    changes.append("담당구역 [").append(oldUser.getWorkArea()).append("] ➔ [").append(newUser.getWorkArea()).append("] ");
                }
                if (newUser.getWorkTime() != null && !newUser.getWorkTime().equals(oldUser.getWorkTime())) {
                    changes.append("근무시간 [").append(oldUser.getWorkTime()).append("] ➔ [").append(newUser.getWorkTime()).append("] ");
                }
            }

            String targetId = (newUser.getUserId() != null) ? newUser.getUserId() : "요원";
            String logMessage = (changes.length() > 0)
                    ? "요원(" + targetId + ") " + changes.toString().trim() + " 변경되었습니다."
                    : "요원(" + targetId + ") 상세 정보가 수정되었습니다.";

            sseService.sendTerminalLog(adminLog.type(), logMessage);
        }

        return result;
    }

    /* =========================================================================
     * 🎯 [요원 담당 구역 변경 전/후 비교]
     * ========================================================================= */
    @Around("@annotation(adminLog) && execution(* com.spring.service.UserServiceImpl.updateWorkArea(..))")
    public Object logWorkAreaUpdate(ProceedingJoinPoint pjp, AdminLog adminLog) throws Throwable {
        Object[] args = pjp.getArgs();
        String userId = (args != null && args.length > 0) ? String.valueOf(args[0]) : null;
        String newArea = (args != null && args.length > 1) ? String.valueOf(args[1]) : null;
        UserDTO oldUser = null;

        if (userId != null) {
            try {
                List<UserDTO> list = userMapper.findAllUsers();
                for (UserDTO u : list) {
                    if (userId.equals(u.getUserId())) {
                        oldUser = u;
                        break;
                    }
                }
            } catch (Exception e) {}
        }

        Object result = pjp.proceed();

        if (result instanceof Boolean && (Boolean) result && userId != null && newArea != null) {
            String oldArea = (oldUser != null && oldUser.getWorkArea() != null) ? oldUser.getWorkArea() : "미정";
            String logMessage = "요원(" + userId + ") 담당 구역이 [" + oldArea + "] ➔ [" + newArea + "](으)로 변경되었습니다.";

            // 🎯 type을 "INFO"로 명시하여 파란색 [INFO] 태그로 출력
            sseService.sendTerminalLog("INFO", logMessage);
        }

        return result;
    }

    /* =========================================================================
     * 3. 일반 작업 후처리 (@AfterReturning)
     * ========================================================================= */
    @AfterReturning(value = "@annotation(adminLog)", returning = "result")
    public void logAdminAction(JoinPoint joinPoint, AdminLog adminLog, Object result) {
        String actionName = adminLog.value();
        String logType = adminLog.type();
        
        if ("드론 정보 수정".equals(actionName) || "비상연락망 수정".equals(actionName) 
                || "비상연락망 삭제".equals(actionName) || "상황 삭제".equals(actionName)
                || "요원 정보 수정".equals(actionName) || "요원 담당 구역 변경".equals(actionName)) {
            return;
        }

        Object[] args = joinPoint.getArgs();
        String logMessage = "";
        

        // 1) 요원 근무 상태 변경
        if ("요원 근무 상태 변경".equals(actionName) && args != null && args.length >= 2) {
            String targetUserId = String.valueOf(args[0]);
            String newStatus = String.valueOf(args[1]);
            
            logType = "INFO"; // 👈 이 줄을 추가해 주시면 파란색 [INFO] 태그로 출력됩니다.
            logMessage = "요원(" + targetUserId + ") 근무 상태가 [" + newStatus + "](으)로 변경되었습니다.";
        }
     // 🎯 요원 신규 등록
        else if ("요원 신규 등록".equals(actionName) && args != null && args.length > 0) {
            if (args[0] instanceof UserDTO) {
                UserDTO user = (UserDTO) args[0];
                String userName = (user.getUserName() != null) ? user.getUserName() : "요원";
                logMessage = "신규 요원 [" + userName + "(" + user.getUserId() + ")]이 시스템에 등록되었습니다.";
            } else {
                logMessage = "신규 요원이 등록되었습니다.";
            }
        }
        
        // 2) 사전점검 제출
        else if ("사전점검 제출".equals(actionName) && args != null && args.length > 0) {
            if (args[0] instanceof SafetyCheckMasterDTO) {
                SafetyCheckMasterDTO masterDTO = (SafetyCheckMasterDTO) args[0];
                String inspector = (masterDTO.getInspector() != null) ? masterDTO.getInspector() : "미상";
                logMessage = "점검자(" + inspector + ")의 사전점검 데이터가 정상 제출되었습니다.";
            } else {
                logMessage = "사전점검 데이터가 제출되었습니다.";
            }
        }
        // 3) 드론 신규 등록
        else if ("드론 신규 등록".equals(actionName) && args != null && args.length > 0) {
            if (args[0] instanceof DroneDTO) {
                DroneDTO drone = (DroneDTO) args[0];
                logMessage = "신규 드론(" + drone.getDroneId() + ")이 시스템에 등록되었습니다.";
            } else {
                logMessage = "신규 드론이 등록되었습니다.";
            }
        }
        // 🎯 4) 비상연락망 등록
        else if ("비상연락망 등록".equals(actionName) && args != null && args.length > 0) {
            if (args[0] instanceof EmergencyContactDTO) {
                EmergencyContactDTO contact = (EmergencyContactDTO) args[0];
                String category = (contact.getCategory() != null) ? contact.getCategory() : "일반";
                String title = (contact.getTitle() != null) ? contact.getTitle() : "미상";
                String phone = (contact.getPhone() != null) ? contact.getPhone() : "";
                
                logMessage = "신규 비상연락망 [" + category + " | " + title + " / " + phone + "] 정보가 등록되었습니다.";
            } else {
                logMessage = "새로운 비상연락망 정보가 추가되었습니다.";
            }
        }
        // 5) 비상연락망 삭제
        else if ("비상연락망 삭제".equals(actionName) && args != null && args.length > 0) {
            logMessage = "비상연락망(NO." + args[0] + ") 항목이 삭제되었습니다.";
        }
        
        
     // 🎯 1) 상황 대응 개시
        else if ("상황 대응 개시".equals(actionName) && args != null && args.length > 0) {
            String situNo = String.valueOf(args[0]);
            String dngrTypeStr = "";
            try {
                SituationDTO situ = situationMapper.findBySituNo(situNo);
                if (situ != null && situ.getDngrType() != null) {
                    dngrTypeStr = "[" + situ.getDngrType() + "]";
                }
            } catch (Exception e) {}
            logMessage = "상황" + dngrTypeStr + "(NO." + situNo + ") 대응 조치가 개시되었습니다.";
        }
        // 🎯 2) 상황 대응 종료
        else if ("상황 대응 종료".equals(actionName) && args != null && args.length > 0) {
            String situNo = "";
            String dngrTypeStr = "";
            if (args[0] instanceof SituationDTO) {
                SituationDTO input = (SituationDTO) args[0];
                situNo = input.getSituNo();
                try {
                    SituationDTO situ = situationMapper.findBySituNo(situNo);
                    if (situ != null && situ.getDngrType() != null) {
                        dngrTypeStr = "[" + situ.getDngrType() + "]";
                    }
                } catch (Exception e) {}
            } else {
                situNo = String.valueOf(args[0]);
            }
            logMessage = "상황" + dngrTypeStr + "(NO." + situNo + ") 대응 조치가 종료 처리되었습니다.";
        }
        // 🎯 3) 상황 정보 수정
        else if ("상황 정보 수정".equals(actionName) && args != null && args.length > 0) {
            String situNo = "";
            String dngrTypeStr = "";
            if (args[0] instanceof SituationDTO) {
                SituationDTO situ = (SituationDTO) args[0];
                situNo = situ.getSituNo();
                if (situ.getDngrType() != null) {
                    dngrTypeStr = "[" + situ.getDngrType() + "]";
                } else {
                    try {
                        SituationDTO origin = situationMapper.findBySituNo(situNo);
                        if (origin != null && origin.getDngrType() != null) {
                            dngrTypeStr = "[" + origin.getDngrType() + "]";
                        }
                    } catch (Exception e) {}
                }
            } else {
                situNo = String.valueOf(args[0]);
            }
            logMessage = "상황" + dngrTypeStr + "(NO." + situNo + ") 정보가 수정되었습니다.";
        }
        // 🎯 4) 현장 조치 승인/반려 처리
        else if ("현장 조치 처리".equals(actionName) && args != null && args.length >= 4) {
            String actionId = String.valueOf(args[0]);
            String status = String.valueOf(args[1]);
            String adminId = (args[3] != null) ? String.valueOf(args[3]) : "관리자";
            String statusText = "APPROVE".equals(status) ? "승인" : "반려";
            
            logType = "APPROVE".equals(status) ? "ACTION" : "WARN";

            // 🎯 actionId(상황번호)로 DB에서 실제 감지 내용 및 위험 유형 조회
            String situTitle = "";
            try {
                SituationDTO situ = situationMapper.findBySituNo(actionId);
                if (situ != null) {
                    // 감지내용(situContent)이 있으면 우선 사용 (예: "병목 현상 발생")
                    if (situ.getSituContent() != null && !situ.getSituContent().trim().isEmpty()) {
                        situTitle = situ.getSituContent();
                    } 
                    // 감지내용이 없으면 위험유형(dngrType) 사용 (예: "인파위험")
                    else if (situ.getDngrType() != null) {
                        situTitle = situ.getDngrType();
                    }
                }
            } catch (Exception e) {}

            // DB에서 상황 제목을 가져왔을 경우 상황명 출력, 실패 시 기본 ID 출력
            if (!situTitle.isEmpty()) {
                logMessage = "[" + situTitle + "] 건이 관리자(" + adminId + ")에 의해 " + statusText + " 처리되었습니다.";
            } else {
                logMessage = "[" + actionId + "] 건이 관리자(" + adminId + ")에 의해 " + statusText + " 처리되었습니다.";
            }
        }
        // 기타
        else {
            logMessage = actionName + " 완료";
        }

        try {
            sseService.sendTerminalLog(logType, logMessage);
        } catch (Exception e) {
            System.err.println("AOP SSE 로그 전송 실패: " + e.getMessage());
        }
    }
}