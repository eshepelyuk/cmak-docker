

# Build Stage
FROM openjdk:8u131-jdk AS build

ENV KAFKA_MANAGER_VERSION=1.3.3.13

RUN echo "Building Kafka Manager" \
    && wget "https://github.com/yahoo/kafka-manager/archive/${KAFKA_MANAGER_VERSION}.tar.gz" -O kafka-manager-source.tar.gz \
    && mkdir kafka-manager \
    && tar -xzf kafka-manager-source.tar.gz -C /kafka-manager --strip-components=1 \
    && cd kafka-manager \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt \
    && ./sbt clean dist \
    && unzip -d ./builded ./target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip


# Container with application
FROM openjdk:8u131-jre-alpine
MAINTAINER Hleb Albau <hleb.albau@gmail.com>
VOLUME /kafka-manager/configuration

COPY --from=build /kafka-manager/builded /kafka-manager
ENTRYPOINT ["/kafka-manager-${KAFKA_MANAGER_VERSION}/bin/kafka-manager"]
