
### STAGE 1: Build ###
FROM openjdk:8-jdk AS build

ENV KAFKA_MANAGER_SOURCE=f671f1bf89368dbace4ce92f6f55b352ef4cc168
ENV KAFKA_MANAGER_VERSION=1.3.3.22
ENV KAFKA_MANAGER_SRC_DIR=/kafka-manager-source
ENV KAFKA_MANAGER_DIST_FILE=$KAFKA_MANAGER_SRC_DIR/target/universal/kafka-manager-$KAFKA_MANAGER_VERSION.zip

RUN echo "Building Kafka Manager" \
    && wget "https://github.com/yahoo/kafka-manager/archive/${KAFKA_MANAGER_SOURCE}.tar.gz" -O kafka-manager-sources.tar.gz \
    && mkdir $KAFKA_MANAGER_SRC_DIR \
    && tar -xzf kafka-manager-sources.tar.gz -C $KAFKA_MANAGER_SRC_DIR --strip-components=1 \
    && cd $KAFKA_MANAGER_SRC_DIR \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt

ADD robust_build.sh /
RUN chmod +x robust_build.sh && /robust_build.sh

### STAGE 2: Package ###
FROM openjdk:8-jre-alpine
MAINTAINER Hleb Albau <hleb.albau@gmail.com>

RUN apk update && apk add bash
COPY --from=build /kafka-manager-bin /kafka-manager

VOLUME /kafka-manager/conf
ENTRYPOINT ["/kafka-manager/bin/kafka-manager", "-Dpidfile.path=/dev/null", "-Dapplication.home=/kafka-manager"]
