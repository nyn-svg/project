package com.spring.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.servlet.handler.HandlerMappingIntrospector;

import com.spring.security.CustomLoginSuccessHandler;
import com.spring.security.CustomUserDetailsService;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private CustomLoginSuccessHandler successHandler;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    // ★ 추가: Spring MVC Introspector 빈 수동 등록
    @Bean(name = "mvcHandlerMappingIntrospector")
    public HandlerMappingIntrospector mvcHandlerMappingIntrospector() {
        return new HandlerMappingIntrospector();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
        AuthenticationManagerBuilder authBuilder = 
            http.getSharedObject(AuthenticationManagerBuilder.class);
        
        authBuilder
            .userDetailsService(customUserDetailsService)
            .passwordEncoder(passwordEncoder());
            
        return authBuilder.build();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/login", "/resources/**", "/css/**", "/js/**").permitAll()
                .requestMatchers("/agent/sse/**", "/api/sse/**").permitAll()
                .requestMatchers("/control/**").hasRole("CONTROL")
                .requestMatchers("/admin/**").hasRole("ADMIN")
                // 💡 AGENT 및 CONTROL(관제사) 모두 접근 가능하도록 수정 (필요 시 ADMIN 추가)
                .requestMatchers("/agent/**").hasAnyRole("AGENT", "CONTROL", "ADMIN")
                .anyRequest().authenticated()
            )
            
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/loginProcess")
                .usernameParameter("userId")
                .passwordParameter("userPw")
                .successHandler(successHandler)
                .permitAll()
            )
            
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            )

            // 💡 권한 없는 페이지 접근 시 403으로 인해 로그인 창으로 튕겨 로그아웃되는 현상 방지
            .exceptionHandling(exception -> exception
                .accessDeniedPage("/access-denied") // 권한 부족 시 이동할 페이지 (또는 /)
            );

        return http.build();
    }
}