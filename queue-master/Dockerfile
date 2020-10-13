FROM  maven:3-jdk-8-slim AS bimage
RUN mkdir -p /queue
COPY pom.xml /queue
WORKDIR /queue
RUN mvn clean package

FROM weaveworksdemos/msd-java:jre-latest
COPY --from=bimage /queue/target/*.jar ./app.jar
RUN chmod a+rx ./app.jar

ENTRYPOINT ["/usr/local/bin/java.sh","-jar","./app.jar", "--port=80"]
