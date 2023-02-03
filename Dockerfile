FROM eclipse-temurin:17-jdk-jammy as builder


#Primera etapa Compilacion de binario PetClinic	
RUN mkdir -p /root/temp/
WORKDIR /root/temp/
RUN apt-get update -y && apt install -y --no-install-recommends git maven
RUN git clone https://github.com/dockersamples/spring-petclinic-docker
RUN cp -R spring-petclinic-docker/* ./
RUN mvn package

# Segunda etapa: ambiente minimo de ejecución

FROM openjdk:11 as runner
WORKDIR /app

# Copiar jar de la primera etapa
COPY --from=builder /root/temp/target/*.jar /app/app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]