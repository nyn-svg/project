package com.spring.dto;

import lombok.Data;

@Data
public class EmergencyContactDTO {
    private Long contactId;
    private String category;
    private String title;
    private String phone;
    private Integer sortOrder;
    private String regDate;
}