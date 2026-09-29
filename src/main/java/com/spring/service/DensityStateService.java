package com.spring.service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Service;

@Service
public class DensityStateService {

    // 위험 단계별 가중치 (상승 판단용)
    private static final Map<String, Integer> LEVEL_WEIGHT = Map.of(
        "관심", 0,
        "주의", 1,
        "경계", 2,
        "심각", 3
    );

    // 드론 아이디별 상태 저장 메모리
    private final Map<String, DroneState> stateMap = new ConcurrentHashMap<>();

    private static class DroneState {
        String currentLevel = "관심";		// 현재 수신 중인 위험 단계
        long levelStartTime = 0;		// 현재 단계가 시작된 타임스탬프(ms)
        int lastReportedWeight = 0;		// 마지막으로 자동 등록 성공했던 단계 가중치
    }

    // 밀집도를 전달받아 위험 단계 및 자동 등록(3초 유지 + 단계 상승) 대상인지 판별
    public String checkDensityAutoRegist(String droneId, double density) {
    	long now = System.currentTimeMillis();
    	
    	DroneState state = stateMap.computeIfAbsent(droneId, k -> new DroneState());
    	
    	String newLevel = checkDngrLevel(density);
    	
    	// 💡 해당 드론의 state 객체에만 락을 걸어 동시성 제어 (다른 드론에 영향 없음)
        synchronized (state) {
	        int newWeight = LEVEL_WEIGHT.getOrDefault(newLevel, 0);
	
	        // 1. '관심' 단계로 하강 시 기록 초기화 (다시 상승할 때 등록 가능하도록)
	        if (newWeight == 0) {
	            state.currentLevel = "관심";
	            state.levelStartTime = 0;
	            state.lastReportedWeight = 0;
	            return null;
	        }
	
	        // 2. 이미 등록했던 단계 이하로 유지/하락된 경우 무시
	        if (newWeight <= state.lastReportedWeight) {
	            state.currentLevel = newLevel;
	            state.levelStartTime = now;
	            return null;
	        }
	
	        // 3. 위험 단계가 새로 변경(상승)된 경우 → 3초 타이머 측정 시작
	        if (!newLevel.equals(state.currentLevel)) {
	            state.currentLevel = newLevel;
	            state.levelStartTime = now; // 지속 시간 시작점 기록
	            return null;
	        }
	
	        // 4. 동일한 위험 단계가 계속 유지되고 있는 경우 → 5초(5000ms) 지속 여부 검사
	        if (state.levelStartTime > 0 && (now - state.levelStartTime >= 5000)) {
	            // 3초 지속 조건 충족! → 등록 성공 처리 및 가중치 업데이트
	            state.lastReportedWeight = newWeight;
	            state.levelStartTime = 0; // 중복 등록 방지용 초기화
	            return newLevel; // 자동 등록 대상 위험단계 반환
	        }
	
	        return null;
        }
    }
    
    public String checkDngrLevel(double density) {
        if (density >= 80) {
            return "심각";
        } else if (density >= 50) {
            return "경계";
        } else if (density >= 20) {
            return "주의";
        }
        return "관심";
    }
}