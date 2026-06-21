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

    // These come directly from Vault!
    @Value("${db_password:not-set}")
    private String dbPassword;

    @Value("${mq_password:not-set}")
    private String mqPassword;

    @GetMapping("/sayHello")
    public Mono<String> sayHello() {
        return Mono.just("Hi.... Hello...!!!");
    }

    @GetMapping("/config")
    public Mono<String> config() {
        return Mono.just("Environment: "+environment +
                " | Mainframe Host: "+mainframeHost);
    }

    @GetMapping("/vault-test")
    public Mono<String> vaultTest() {
        // Shows secrets came from Vault
        // NEVER expose actual passwords in real app!
        return Mono.just(
                "DB Password set: " + !dbPassword.equals("not-set") +
                        " | MQ Password set: " + !mqPassword.equals("not-set")
        );
    }


}
