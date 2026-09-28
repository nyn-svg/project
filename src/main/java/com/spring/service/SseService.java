package com.spring.service; // 프로젝트 패키지 경로에 맞게 수정

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Service
public class SseService {

    // 동시성에 안전한 스레드 파이프라인 리스트
    private final List<SseEmitter> emitters = new CopyOnWriteArrayList<>();

    /**
     * 클라이언트 SSE 구독 연결 생성
     */
    public SseEmitter subscribe() {
        // 30분 타임아웃 설정 (30 * 60 * 1000L)
        SseEmitter emitter = new SseEmitter(30 * 60 * 1000L);
        this.emitters.add(emitter);

        // 연결 종료 / 타임아웃 / 에러 발생 시 리스트에서 제거 및 완료 처리
        emitter.onCompletion(() -> this.emitters.remove(emitter));
        emitter.onTimeout(() -> {
            emitter.complete(); // 💡 타임아웃 발생 시 명시적 완료 처리
            this.emitters.remove(emitter);
        });
        emitter.onError((e) -> this.emitters.remove(emitter));

        // 최초 연결 Dummy 이벤트 전송
        try {
            emitter.send(SseEmitter.event().name("connect").data("connected"));
        } catch (IOException e) {
            this.emitters.remove(emitter);
        }

        return emitter;
    }

    /**
     * 특정 이벤트 이름과 데이터를 접속 중인 모든 클라이언트에 브로드캐스트
     */
    public void sendEvent(String eventName, Object data) {
        List<SseEmitter> deadEmitters = new ArrayList<>();

        for (SseEmitter emitter : this.emitters) {
            try {
                emitter.send(SseEmitter.event()
                        .name(eventName)
                        .data(data));
            } catch (Throwable t) {
                // 💡 Exception보다 넓은 Throwable(ClientAbortException 등 포함)을 캐치하고
                // 이미 끊긴 연결은 즉시 리스트에서 제거 대상으로 등록
                deadEmitters.add(emitter);
                try {
                    // 이미 죽은 Emitter를 스프링 내부 관리 목록에서 안전하게 종료
                    emitter.completeWithError(t);
                } catch (Throwable ignored) {
                    // 이미 닫힌 소켓에 대한 추가 예외는 완전 무시
                }
            }
        }

        // 끊어진 Emitter들을 한꺼번에 정리
        if (!deadEmitters.isEmpty()) {
            this.emitters.removeAll(deadEmitters);
        }
    }
    
    /**
     * AOP 및 백엔드에서 관제 터미널로 실시간 로그를 단발성 전송하는 메서드
     */
    public void sendTerminalLog(String type, String message) {
        List<SseEmitter> deadEmitters = new ArrayList<>();

        // JSON 형식으로 데이터를 포맷팅
        Map<String, String> data = new HashMap<>();
        data.put("type", type);
        data.put("message", message);

        for (SseEmitter emitter : this.emitters) {
            try {
                // 프론트엔드의 'terminal-log' 이벤트 리스너로 전송
                emitter.send(SseEmitter.event()
                        .name("terminal-log")
                        .data(data));
            } catch (Throwable t) {
                // 끊긴 연결은 즉시 리스트에서 제거 대상으로 등록
                deadEmitters.add(emitter);
                try {
                    // 스프링 비동기 파이프라인에서 해당 Emitter를 완벽하게 강제 종료
                    emitter.completeWithError(t);
                } catch (Throwable ignored) {
                    // 이미 닫힌 소켓 예외는 무시
                }
            }
        }

        // 끊긴 커넥션 정돈
        if (!deadEmitters.isEmpty()) {
            this.emitters.removeAll(deadEmitters);
        }
    }
}