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

    @GetMapping("/sayHello")
    public Mono<String> sayHello() {
        return Mono.just("Hi.... Hello...!!!");
    }

    @GetMapping
    public Mono<String> config() {
        return Mono.just("Environment: "+environment +
                " | Mainframe Host: "+mainframeHost);
    }


}
