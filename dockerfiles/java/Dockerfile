FROM ubuntu:latest
ARG java_version=8
RUN \
    apt-get update &&\
    apt-get install -y software-properties-common apt-utils &&\
    add-apt-repository -y ppa:webupd8team/java &&\
    apt-get update &&\
    #https://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option
    echo "oracle-java${java_version}-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections &&\
    apt-get install -y oracle-java${java_version}-installer &&\
    mkdir /application

WORKDIR /application

EXPOSE 8080 9000 5005

CMD tail -f /dev/null
