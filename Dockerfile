FROM alpine:3.12

# add latest Duo bins
ADD https://dl.duosecurity.com/duoauthproxy-latest-src.tgz .

# install dependend packages
RUN \
    apk add --update --no-cache \
    supervisor \
    build-base \
    libffi-dev \
    perl \
    bash \
    zlib-dev

# run install script 
RUN \
    adduser -S duo_authproxy_svc

RUN \
    tar xzf duoauthproxy-*.tgz

RUN \
    cd duoauthproxy-*-src
    
RUN \
    make

RUN \
    ./duoauthproxy-build/install --install-dir /opt/duoauthproxy --service-user duo_authproxy_svc

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# expose radius port
EXPOSE 1812/udp

CMD ["/usr/bin/supervisord"]
