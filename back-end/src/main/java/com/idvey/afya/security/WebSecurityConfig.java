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
@EnableMethodSecurity(
		// securedEnabled = true,
		// jsr250Enabled = true,
		prePostEnabled = true)
public class WebSecurityConfig {

	// extends WebSecurityConfigurerAdapter {
	@Autowired
	UserDetailsServiceImpl userDetailsService;

	@Autowired
	private AuthEntryPointJwt unauthorizedHandler;

	@Bean
	public AuthTokenFilter authenticationJwtTokenFilter() {
		return new AuthTokenFilter();
	}

	// @Override
	// public void configure(AuthenticationManagerBuilder authenticationManagerBuilder)
	// throws Exception {
	// authenticationManagerBuilder.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
	// }
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
				.requestMatchers("/api/groups/**")
				.authenticated()
				.requestMatchers("/api/pharmacy-box/**")
				.authenticated()
				.requestMatchers("/api/medicines/**").authenticated()
				.requestMatchers("/api/my-medicines/**").authenticated()
				.requestMatchers("/api/purchase-history/**").authenticated()
				.requestMatchers("/api/prescriptions/**").authenticated()
				.requestMatchers("/api/treatments/**").authenticated()
				.requestMatchers("/api/diseases/**").authenticated()
				// .requestMatchers("/client/**").authenticated()
				// .requestMatchers(HttpMethod.GET,
				// "/api/medic/**").hasAuthority("ROLE_ADMIN")
				// .requestMatchers(HttpMethod.POST,
				// "/api/medic/**").hasAuthority("ROLE_ADMIN")
				// .requestMatchers(HttpMethod.PUT, "/api/medic/**").denyAll()
				// .requestMatchers(HttpMethod.PATCH, "/api/medic/**").denyAll()
				// .requestMatchers(HttpMethod.DELETE,
				// "/api/medic/**").hasAuthority("ROLE_ADMIN")
				// .requestMatchers("/api/medic/specific").hasAuthority("ROLE_ADMIN")
				.anyRequest()
				.permitAll());

		http.authenticationProvider(authenticationProvider());
		http.addFilterBefore(authenticationJwtTokenFilter(), UsernamePasswordAuthenticationFilter.class);

		return http.build();
	}

	/*
	 * @Bean public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
	 * http.cors().and().csrf().disable()
	 * .exceptionHandling().authenticationEntryPoint(unauthorizedHandler).and()
	 * .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).and()
	 * .authorizeRequests().requestMatchers("/api/auth/**").permitAll()
	 * .requestMatchers("/api/test/**").permitAll()
	 * //.requestMatchers(HttpMethod.POST,"/client/save").hasAnyAuthority(String.valueOf(
	 * ERole.ROLE_ADMIN))
	 *
	 * .requestMatchers("/client/**").permitAll() .anyRequest().permitAll();
	 * http.authenticationProvider(authenticationProvider());
	 *
	 * http.addFilterBefore(authenticationJwtTokenFilter(),
	 * UsernamePasswordAuthenticationFilter.class);
	 *
	 * return http.build(); }
	 */

}
