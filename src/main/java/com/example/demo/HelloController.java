package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
public class HelloController {

    @GetMapping("/sayHello")
    public Mono<String> sayHello() {
        return Mono.just("Hi.... Hello...!!!");
    }


}
