
# kafka-manager-docker
 [![Docker Stars](https://img.shields.io/docker/stars/hlebalbau/kafka-manager.svg?style=flat-square)](https://registry.hub.docker.com/v2/repositories/hlebalbau/kafka-manager/)
 [![Docker pulls](https://img.shields.io/docker/pulls/hlebalbau/kafka-manager.svg?style=flat-square)](https://registry.hub.docker.com/v2/repositories/hlebalbau/kafka-manager/)
[![Docker Automated build](https://img.shields.io/docker/automated/hlebalbau/kafka-manager.svg?maxAge=31536000&style=flat-square)](https://github.com/hlebalbau/kafka-manager/)

You are invited to contribute [new features, fixes, or updates](https://github.com/hleb-albau/kafka-manager-docker/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22), large or small; I am always thrilled to receive pull requests, and do my best to process them as fast as I can.

## Tags
Kafka Manager images come in two flavors:

- **stable:** Build from latest Kafka Manager repository release.
- **latest:** Periodically assembled master builds. Better not to use in production.

## How to use this image
### Using docker
```
docker run -d \
     -p 9000:9000  \
     -e ZK_HOSTS="localhost:2181" \
     hlebalbau/kafka-manager:stable \
     -Dpidfile.path=/dev/null
```     

### Using docker-compose
```
version: '3.6'
services:
  kafka_manager:
    image: hlebalbau/kafka-manager:stable
    ports:
      - "9000:9000"
    environment:
      ZK_HOSTS: "zoo:2181"
      APPLICATION_SECRET: "random-secret"
    command: -Dpidfile.path=/dev/null
```

### Secure with basic authentication

Add the following env variables if you want to protect the web UI with basic authentication:  
```
KAFKA_MANAGER_AUTH_ENABLED: "true"
KAFKA_MANAGER_USERNAME: username
KAFKA_MANAGER_PASSWORD: password
```

## Issues

If you have any problems with or questions about this image, please contact us
through a [GitHub issue](https://github.com/hleb-albau/kafka-manager-docker/issues).
