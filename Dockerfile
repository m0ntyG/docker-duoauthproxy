FROM alpine:3.12

# add latest Duo bins
ADD https://dl.duosecurity.com/duoauthproxy-latest-src.tgz /tmp/

# install dependend packages
RUN \
    apk add --update --no-cache \
    supervisor \
    build-base \
    libffi-dev \
    perl \
    bash \
    shadow \
    zlib-dev

# run install script 
RUN \
    chsh -s /bin/bash && \
    exec /bin/bash && \
    adduser -S duo_authproxy_svc && \
    cd /tmp/ && \
    tar xzf duoauthproxy-*.tgz && \
    cd duoauthproxy-*-src && \
    make && \
    ./duoauthproxy-build/install --install-dir /opt/duoauthproxy --service-user duo_authproxy_svc && \
    rm -rf /tmp/duoauthproxy-*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# expose radius port
EXPOSE 1812/udp

CMD ["/usr/bin/supervisord"]
