# kafka-manager-docker (CMAK)

[![Docker Stars](https://img.shields.io/docker/stars/hlebalbau/kafka-manager.svg?style=flat-square)](https://registry.hub.docker.com/v2/repositories/hlebalbau/kafka-manager/)
 [![Docker pulls](https://img.shields.io/docker/pulls/hlebalbau/kafka-manager.svg?style=flat-square)](https://registry.hub.docker.com/v2/repositories/hlebalbau/kafka-manager/)
[![Docker Automated build](https://img.shields.io/docker/automated/hlebalbau/kafka-manager.svg?maxAge=31536000&style=flat-square)](https://github.com/hlebalbau/kafka-manager/)

You are invited to contribute [new features, fixes, or updates](https://github.com/hleb-albau/kafka-manager-docker/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22), large or small; I am always thrilled to receive pull requests, and do my best to process them as fast as I can.

## Tags

Kafka Manager images come in two flavors:

- **stable:** Build from latest Kafka Manager repository release.
- **latest:** Periodically assembled master builds. Better not to use in production.

## How to use this image

[CMAK](https://github.com/yahoo/CMAK) uses Zookeeper only as storage for own settings.
I.e. Zookeeper only plays role of a local database.
CMAK is unable to detect Kafka cluster from provided Zookeper,
Kafka cluster settings must be provided explicitely.

It's recommended to always run dedicated Zookeeper instance to be used by CMAK.

Use `docker-compose` with following content:

```yaml
version: '3.6'
services:
  zk:
    image: zookeeper:latest
    restart: always
    environment:
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888;2181
  cmak:
    image: hlebalbau/kafka-manager:stable
    restart: always
    ports:
      - "9000:9000"
    environment:
      ZK_HOSTS: "zk:2181"
```

To quickly launch the file above, execute

```bash
$ curl -sL https://raw.githubusercontent.com/hleb-albau/kafka-manager-docker/master/examples/docker-compose-sample.yaml | \
    docker-compose -f - up
```

## Configuration

### CMAK application configuration

CMAK reads its configuration from file [/cmak/conf/application.conf](https://github.com/yahoo/CMAK/blob/master/conf/application.conf).
Every parameter could be overriden via JVM system property, i.e. `-DmyProp=myVal`.
Properties are passed to CMAK container via [docker arguments](https://docs.docker.com/engine/reference/builder/#cmd).

For example, to enable basic authentication and configure zookeeper hosts using `docker-compose`:

```yaml
version: '3.6'
services:
  zk:
    image: zookeeper:latest
    restart: always
    environment:
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888;2181
  cmak:
    image: hlebalbau/kafka-manager:stable
    restart: always
    command:
      - "-Dcmak.zkhosts=zk:2181"
      - "-DbasicAuthentication.enabled=true"
      - "-DbasicAuthentication.username=username"
      - "-DbasicAuthentication.password=password"
    ports:
      - "9000:9000"
```

To quickly launch the file above, execute

```bash
$ curl -sL https://raw.githubusercontent.com/hleb-albau/kafka-manager-docker/master/examples/docker-compose-override.yaml | \
    docker-compose -f - up
```

### Kafka clusters configuration

CMAK doesn't provide tools to preconfigure managed Kafka clusters from files.
It could be done either via HTTP API or via CMAK UI in browser.
This could be inconvenient for declarative configuration or GitOps flow.

To overcome the issue there exist standalone `cmak2zk` tool.
The information and usage examples could be found at [cmak2zk homepage](https://github.com/eshepelyuk/cmak-operator#standalone-cmak2zk-tool).

## Usage in Kubernetes

It is possible to use dedicated CMAK operator for installing and configuring CMAK in Kubernetes.
That operator uses this docker image as one of its component.

Installation instructions available at [CMAK operator homepage](https://github.com/eshepelyuk/cmak-operator).

## Issues

If you have any problems with or questions about this image, please contact us
through a [GitHub issue](https://github.com/hleb-albau/kafka-manager-docker/issues).
