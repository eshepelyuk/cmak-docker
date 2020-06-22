
### STAGE 1: Build ###
FROM openjdk:11-jdk AS build

ENV KAFKA_MANAGER_SOURCE=3.0.0.5
ENV KAFKA_MANAGER_VERSION=3.0.0.5
ENV KAFKA_MANAGER_SRC_DIR=/kafka-manager-source
ENV KAFKA_MANAGER_DIST_FILE=$KAFKA_MANAGER_SRC_DIR/target/universal/cmak-$KAFKA_MANAGER_VERSION.zip

RUN echo "Building Kafka Manager" \
    && wget "https://github.com/yahoo/CMAK/archive/${KAFKA_MANAGER_SOURCE}.tar.gz" -O CMAK-sources.tar.gz \
    && mkdir $KAFKA_MANAGER_SRC_DIR \
    && tar -xzf CMAK-sources.tar.gz -C $KAFKA_MANAGER_SRC_DIR --strip-components=1 \
    && cd $KAFKA_MANAGER_SRC_DIR \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt

ADD robust_build.sh /
RUN chmod +x robust_build.sh && /robust_build.sh

### STAGE 2: Package ###
FROM openjdk:11-jre
MAINTAINER Hleb Albau <hleb.albau@gmail.com>

###RUN apk update && apk add bash
COPY --from=build /kafka-manager-bin /kafka-manager

VOLUME /kafka-manager/conf
ENV JAVA_OPTS=-XX:MaxRAMPercentage=80
##CMD ["/kafka-manager/bin/cmak", "-Dpidfile.path=/dev/null", "-Dapplication.home=/kafka-manager"]
ENTRYPOINT ["/kafka-manager/bin/cmak", "-Dpidfile.path=/dev/null", "-Dapplication.home=/kafka-manager", ""]

