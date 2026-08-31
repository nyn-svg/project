package com.spring.controller; // 프로젝트 패키지 경로에 맞게 수정

import com.spring.service.SseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Controller
@RequestMapping("/api/sse")
public class SseController {

    @Autowired
    private SseService sseService;

    /**
     * 프론트엔드에서 SSE 연결 구독을 위한 엔드포인트
     * 호출 주소: /api/sse/subscribe
     */
    @GetMapping(value = "/subscribe", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter subscribe() {
        return sseService.subscribe();
    }
}