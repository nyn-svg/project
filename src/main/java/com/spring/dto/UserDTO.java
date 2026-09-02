package com.spring.dto;

import java.util.Date;
import lombok.Data;

@Data
public class UserDTO {
    private String userId;     // USER_ID (로그인 아이디)
    private String userPw;     // USER_PW (비밀번호)
    private String userName;   // USER_NAME (이름)
    private String phone;      // PHONE (연락처)
    private String email;      // EMAIL (이메일)
    private int enabled;       // ENABLED (계정 활성화 여부)
    private Date regDate;      // REG_DATE (가입일)
    
    private String workStatus; // 근무 상태 (예: 근무중)
    private String workArea;   // 근무 담당 구역 (예: A구역)
    private String workTime;   // 근무 시간 (예: 09:00 ~ 18:00)
}