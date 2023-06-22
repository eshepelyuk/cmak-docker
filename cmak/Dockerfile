# syntax=docker/dockerfile:1.3-labs
FROM openjdk:11.0.16-jre as build

ARG CMAK_VERSION

RUN <<EOF
    set -e
    curl -L https://github.com/yahoo/CMAK/releases/download/${CMAK_VERSION}/cmak-${CMAK_VERSION}.zip -o /tmp/cmak.zip
    unzip /tmp/cmak.zip -d /
    ln -s /cmak-$CMAK_VERSION /cmak
    rm -rf /tmp/cmak.zip
EOF

FROM openjdk:11.0.16-jre-slim
COPY --from=build /cmak /cmak
VOLUME /cmak/conf
ENV JAVA_OPTS=-XX:MaxRAMPercentage=80
WORKDIR /cmak
ENTRYPOINT ["/cmak/bin/cmak", "-Dpidfile.path=/dev/null", "-Dapplication.home=/cmak", ""]

