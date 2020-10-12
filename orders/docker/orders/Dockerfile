FROM maven:3.6.3-adoptopenjdk-11 AS base
RUN mkdir -p /usr/src/app/orders
COPY / /usr/src/app/orders
WORKDIR  /usr/src/app/orders
RUN mvn clean package


FROM weaveworksdemos/msd-java:jre-latest

COPY --from=base /app/source/target/*.jar ./app.jar

RUN	chown -R ${SERVICE_USER}:${SERVICE_GROUP} ./app.jar

USER ${SERVICE_USER}

ENTRYPOINT ["/usr/local/bin/java.sh","-jar","./app.jar", "--port=80"]
