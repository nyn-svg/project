package com.spring.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface AdminLog {
    String value(); // 터미널에 표시될 작업 설명 (예: "요원 상태 변경")
    String type() default "INFO"; // 로그 클래스 타입 (INFO, WARN, ACTION, DANGER)
}