FROM nimlang/nim:0.19.0-alpine
WORKDIR /build/
COPY . /build/
RUN nimble build

FROM alpine:latest  
RUN apk --no-cache add openssl-dev ca-certificates
WORKDIR /root/
COPY --from=0 /build/slack_emoji_exporter .
CMD ["./slack_emoji_exporter"]  