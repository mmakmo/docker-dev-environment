FROM alpine:latest

RUN \
    echo 'root:root' |chpasswd &&\
    addgroup user &&\
    adduser -S user -G user &&\
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers &&\
    echo 'user:user' | chpasswd &&\
    apk add --update busybox-suid bash openssh-client git

USER user
WORKDIR /home/user

RUN ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""

CMD tail -f /dev/null