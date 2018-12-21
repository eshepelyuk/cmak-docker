
### STAGE 1: Build ###
FROM openjdk:8u131-jdk AS build

ENV KAFKA_MANAGER_SOURCE=48bb088a7aca34960e1f1d40741e0876f010d54c
ENV KAFKA_MANAGER_VERSION=1.3.3.21

RUN echo "Building Kafka Manager" \
    && wget "https://github.com/yahoo/kafka-manager/archive/${KAFKA_MANAGER_SOURCE}.tar.gz" -O kafka-manager-sources.tar.gz \
    && mkdir /kafka-manager-source \
    && tar -xzf kafka-manager-sources.tar.gz -C /kafka-manager-source --strip-components=1 \
    && cd /kafka-manager-source \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt \
    && ./sbt clean dist \
    && unzip -d ./builded ./target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip \
    && mv -T ./builded/kafka-manager-${KAFKA_MANAGER_VERSION} /kafka-manager-bin


### STAGE 2: Package ###
FROM openjdk:8u131-jre-alpine
MAINTAINER Hleb Albau <hleb.albau@gmail.com>

RUN apk update && apk add bash
COPY --from=build /kafka-manager-bin /kafka-manager

VOLUME /kafka-manager/conf
ENTRYPOINT ["/kafka-manager/bin/kafka-manager"]
