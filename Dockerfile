FROM golang:alpine
RUN apk upgrade && \
    apk add tor && \
    apk add curl && \
    apk add git  && \
    apk add iptables && \
    apk add torsocks && \
    rm -rf /var/cache/apk/*
    
# Add Package proxy for our HTTP programm
RUN go get golang.org/x/net/proxy

# Clear all roles
RUN ptables -F
# Set the policy: INPUT, OUTPUT, FORWARD -->> ACCEPT
RUN iptables -P INPUT ACCEPT
RUN iptables -P OUTPUT ACCEPT
RUN iptables -P FORWARD ACCEPT
# Set the policy: INPUT, OUTPUT -->> DROP
RUN iptables -P INPUT DROP
RUN iptables -P OUTPUT DROP
# Allow take request on localhost from our program
RUN iptables -A INPUT -p tcp -i lo --dport 9050 -j ACCEPT
# Allow sending requests from our localhost
RUN iptables -A OUTPUT -p tcp -o lo --sport 9050 -j ACCEPT
# Retranslation our request from localhost to Network
RUN iptables -A OUTPUT -p tcp -j ACCEPT
# We will keep established connections
RUN iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

RUN echo "#!/bin/sh" >> /commandRun.sh && \
    echo "tor --RunAsDaemon 1" >> /commandRun.sh && \
    echo "exec \"\$@\"" >> /commandRun.sh && \
    chmod +x /commandRun.sh
    
ENTRYPOINT ["/commandRun.sh"]
