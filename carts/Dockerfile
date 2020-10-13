FROM maven:3-jdk-8 AS bimage
RUN mkdir -p /carts
COPY pom.xml ./carts
WORKDIR /carts
RUN mvn clean package

FROM java:openjdk-8-alpine

COPY --from=bimage /carts/target/*.jar ./app.jar
run chmod a+rx ./app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/urandom","-jar","./app.jar", "--port=80"]
