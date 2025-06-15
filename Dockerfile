# Etapa de construcción
FROM maven:3.8.8-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa de ejecución
FROM eclipse-temurin:21
WORKDIR /app
COPY --from=build /app/target/*demo-*.jar demo.jar

# Copiar el script wait-for-it.sh
COPY wait-for-it.sh .
RUN chmod +x wait-for-it.sh

EXPOSE 8080
ENTRYPOINT ["./wait-for-it.sh", "db", "3306", "--", "java", "-jar", "demo.jar"]
