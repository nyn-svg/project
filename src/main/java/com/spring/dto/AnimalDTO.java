package com.spring.dto;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class AnimalDTO {
    private String name;        // 예: "wild_boar"
    private double conf;        // 예: 85.2
    private List<Integer> box;  // 예: [100, 150, 200, 250]
    
    @JsonProperty("class_idx")
    private int classIdx;       // 예: 1
}