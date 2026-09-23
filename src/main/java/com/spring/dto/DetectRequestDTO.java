package com.spring.dto;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class DetectRequestDTO {
    private String droneId;
    private int peopleCount;
    private double density;
    
    @JsonProperty("is_animal")
    private boolean isAnimal;
    
    private List<AnimalDTO> animals; // AnimalDTO 리스트 포함

}