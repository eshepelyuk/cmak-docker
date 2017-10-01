# kafka-manager-docker
Kafka Manager Docker Images Build.

Feel free to PRs and discussion.


### Using docker
```
docker run -d \
     -p 9000:9000  \
     -e ZK_HOSTS="localhost:2181" \
     hlebalbau/kafka-manager:latest \
     -Dpidfile.path=/dev/null
```     

### Using docker-compose
```
version: '3.3'
services:
  kafka_manager:
    image: hlebalbau/kafka-manager
    ports:
      - "9000:9000"
    environment:
      ZK_HOSTS: "zoo:2181"
      APPLICATION_SECRET: "random-secret"
    command: -Dpidfile.path=/dev/null
```

