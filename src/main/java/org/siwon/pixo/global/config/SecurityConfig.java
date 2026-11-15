package org.siwon.pixo.global.config;

import org.springframework.boot.autoconfigure.security.servlet.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.annotation.web.configurers.HeadersConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.session.HttpSessionEventPublisher;

/**
 * @author 박 수 빈
 * @version 1.0
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private static final String[] ALLOWED_REQUEST_MATCHERS = {
            "/",
            "/sign-up",
            "/api/v1/auth/**",
            "/api/v1/users/is-duplicated-email",
            "/api/v1/users/is-duplicated-nickname",
            "/api/v1/users"
    };

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        /* HTTP 기본 인증 비활성화 */
        http.httpBasic(AbstractHttpConfigurer::disable);
        /* 폼 로그인 비활성화 */
        http.formLogin(AbstractHttpConfigurer::disable);
        /* CSRF 보호 비활성화 */
        http.csrf(AbstractHttpConfigurer::disable);

        /* H2 콘솔 사용을 위한 X-Frame-Options 헤더 설정 : 동일 도메인 내 프레임 렌더링 허용 */
        http.headers(header -> header.frameOptions(HeadersConfigurer.FrameOptionsConfig::sameOrigin));

        /* 특정 HTTP 요청에 대한 인가 정책 설정 */
        http.authorizeHttpRequests(auth -> auth
                .requestMatchers(ALLOWED_REQUEST_MATCHERS).permitAll()
                .requestMatchers(PathRequest.toH2Console()).permitAll()
                .anyRequest().authenticated());

        /* 세션 관리 정책 설정 */
        http.sessionManagement(session -> session
                // 사용자당 최대 허용 세션 수 제한
                .maximumSessions(1)
                // 'false'일 경우 신규 로그인시 기존 세션 만료, 'true'일 경우 동시 로그인 차
                .maxSessionsPreventsLogin(false)
                // 세션 만료시 이동할 URL 지정
                .expiredUrl("/"));
        return http.build();
    }

    @Bean
    public WebSecurityCustomizer customizer() {
        return (web) -> web.ignoring()
                .requestMatchers(PathRequest.toStaticResources().atCommonLocations());
    }

    @Bean
    public HttpSessionEventPublisher sessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}