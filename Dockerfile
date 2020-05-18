FROM alpine:latest

RUN apk upgrade && \
    apk add tor && \
    apk add torsocks && \
    rm -rf /var/cache/apk/*
    
RUN echo "#!/bin/sh" >> /commandRun.sh && \
    echo "tor --RunAsDaemon 1" >> /commandRun.sh && \
    echo "exec \"\$@\"" >> /commandRun.sh && \
    chmod +x /commandRun.sh

ENTRYPOINT ["/commandRun.sh"]
