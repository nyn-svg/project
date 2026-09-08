package com.spring.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AreaMapper {

    // 도면 배치 정보 저장 (MERGE INTO)
    int updateAreaConfig(@Param("mapName") String mapName, @Param("configJson") String configJson);
    int insertAreaConfig(@Param("mapName") String mapName, @Param("configJson") String configJson);
    // 도면 배치 정보 조회 (나중에 불러오기 기능용)
    String selectAreaConfig(@Param("mapName") String mapName);
}