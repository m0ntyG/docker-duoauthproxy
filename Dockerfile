FROM debian:stable-slim as builder

WORKDIR /tmp/

# install dependend packages
RUN \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    libffi-dev \
    perl \
    zlib1g-dev

# add latest Duo bins
ADD https://dl.duosecurity.com/duoauthproxy-latest-src.tgz /tmp/

# run prep
RUN \
    tar xzf *.tgz && \
    rm *.tgz && \
    mv duoauthproxy-*-src/* . && \
    make

FROM debian:stable-slim

COPY --from=builder /tmp/duoauthproxy-build/ /tmp/

# run prep
RUN \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    supervisor
    
# run install script 
RUN \   
    ./tmp/install --install-dir /opt/duoauthproxy --service-user duo_authproxy_svc --log-group duo_authproxy_grp --create-init-script no && \
    rm -rf /tmp/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# expose radius port
EXPOSE 1812/udp

CMD ["/usr/bin/supervisord"]
