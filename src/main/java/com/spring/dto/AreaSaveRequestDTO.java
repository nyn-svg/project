package com.spring.dto;

import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class AreaSaveRequestDTO {
    private String bgImageSrc;       // base64 도면 이미지 데이터
    private List<Object> zones;      // 구역(Polygon) 리스트
    private List<Object> facilities; // 시설물(Marker) 리스트
}