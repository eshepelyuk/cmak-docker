until (ls $KAFKA_MANAGER_DIST_FILE && exit 0) do 
    (cd $KAFKA_MANAGER_SRC_DIR \
    && ./sbt clean dist \
    && unzip -d ./builded ./target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip \
    && mv -T ./builded/kafka-manager-${KAFKA_MANAGER_VERSION} /kafka-manager-bin ; exit 0)
done