FROM golang:alpine
RUN apk upgrade && \
    apk add tor && \
    apk add curl && \
    apk add git  && \
    rm -rf /var/cache/apk/*

RUN echo "#!/bin/sh" >> /commandRun.sh && \
    echo "tor --RunAsDaemon 1" >> /commandRun.sh && \
    echo "exec \"\$@\"" >> /commandRun.sh && \
    chmod +x /commandRun.sh && \
    go get golang.org/x/net/proxy

ENTRYPOINT ["/commandRun.sh"]
