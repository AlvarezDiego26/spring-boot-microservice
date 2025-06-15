FROM maven:3.8.8-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21
WORKDIR /app

# Instala netcat
RUN apt-get update && apt-get install -y netcat && apt-get clean

COPY --from=build /app/target/*demo-*.jar demo.jar
COPY wait-for-it.sh .

# Da permisos de ejecución al script
RUN chmod +x wait-for-it.sh

EXPOSE 8080

# Usa el script para esperar a MySQL antes de iniciar
ENTRYPOINT ["./wait-for-it.sh", "db:3306", "--", "java", "-jar", "demo.jar"]
