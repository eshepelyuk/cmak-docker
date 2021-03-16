ARG BUILDER_IMG_REPO=adoptopenjdk/openjdk11
ARG BUILDER_IMG_TAG=alpine-slim
ARG RELEASE_IMG_REPO=adoptopenjdk/openjdk11
ARG RELEASE_IMG_TAG=alpine-jre
FROM $BUILDER_IMG_REPO:$BUILDER_IMG_TAG AS Builder

ARG CMAK_VERSION="3.0.0.5"

RUN apk add --no-cache curl zip && \
    curl -L https://github.com/yahoo/CMAK/releases/download/${CMAK_VERSION}/cmak-${CMAK_VERSION}.zip -o /tmp/cmak.zip \
    && unzip /tmp/cmak.zip -d / \
    && ln -s /cmak-$CMAK_VERSION /cmak \
    && rm -rf /tmp/cmak.zip

FROM $RELEASE_IMG_REPO:$RELEASE_IMG_TAG
LABEL maintainer="Hleb Albau <hleb.albau@gmail.com>" 

COPY --from=Builder /cmak /cmak

VOLUME /cmak/conf

ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=80"

WORKDIR /cmak

# Add Tini
RUN apk add --no-cache tini bash

ENTRYPOINT ["/sbin/tini", "--", "/cmak/bin/cmak"]
CMD ["-Dpidfile.path=/dev/null", "-Dapplication.home=/cmak", ""]