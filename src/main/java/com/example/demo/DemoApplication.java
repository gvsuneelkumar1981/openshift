package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.autoconfigure.LifecycleMvcEndpointAutoConfiguration;



@SpringBootApplication(exclude = {LifecycleMvcEndpointAutoConfiguration.class}
)
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

}
