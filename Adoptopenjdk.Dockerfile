ARG BUILDER_IMG_REPO=adoptopenjdk
ARG BUILDER_IMG_TAG=11-jre
ARG RELEASE_IMG_REPO=adoptopenjdk
ARG RELEASE_IMG_TAG=11-jre
FROM $BUILDER_IMG_REPO:$BUILDER_IMG_TAG AS Builder

ARG CMAK_VERSION="3.0.0.5"

RUN apt update -y && \
    apt install -y zip && \
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
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--","/cmak/bin/cmak"]
CMD ["-Dpidfile.path=/dev/null", "-Dapplication.home=/cmak", ""]