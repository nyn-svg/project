package com.spring.service;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.spring.dto.AnimalDTO;

@Service
public class AnimalStateService {
	
	// 야생동물 객체명 한글 매핑 Map
    private static final Map<String, String> ANIMAL_MAP = Map.of(
        "wild_deer", "고라니 (wild_deer)",
        "wild_boar", "멧돼지 (wild_boar)",
        "agent", "안전요원"
    );

    // 야생동물 감지 상태 중복 등록 방지용 메모리
    private final Map<String, Boolean> animalReportState = new ConcurrentHashMap<>();
    
    // 감지된 야생동물 리스트(List<AnimalDTO>)에서 객체명을 한글명으로 변환
    public String getAnimalName(List<AnimalDTO> animals) {
    	if (animals == null || animals.isEmpty()) {
            return "감지된 객체 없음";
        }
    	
        // animals 리스트에서 name을 추출한 뒤 한글명으로 변환 및 중복 제거
    	return animals.stream()
        			  .map(AnimalDTO::getName)
        			  .filter(name -> name != null && !"agent".equals(name))
        			  .findFirst()
        			  .map(name -> ANIMAL_MAP.getOrDefault(name, "미등록 야생동물"))
        			  .orElse("감지된 객체 없음");
    }
    
    // 드론아이디와 지속 감지(isAnimal) 여부를 전달받아 위험 단계 판별
    public String checkAnimalDngrLevel(String droneId, boolean isAnimal) {
        if (!isAnimal) {
            // 3초 미만 단순 감지 시
            return "주의";
        }

        // 3초 이상 지속 감지 시 (드론 구역 특성 반영)
        if ("DRONE-03".equals(droneId)) {
            return "경계"; // 사람이 적은 구역
        } else if ("DRONE-01".equals(droneId) || "DRONE-02".equals(droneId)) {
            return "심각"; // 사람이 많은 구역
        } else {
            return "경계"; // 기본값
        }
    }
    
    // 야생동물 자동 등록 대상인지 판별 및 중복 방지 체크
    public boolean checkAnimalAutoRegist(String droneId, boolean isAnimal) {
        if (!isAnimal) {
            // 야생동물이 화면에서 사라지면 등록 가능 상태로 리셋
            animalReportState.put(droneId, false);
            return false;
        }

        // 이미 등록된 상태면 재등록 방지 (false 반환)
        boolean isAlreadyReported = animalReportState.getOrDefault(droneId, false);
        if (isAlreadyReported) {
            return false;
        }

        // 최초 3초 지속 감지 시 등록 상태로 변경 후 true 반환
        animalReportState.put(droneId, true);
        return true;
    }
}