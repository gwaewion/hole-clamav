FROM alpine:latest
LABEL maintainer="gwaewion@gmail.com"
EXPOSE 10025
VOLUME /clamav

ENV MAIL_SERVER_ADDRESS 10.0.2.15

RUN apk update
RUN apk add acf-clamav clamsmtp clamav-libunrar
RUN sed -i "s/LogFile \/var\/log\/clamav\/clamd.log/LogFile \/clamav\/log\/clamd.log/" /etc/clamav/clamd.conf
RUN sed -i "s/#DatabaseDirectory \/var\/lib\/clamav/DatabaseDirectory \/clamav\/db/" /etc/clamav/clamd.conf
# RUN sed -i "s/#Foreground yes/Foreground yes/" /etc/clamav/clamd.conf
RUN sed -i "s/#ScanMail yes/ScanMail yes/" /etc/clamav/clamd.conf
RUN sed -i "s/OutAddress: 10026/OutAddress: "${MAIL_SERVER_ADDRESS}":10026/" /etc/clamsmtpd.conf
RUN sed -i "s/#Listen\: 0\.0\.0\.0\:10025/Listen\: 0\.0\.0\.0\:10025/" /etc/clamsmtpd.conf
RUN sed -i "s/ClamAddress\: \/var\/run\/clamav\/clamd.sock/ClamAddress\: \/run\/clamav\/clamd.sock/" /etc/clamsmtpd.conf
RUN sed -i "s/#Header: X-Virus-Scanned: ClamAV using ClamSMTP/Header\: X-Virus-Scanned\: ClamAV using ClamSMTP/" /etc/clamsmtpd.conf
RUN sed -i "s/#Action: drop/Action\: drop/" /etc/clamsmtpd.conf
RUN mkdir /run/clamav
RUN chown clamav:clamav /run/clamav
RUN freshclam -v 
COPY run.sh /root/

CMD ["sh", "/root/run.sh"]