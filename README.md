![debian](https://github.com/andrestaffe/docker-duoauthproxy/workflows/debian/badge.svg)
![alpine](https://github.com/andrestaffe/docker-duoauthproxy/workflows/alpine/badge.svg)

# andrestaffe/duoauthproxy

Usage:
```
docker run -it -d --name duoauthproxy -p 1812:1812/udp \
-v ${PWD}/authproxy.cfg:/opt/duoauthproxy/conf/authproxy.cfg:ro \
--restart always \
andrestaffe/docker-duoauthproxy
```
