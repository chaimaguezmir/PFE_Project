package com.idvey.afya.security;

import com.idvey.afya.security.jwt.AuthEntryPointJwt;
import com.idvey.afya.security.jwt.AuthTokenFilter;
import com.idvey.afya.security.service.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig {

	@Autowired
	UserDetailsServiceImpl userDetailsService;

	@Autowired
	private AuthEntryPointJwt unauthorizedHandler;

	@Autowired
	private RateLimitingFilter rateLimitingFilter;

	@Bean
	public AuthTokenFilter authenticationJwtTokenFilter() {
		return new AuthTokenFilter();
	}

	@Bean
	public DaoAuthenticationProvider authenticationProvider() {
		DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
		authProvider.setUserDetailsService(userDetailsService);
		authProvider.setPasswordEncoder(passwordEncoder());
		return authProvider;
	}

	@Bean
	public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
		return authConfig.getAuthenticationManager();
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http.cors(cors -> cors.configurationSource(request -> {
			var corsConfig = new org.springframework.web.cors.CorsConfiguration();
			corsConfig.addAllowedOrigin("*");
			corsConfig.addAllowedMethod("*");
			corsConfig.addAllowedHeader("*");
			return corsConfig;
		}))
			.csrf(AbstractHttpConfigurer::disable)
			.exceptionHandling(exceptionHandling -> exceptionHandling.authenticationEntryPoint(unauthorizedHandler))
			.sessionManagement(
					sessionManagement -> sessionManagement.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
			.authorizeHttpRequests(authorize -> authorize.requestMatchers("/api/auth/**")
				.permitAll()
				.requestMatchers("/api/test/**")
				.permitAll()
				.requestMatchers("/swagger-ui/**", "/v3/api-docs/**")
				.permitAll() // Allow Swagger access
				.requestMatchers("/actuator/health")
				.permitAll() // Health check
				.requestMatchers("/api/groups/**")
				.authenticated()
				.requestMatchers("/api/pharmacy-box/**")
				.authenticated()
				.requestMatchers("/api/medicines/**")
				.authenticated()
				.requestMatchers("/api/my-medicines/**")
				.authenticated()
				.requestMatchers("/api/purchase-history/**")
				.authenticated()
				.requestMatchers("/api/prescriptions/**")
				.authenticated()
				.requestMatchers("/api/treatments/**")
				.authenticated()
				.requestMatchers("/api/diseases/**")
				.authenticated()
				.requestMatchers("/api/reminders/**")
				.authenticated()
				.anyRequest()
				.permitAll());

		http.authenticationProvider(authenticationProvider());

		// Add rate limiting filter before authentication
		http.addFilterBefore(rateLimitingFilter, UsernamePasswordAuthenticationFilter.class);
		http.addFilterBefore(authenticationJwtTokenFilter(), UsernamePasswordAuthenticationFilter.class);

		return http.build();
	}

}