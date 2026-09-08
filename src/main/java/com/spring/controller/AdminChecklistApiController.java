package com.spring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.dto.ChecklistItemDTO;
import com.spring.dto.ChecklistHistoryDTO;
import com.spring.service.ChecklistService;

@RestController
@RequestMapping("/admin/api/checklist")
public class AdminChecklistApiController {

    @Autowired
    private ChecklistService checklistService;

    // 1. 대상별(AGENT / CONTROL) 문항 목록 조회
    @GetMapping("/items")
    public ResponseEntity<List<ChecklistItemDTO>> getItems(@RequestParam("targetType") String targetType) {
        List<ChecklistItemDTO> list = checklistService.getItemsByTarget(targetType);
        return ResponseEntity.ok(list);
    }

    // 2. 신규 문항 등록
    @PostMapping("/items")
    public ResponseEntity<Map<String, Object>> createItem(@RequestBody ChecklistItemDTO dto) {
        Map<String, Object> response = new HashMap<>();
        boolean success = checklistService.registerChecklistItem(dto);
        response.put("success", success);
        return ResponseEntity.ok(response);
    }

    // 3. 문항 수정
    @PutMapping("/items")
    public ResponseEntity<Map<String, Object>> updateItem(@RequestBody ChecklistItemDTO dto) {
        Map<String, Object> response = new HashMap<>();
        boolean success = checklistService.modifyChecklistItem(dto);
        response.put("success", success);
        return ResponseEntity.ok(response);
    }

    // 4. 문항 삭제
    @DeleteMapping("/items/{itemId}")
    public ResponseEntity<Map<String, Object>> deleteItem(@PathVariable("itemId") Long itemId) {
        Map<String, Object> response = new HashMap<>();
        boolean success = checklistService.removeChecklistItem(itemId);
        response.put("success", success);
        return ResponseEntity.ok(response);
    }
    
 // 5. 사이드바용 전체 점검 제출 이력 요약 목록 조회
    @GetMapping("/history")
    public ResponseEntity<List<ChecklistHistoryDTO>> getHistoryList() {
        List<ChecklistHistoryDTO> list = checklistService.getChecklistHistoryList();
        return ResponseEntity.ok(list);
    }

    // 6. 모달용 상세 점검 결과 조회
    @GetMapping("/history/detail")
    public ResponseEntity<List<ChecklistHistoryDTO>> getHistoryDetail(
            @RequestParam("userId") String userId,
            @RequestParam("checkDateStr") String checkDateStr) {
        List<ChecklistHistoryDTO> detailList = checklistService.getChecklistHistoryDetail(userId, checkDateStr);
        return ResponseEntity.ok(detailList);
    }
}