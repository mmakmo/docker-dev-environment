FROM cypress/browsers:chrome63-ff57

# firefox --version
# $(npm bin)/cypress run --browser chrome
# $(npm bin)/cypress run --browser firefox
# $(npm bin)/cypress run -s cypress/integration/xxx_spec.js


RUN \
    mkdir -p /root/src/cypress &&\
    apt-get update &&\
    apt-get install -y locales locales-all task-japanese fonts-ipafont &&\
    apt-get autoclean -y &&\
    apt-get autoremove -y

ENV LC_ALL ja_JP.utf8
ENV LANG ja_JP.utf8
ENV LANGUAGE ja_JP.utf8
WORKDIR /root/

RUN \
    locale-gen --purge $LANG &&\
    dpkg-reconfigure -f noninteractive locales && /usr/sbin/update-locale LANG=$LANG LC_ALL=$LANG &&\
    npm i cypress

WORKDIR /root/src/cypress

CMD tail -f /dev/null
