package com.spring.dto;

import lombok.Data;

@Data
public class AgentDTO {
    private String userId;     // USER_ID
    private String userName;   // USER_NAME
    private String phone;      // PHONE
    private String email;      // EMAIL
    private String workStatus; // WORK_STATUS (근무중, 퇴근 등)
    private String workArea;   // WORK_AREA (A구역, B구역 등)
    private String workTime;   // WORK_TIME
}