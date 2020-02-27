BUILD_COUNTER=1
until (ls $KAFKA_MANAGER_DIST_FILE && exit 0) do 
    
    echo "Build count $BUILD_COUNTER"
    
    (cd $KAFKA_MANAGER_SRC_DIR \
    && ./sbt clean dist \
    && unzip -d ./builded ./target/universal/cmak-${KAFKA_MANAGER_VERSION}.zip \
    && mv -T ./builded/cmak-${KAFKA_MANAGER_VERSION} /kafka-manager-bin ; exit 0)
    
    BUILD_COUNTER=$((BUILD_COUNTER + 1))
    
    if [ $BUILD_COUNTER -gt 5 ]; then
        break
    fi
done

ls $KAFKA_MANAGER_DIST_FILE