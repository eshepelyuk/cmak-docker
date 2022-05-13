# CMAK (prev. Kafka Manager) and cmak2zk docker images

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
$ curl -sL https://raw.githubusercontent.com/eshepelyuk/cmak-docker/master/examples/docker-compose-sample.yaml | \
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
$ curl -sL https://raw.githubusercontent.com/eshepelyuk/cmak-docker/master/examples/docker-compose-override.yaml | \
    docker-compose -f - up
```

### Kafka clusters configuration with cmak2zk

CMAK doesn't provide tools to preconfigure managed Kafka clusters from files.
It could be done either via HTTP API or via CMAK UI in browser.
This could be inconvenient for declarative configuration or GitOps flow.

Its purpose is to take Kafka cluster configuration for CMAK in YAML format
and populate CMAK compatible config in Zookeeper.
This allows to avoid manual configuration of CMAK and provides better possibilities
to use CMAK in declarative configuration.

`cmak2zk` is distributed as [docker image](https://github.com/users/eshepelyuk/packages/container/package/dckr%2Fcmak2zk).

To check out available options, run the image without parameters.

```sh
docker run ghcr.io/eshepelyuk/dckr/cmak2zk:latest
```

Example `docker-compose` and Kafka cluster configuration are located at
[cmak2zk/examples](https://github.com/eshepelyuk/cmak-docker/tree/master/examples) directory.
One could run them using commands below.

```sh
curl -sLo clusters.yaml \
  https://raw.githubusercontent.com/eshepelyuk/cmak-docker/master/examples/clusters.yaml

curl -sLo docker-compose-cmak2zk.yaml \
  https://raw.githubusercontent.com/eshepelyuk/cmak-docker/master/examples/docker-compose-cmak2zk.yaml

docker-compose -f docker-compose-cmak2zk.yaml up
```

Wait for some time until components are stabilizing, it may take up to 5 mins.
Then, open your browser at http://localhost:9000.
There should be two pre-configured clusters, pointing to the same Kafka instance, running in Docker.

## Usage in Kubernetes

It is possible to use dedicated CMAK operator for installing and configuring CMAK in Kubernetes.
That operator uses this docker image as one of its component.

Installation instructions available at [CMAK operator homepage](https://github.com/eshepelyuk/cmak-operator).

