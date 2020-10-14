FROM  maven:3-jdk-8-slim AS bimage
RUN mkdir -p /queue
COPY . /queue
WORKDIR /queue
RUN mvn clean package

FROM java:openjdk-8-alpine
COPY --from=bimage /queue/target/*.jar ./app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/urandom","-jar","./app.jar", "--port=80"]

