FROM golang:alpine

RUN apk upgrade && \
    apk add tor && \
    apk add curl && \
    apk add git  && \
    apk add iptables && \
    apk add torsocks && \
    rm -rf /var/cache/apk/*

# Go dependency for making proxied HTTP calls
RUN go get golang.org/x/net/proxy

WORKDIR /home/golang-tor-runtime

RUN echo "#!/bin/sh" >> ./start.sh

# Clear all roles
# RUN echo "iptables -F" >> ./start.sh
# Set the policy: INPUT, OUTPUT, FORWARD -->> ACCEPT
# RUN echo "iptables -P INPUT ACCEPT" >> ./start.sh && \
#     echo "iptables -P OUTPUT ACCEPT" >> ./start.sh && \
#     echo "iptables -P FORWARD ACCEPT" >> ./start.sh
# Set the policy: INPUT, OUTPUT -->> DROP
# RUN echo "iptables -P INPUT DROP" >> ./start.sh && \
#     echo "iptables -P OUTPUT DROP" >> ./start.sh
# Allow accepting localhost TOR request
# RUN echo "iptables -A INPUT -p tcp -i lo --dport 9050 -j ACCEPT" >> ./start.sh
# Allow sending localhost TOR requests
# RUN echo "iptables -A OUTPUT -p tcp -o lo --sport 9050 -j ACCEPT" >> ./start.sh
# Transmitting our requests from localhost to the network
# RUN echo "iptables -A OUTPUT -p tcp -j ACCEPT" >> ./start.sh
# Keep established connections
# RUN echo "iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> ./start.sh

# Start the TOR daemon
RUN echo "tor --RunAsDaemon 1" >> ./start.sh && \
    echo "exec \"\$@\"" >> ./start.sh

RUN chmod +x ./start.sh
ENTRYPOINT ["./start.sh"]
