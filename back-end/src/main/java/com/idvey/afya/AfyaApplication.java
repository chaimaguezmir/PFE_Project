package com.idvey.afya;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;

import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;

import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@OpenAPIDefinition(
		info = @Info(
				title = "Afya API",
				version = "1.0.0",
				description = "Complete medicine management system with user authentication, group collaboration, and pharmacy box management",
				contact = @Contact(
						name = "Afya Development Team",
						email = "support@afya.com"
				),
				license = @License(
						name = "MIT License",
						url = "https://opensource.org/licenses/MIT"
				)
		),
		tags = {
				@Tag(name = "Authentication", description = "User authentication - Sign-in, sign-up, refresh & sign-out"),
				@Tag(name = "Groups", description = "Group management and collaboration - Create, join, manage groups"),
				@Tag(name = "Pharmacy Box", description = "Pharmacy box management - Access user's medicine containers"),
				@Tag(name = "Medicine", description = "Medicine master data - Search, create, and manage medicine catalog"),
				@Tag(name = "My Medicines", description = "Personal medicine management - Add, update, track medicines in pharmacy boxes"),
				@Tag(name = "Purchase History", description = "Purchase and consumption tracking - Record medicine usage and purchases")
		}
)
@SpringBootApplication
public class AfyaApplication {

	public static void main(String[] args) {
		SpringApplication.run(AfyaApplication.class, args);
	}

}
