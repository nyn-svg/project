package com.spring.controller;

import com.spring.service.SseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import jakarta.servlet.http.HttpServletResponse; 

@RestController // 1. @Controller 대신 @RestController로 변경하여 JSON/Stream 응답 전용으로 전환
@RequestMapping("/api/sse")
public class SseController {

    @Autowired
    private SseService sseService;

    /**
     * 프론트엔드에서 SSE 연결 구독을 위한 엔드포인트
     * 호출 주소: /api/sse/subscribe
     */
    @GetMapping(value = "/subscribe", produces = MediaType.TEXT_EVENT_STREAM_VALUE + ";charset=UTF-8")
    public ResponseEntity<SseEmitter> subscribe(HttpServletResponse response) {
        
        // 2. 브라우저 및 Nginx/Tomcat 응답 버퍼링 락 방지 헤더 추가
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        response.setHeader("X-Accel-Buffering", "no"); // Nginx나 프록시 사용 시 버퍼링 방지

        // 3. SseService에서 구독 처리 후 Emitter 반환
        SseEmitter emitter = sseService.subscribe();
        
        return new ResponseEntity<>(emitter, HttpStatus.OK);
    }
}