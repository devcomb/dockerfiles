FROM arm64v8/debian

RUN apt-get update && \
    apt-get install -y wget && \
    wget -P /etc/ssl/certs/ https://github.com/containous/traefik/blob/master/script/ca-certificates.crt && \
    wget -P /usr/bin/ https://github.com/containous/traefik/releases/download/v1.3.0/traefik_linux-arm64 && \
    chmod u+x /usr/bin/traefik_linux-arm64 && \
    mkdir /usr/share/traefik && \
    wget -P /usr/share/traefik https://raw.githubusercontent.com/containous/traefik/master/traefik.sample.toml && \
    rm -rf /var/cache/apk/* && \
    apt-get remove -y wget && \
    apt-get autoremove -y

EXPOSE 80
ENTRYPOINT ["/traefik"]
