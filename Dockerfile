FROM alpine:latest

RUN apk upgrade && \
    apk add tor && \
    apk add torsocks && \
    rm -rf /var/cache/apk/*

CMD ["sh", "-c", "tor"]
