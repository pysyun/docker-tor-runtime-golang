FROM golang:alpine
RUN apk upgrade && \
    apk add tor && \
    apk add curl && \
    apk add git  && \
    rm -rf /var/cache/apk/*

RUN echo "#!/bin/sh" >> /commandRun.sh && \
    echo "iptables -F" >> /commandRun.sh && \
    echo "iptables -P INPUT ACCEPT" >> /commandRun.sh && \
    echo "iptables -P OUTPUT ACCEPT" >> /commandRun.sh && \
    echo "iptables -P FORWARD ACCEPT" >> /commandRun.sh && \
    echo "iptables -P INPUT DROP" >> /commandRun.sh && \
    echo "iptables -P OUTPUT DROP" >> /commandRun.sh && \
    echo "iptables -A INPUT -p tcp -i lo --dport 9050 -j ACCEPT" >> /commandRun.sh && \
    echo "iptables -A OUTPUT -p tcp -o lo --sport 9050 -j ACCEPT" >> /commandRun.sh && \
    echo "iptables -A OUTPUT -p tcp -j ACCEPT" >> /commandRun.sh && \
    echo "iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /commandRun.sh && \
    echo "tor --RunAsDaemon 1" >> /commandRun.sh && \
    echo "exec \"\$@\"" >> /commandRun.sh && \
    chmod +x /commandRun.sh && \
    go get golang.org/x/net/proxy

ENTRYPOINT ["/commandRun.sh"]
