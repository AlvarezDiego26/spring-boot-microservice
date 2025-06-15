FROM maven:3.8.8-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21
WORKDIR /app

# ✅ Instala netcat (versión válida)
RUN apt-get update && apt-get install -y netcat-openbsd && apt-get clean

COPY --from=build /app/target/*demo-*.jar demo.jar
COPY wait-for-it.sh .

# Da permisos al script
RUN chmod +x wait-for-it.sh

EXPOSE 8080

# Espera a que MySQL esté disponible
ENTRYPOINT ["./wait-for-it.sh", "db:3306", "--", "java", "-jar", "demo.jar"]
