package com.universidad.miapp;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("dev")
class ApplicationContextTest {

    @Test
    void contextLoads() {
        // Verifica que el contexto de Spring Boot se inicializa sin errores
    }
}
