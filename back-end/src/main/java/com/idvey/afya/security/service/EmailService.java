package com.idvey.afya.security.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring6.SpringTemplateEngine;

import java.time.LocalDate;
import java.time.Year;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Service
public class EmailService {
    private final JavaMailSender mailSender;
    private final SpringTemplateEngine templateEngine;
    private final String from;
    private final String logoUrl;
    private static final int EXPIRY_MINUTES = 20;

    @Autowired
    public EmailService(JavaMailSender mailSender,
                        SpringTemplateEngine templateEngine,
                        @Value("${afya.app.activation.from}") String from,
                        @Value("${afya.app.logo-url}") String logoUrl) {
        this.mailSender = mailSender;
        this.templateEngine = templateEngine;
        this.from = from;
        this.logoUrl = logoUrl;
    }

    public void sendActivationEmail(String to, String name, String code) {
        Context ctx = new Context(Locale.FRENCH);
        ctx.setVariable("today",
                LocalDate.now().format(DateTimeFormatter.ofPattern("d MMM, yyyy", Locale.ENGLISH)));
        ctx.setVariable("name", name);
        ctx.setVariable("expiry", EXPIRY_MINUTES + " minutes");
        ctx.setVariable("code", code);
        ctx.setVariable("logoUrl", logoUrl);
        ctx.setVariable("year", Year.now().getValue());

        String html = templateEngine.process("activation-email", ctx);

        MimeMessage msg = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(msg, "utf-8");
            helper.setFrom(from);
            helper.setTo(to);
            helper.setSubject("Votre code de vérification Afya");
            helper.setText(html, true);
            mailSender.send(msg);
        } catch (MessagingException e) {
            throw new RuntimeException("Échec de l’envoi de l’email d’activation", e);
        }
    }
}
