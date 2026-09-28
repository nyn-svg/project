package com.spring.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.spring.dto.AgentDTO;

@Mapper
public interface AgentMapper {
    
    //안전요원 개인 정보 및 근무 상세 데이터 단건 통합 조회
    AgentDTO findAgentById(String userId);
    
    //모바일 앱 내 실시간 출퇴근/근무 상태 스위칭 변경
    int updateAgentStatus(@Param("userId") String userId, @Param("workStatus") String workStatus);
    
    //자바에서 매핑 정보를 넘겨받아 특정 요원의 구역명을 저장하는 메서드
    int syncAgentWorkArea(@Param("userId") String userId, @Param("workArea") String workArea);
}