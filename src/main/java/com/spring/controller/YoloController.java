package com.spring.controller;

import java.io.File;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import com.spring.service.YoloService;

@Controller
public class YoloController {

    @Autowired
    private YoloService yoloService;

    /**
     * 프론트엔드(JSP/JS)에서 전송한 이미지 프레임을 받아서 파이썬 AI 서버로 전달하고 결과를 반환합니다.
     */
    @RequestMapping(value = "/api/detectImage", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String detectImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "drone_id", defaultValue = "drone1") String droneId) {

        if (file.isEmpty()) {
            return "{\"status\":\"error\", \"message\":\"전송된 파일이 없습니다.\"}";
        }

        File tempFile = null;
        try {
            // 웹상에서 업로드된 MultipartFile을 파이썬 서버로 보낼 수 있게 임시 파일로 변환
            tempFile = File.createTempFile("frame_", ".jpg");
            file.transferTo(tempFile);

            // YoloService 호출하여 파이썬 결과 받기
            String jsonResult = yoloService.detectImage(tempFile, droneId);

            return jsonResult;

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"status\":\"error\", \"message\":\"파일 처리 중 오류 발생: " + e.getMessage() + "\"}";
        } finally {
            // 처리 끝난 임시 파일 즉시 삭제
            if (tempFile != null && tempFile.exists()) {
                tempFile.delete();
            }
        }
    }
}