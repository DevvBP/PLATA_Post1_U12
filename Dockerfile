# ==============================================================================
# ETAPA 1: BUILDER
# Compilacion y empaquetado del artefacto con eclipse-temurin:21-jdk-alpine
# ==============================================================================
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# Instalar Maven en la imagen Alpine base
RUN apk add --no-cache maven

# Copiar descriptor pom.xml para cachear dependencias
COPY pom.xml .

# Descargar dependencias en modo offline para acelerar builds subsiguientes
RUN mvn dependency:go-offline -B

# Copiar el codigo fuente
COPY src ./src

# Empaquetar la aplicacion (las pruebas unitarias se ejecutan en el pipeline CI)
RUN mvn clean package -DskipTests

# ==============================================================================
# ETAPA 2: RUNTIME
# Entorno de ejecucion liviano con eclipse-temurin:21-jre-alpine y usuario no root
# ==============================================================================
FROM eclipse-temurin:21-jre-alpine AS runtime

WORKDIR /app

# Crear grupo y usuario sin privilegios para seguridad (Principio de menor privilegio)
RUN addgroup -S spring && adduser -S spring -G spring

# Copiar el ejecutable JAR desde la etapa builder
COPY --from=builder /app/target/*.jar app.jar

# Establecer la propiedad del archivo y cambiar al usuario no root
RUN chown spring:spring /app/app.jar
USER spring:spring

# Exponer el puerto estandar del contenedor
EXPOSE 8080

# Punto de entrada para iniciar la aplicacion Spring Boot
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
