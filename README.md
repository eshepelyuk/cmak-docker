# cmak-docker (CMAK)

## Usage

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
    image: ghcr.io/eshepelyuk/dckr/cmak-3.0.0.5:latest
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
    image: ghcr.io/eshepelyuk/dckr/cmak-3.0.0.5:latest
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

