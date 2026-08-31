package com.spring.service; // 프로젝트 패키지 경로에 맞게 수정

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class SseService {

    // 동시성에 안전한 스레드 파이프라인 리스트
    private final List<SseEmitter> emitters = new CopyOnWriteArrayList<>();

    /**
     * 클라이언트 SSE 구독 연결 생성
     */
    public SseEmitter subscribe() {
        // 타임아웃 1시간 설정
        SseEmitter emitter = new SseEmitter(60 * 1000L * 60);
        this.emitters.add(emitter);

        // 연결 종료 / 타임아웃 / 에러 발생 시 리스트에서 제거
        emitter.onCompletion(() -> this.emitters.remove(emitter));
        emitter.onTimeout(() -> this.emitters.remove(emitter));
        emitter.onError((e) -> this.emitters.remove(emitter));

        // 최초 연결 시 503 에러 방지용 Dummy 이벤트 전송
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

        for (SseEmitter emitter : emitters) {
            try {
                emitter.send(SseEmitter.event()
                        .name(eventName)
                        .data(data));
            } catch (Exception e) {
                deadEmitters.add(emitter);
            }
        }
        this.emitters.removeAll(deadEmitters);
    }
}