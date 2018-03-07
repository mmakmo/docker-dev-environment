FROM java:9-jdk

RUN \
    ln -s /usr/lib/jvm/java-9-openjdk-amd64/lib /usr/lib/jvm/java-9-openjdk-amd64/conf

WORKDIR spring-boot-api

EXPOSE 8080 9000 5005

CMD tail -f /dev/null