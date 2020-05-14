FROM alpine:latest

RUN apk upgrade && \
    apk add tor && \
    rm -rf /var/cache/apk/*

RUN echo "Log notice stdout" >> /etc/torrc && \
    echo "SocksPort 0.0.0.0:9050" >> /etc/torrc

EXPOSE 9050

CMD ["sh", "-c", "tor -f /etc/torrc"]
