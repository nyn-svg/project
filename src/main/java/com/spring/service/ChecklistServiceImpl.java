package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dto.ChecklistHistoryDTO;
import com.spring.dto.ChecklistItemDTO;
import com.spring.mapper.ChecklistMapper;

@Service
public class ChecklistServiceImpl implements ChecklistService {

    @Autowired
    private ChecklistMapper checklistMapper;

    @Override
    public List<ChecklistItemDTO> getItemsByTarget(String targetType) {
        return checklistMapper.selectItemsByTarget(targetType);
    }

    @Override
    public boolean registerChecklistItem(ChecklistItemDTO dto) {
        // 정렬 순서 기본값 미입력 시 1로 설정
        if (dto.getSortOrder() == null) {
            dto.setSortOrder(1);
        }
        // 사용 여부 기본값 미입력 시 Y로 설정
        if (dto.getIsUse() == null || dto.getIsUse().isEmpty()) {
            dto.setIsUse("Y");
        }
        return checklistMapper.insertChecklistItem(dto) > 0;
    }

    @Override
    public boolean modifyChecklistItem(ChecklistItemDTO dto) {
        return checklistMapper.updateChecklistItem(dto) > 0;
    }

    @Override
    public boolean removeChecklistItem(Long itemId) {
        return checklistMapper.deleteChecklistItem(itemId) > 0;
    }
    
    @Override
    public List<ChecklistHistoryDTO> getChecklistHistoryList() {
        return checklistMapper.selectChecklistHistoryList();
    }

    @Override
    public List<ChecklistHistoryDTO> getChecklistHistoryDetail(String userId, String checkDateStr) {
        return checklistMapper.selectChecklistHistoryDetail(userId, checkDateStr);
    }
}