# Build Geth in a stock Go builder container
FROM golang:1.16-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

RUN git clone https://github.com/Ether1Project/Ether1.git /go-etho
RUN cd /go-etho && make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-etho/build/bin/geth /usr/local/bin/

EXPOSE 8545 30305 30305/udp
ENTRYPOINT ["geth"]

