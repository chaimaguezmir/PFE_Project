package com.idvey.afya;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;

import io.swagger.v3.oas.annotations.info.Info;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@OpenAPIDefinition(info = @Info(title = "Afya API", version = "1.0.0"

), tags = { @Tag(name = "Authentication", description = "Sign-in, sign-up, refresh & sign-out"),
		// … add one @Tag per module …
})
@SpringBootApplication
public class AfyaApplication {

	public static void main(String[] args) {
		SpringApplication.run(AfyaApplication.class, args);
	}

}
