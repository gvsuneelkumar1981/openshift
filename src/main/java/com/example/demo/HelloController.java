package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
public class HelloController {

    @Value("${app.environment:local}")
    private String environment;

    @Value("${app.mainframe.host:localhost}")
    private String mainframeHost;

    // These come from Vault
    @Value("${db_password:NOT_LOADED}")
    private String dbPassword;

    @Value("${mq_password:NOT_LOADED}")
    private String mqPassword;

    @Value("${api_key:NOT_LOADED}")
    private String apiKey;

    @GetMapping("/sayHello")
    public Mono<String> sayHello() {
        return Mono.just("Hi.... Hello...!!!");
    }

    @GetMapping("/config")
    public Mono<String> config() {
        return Mono.just(
                "Environment: " + environment +
                        " | Mainframe: " + mainframeHost
        );
    }

    // Shows secrets loaded from Vault
    // REMOVE in production — only for testing!
    @GetMapping("/vault-test")
    public Mono<String> vaultTest() {
        return Mono.just(
                "DB_PASSWORD: " + maskSecret(dbPassword) +
                        " | MQ_PASSWORD: " + maskSecret(mqPassword) +
                        " | API_KEY: " + maskSecret(apiKey)
        );
    }

    // Mask secret — show only first 3 chars
    private String maskSecret(String secret) {
        if (secret == null || secret.length() < 3) return "***";
        return secret.substring(0, 3) + "***";
    }
}