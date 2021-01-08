FROM debian:buster-slim

# copy install script
COPY install /tmp/

# add latest Duo bins
ADD https://dl.duosecurity.com/duoauthproxy-latest-src.tgz /tmp/

# install dependend packages
RUN \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    python-dev \
    python3-dev \
    python3 \
    libffi-dev \
    libssl-dev \
    perl \
    zlib1g-dev

# run install script 
RUN \   
    chmod +x /tmp/install && \
    ./tmp/install

RUN \    
    DEBIAN_FRONTEND=noninteractive apt-get remove --purge -y \
    build-essential \
    python-dev \
    python3-dev \
    libffi-dev \
    libssl-dev \
    zlib1g-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

# expose radius port
EXPOSE 1812/udp

CMD ["/bin/bash"]
