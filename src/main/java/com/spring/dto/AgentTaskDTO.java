package com.spring.dto; // 프로젝트 패키지 경로에 맞게 수정

import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data                   // Getter, Setter, toString, equalsAndHashCode 자동 생성
@NoArgsConstructor      // 기본 생성자 자동 생성
@AllArgsConstructor     // 모든 필드를 파라미터로 받는 생성자 자동 생성
public class AgentTaskDTO {
    
    private Long taskId;         // TASK_ID (시퀀스로 생성된 PK)
    private String agentId;      // AGENT_ID
    private String taskType;     // TASK_TYPE
    private String taskArea;     // TASK_AREA
    private String taskTitle;    // TASK_TITLE
    private String taskContent;  // TASK_CONTENT
    private String actionStatus; // ACTION_STATUS
    private String startTime;    // START_TIME
    private String endTime;      // END_TIME
    private String taskNote;     // TASK_NOTE
    private Date regDate;        // REG_DATE
}