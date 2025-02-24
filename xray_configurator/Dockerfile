FROM alpine:latest

RUN apk add bash curl openssl unzip bind-tools

COPY xray_prepare.sh /xray_prepare.sh
RUN chmod +x /xray_prepare.sh

COPY Xray-linux-64.zip /xray.zip
RUN mkdir -p /etc/xray

COPY config.json /config.json 
COPY connstring.txt /connstring.txt 
COPY client.json /client.json

RUN mkdir -p /connection

CMD ["/xray_prepare.sh"]