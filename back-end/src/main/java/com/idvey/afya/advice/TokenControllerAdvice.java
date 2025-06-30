package com.idvey.afya.advice;

import com.idvey.afya.exception.TokenRefreshException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;


import org.springframework.web.context.request.WebRequest;

import java.nio.file.AccessDeniedException;
import java.util.Date;
import java.util.NoSuchElementException;

@RestControllerAdvice
public class TokenControllerAdvice {

	// your existing TokenRefresh handler...
	@ExceptionHandler(TokenRefreshException.class)
	@ResponseStatus(HttpStatus.FORBIDDEN)
	public ErrorMessage handleTokenRefreshException(TokenRefreshException ex, WebRequest request) {
		return new ErrorMessage(HttpStatus.FORBIDDEN.value(), new Date(), ex.getMessage(),
				request.getDescription(false));
	}

	// new handler for conflict (e.g. duplicate group name, duplicate user in group, etc.)
	@ExceptionHandler(IllegalStateException.class)
	@ResponseStatus(HttpStatus.CONFLICT)
	public ErrorMessage handleIllegalState(IllegalStateException ex, WebRequest request) {
		return new ErrorMessage(HttpStatus.CONFLICT.value(), new Date(), ex.getMessage(),
				request.getDescription(false));
	}

	// optionally, catch NoSuchElementException → 404 Not Found
	@ExceptionHandler(NoSuchElementException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public ErrorMessage handleNotFound(NoSuchElementException ex, WebRequest request) {
		return new ErrorMessage(HttpStatus.NOT_FOUND.value(), new Date(), ex.getMessage(),
				request.getDescription(false));
	}

	// and AccessDeniedException → 403 Forbidden
	@ExceptionHandler(AccessDeniedException.class)
	@ResponseStatus(HttpStatus.FORBIDDEN)
	public ErrorMessage handleAccessDenied(AccessDeniedException ex, WebRequest request) {
		return new ErrorMessage(HttpStatus.FORBIDDEN.value(), new Date(), ex.getMessage(),
				request.getDescription(false));
	}
	@ExceptionHandler(UnauthorizedException.class)
	@ResponseStatus(HttpStatus.UNAUTHORIZED)
	public ErrorMessage handleUnauthorizedException(UnauthorizedException ex, WebRequest request) {
		return new ErrorMessage(
				HttpStatus.UNAUTHORIZED.value(),
				new Date(),
				ex.getMessage(),
				request.getDescription(false)
		);
	}

}