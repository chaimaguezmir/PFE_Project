package com.idvey.afya.security;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.Duration;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class RateLimitingFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(RateLimitingFilter.class);

    // Cache to store buckets per IP
    private final ConcurrentHashMap<String, Bucket> cache = new ConcurrentHashMap<>();

    // Rate limit: 100 requests per minute per IP
    private final Bandwidth limit = Bandwidth.classic(200, Refill.intervally(200, Duration.ofMinutes(1)));

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String clientIp = getClientIpAddress(httpRequest);
        Bucket bucket = cache.computeIfAbsent(clientIp, this::createBucket);

        if (bucket.tryConsume(1)) {
            // Request allowed, continue with the chain
            chain.doFilter(request, response);
        } else {
            // Rate limit exceeded
            logger.warn("Rate limit exceeded for IP: {} on path: {}", clientIp, httpRequest.getServletPath());
            httpResponse.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
            httpResponse.setContentType("application/json");
            httpResponse.getWriter().write(
                    "{\"error\":\"Too Many Requests\",\"message\":\"Rate limit exceeded\",\"status\":429}"
            );
        }
    }

    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedForHeader = request.getHeader("X-Forwarded-For");
        if (xForwardedForHeader == null) {
            return request.getRemoteAddr();
        } else {
            return xForwardedForHeader.split(",")[0].trim();
        }
    }

    private Bucket createBucket(String key) {
        return Bucket.builder()
                .addLimit(limit)
                .build();
    }

    // Clean up old entries periodically (you might want to implement this with @Scheduled)
    public void cleanupOldEntries() {
        // Remove entries older than 1 hour to prevent memory leaks
        // This is a simple implementation - in production, consider using Redis or similar
        if (cache.size() > 10000) {
            cache.clear();
            logger.info("Rate limiting cache cleared due to size limit");
        }
    }
}
