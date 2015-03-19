FROM ubuntu:14.04
MAINTAINER Lyle Scott, III "lyle@digitalfoo.net"

ENV MYNETWORKS                      127.0.0.0/8 192.168.59.0/24
ENV SYSTEM_TIMEZONE                 UTC
ENV EMAIL                           username@gmail.com
ENV EMAILPASS                       abc123

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN echo ${SYSTEM_TIMEZONE} > /etc/timezone &&\                                    
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update

#>> Postfix setup
RUN apt-get -q -y install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules
# main.cf
RUN postconf -e smtpd_banner="\$myhostname ESMTP"
RUN postconf -e relayhost=[smtp.gmail.com]:587                                                   
RUN postconf -e smtp_sasl_auth_enable=yes                                                        
RUN postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd                            
RUN postconf -e smtp_sasl_security_options=noanonymous                                           
RUN postconf -e smtp_tls_CAfile=/etc/postfix/cacert.pem                                          
RUN postconf -e smtp_use_tls=yes
RUN postconf -e mynetworks="${MYNETWORKS}"

#>> Setup sasl to authenticate to Gmail.
# Provide a username/password to Gmail.
RUN echo '[smtp.gmail.com]:587    ${EMAIL}:${EMAILPASS}' > /etc/postfix/sasl_passwd
# Generate a BerkelyDB that will hash the sensitive information.
RUN postmap /etc/postfix/sasl_passwd
# No need to for plain-text passwords laying around, so remove it!
# Alternatively, you can chmod to 400 if you want to keep the file.
RUN rm /etc/postfix/sasl_passwd

#>> Setup syslog-ng to echo postfix log data to the screen
RUN apt-get install -q -y syslog-ng syslog-ng-core
# system() can't be used since Docker doesn't allow access to /proc/kmsg.
# https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
RUN sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf
# Avoid the error:
# Error setting capabilities, capability management disabled; error='Operation not permitted'
RUN sed -i 's/^#\(SYSLOGNG_OPTS="--no-caps"\)/\1/g' /etc/default/syslog-ng

#>> Cleanup
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 25

CMD ["su", "-c", "service syslog-ng start ; service postfix start ; sleep 3; tail -F /var/log/mail.log"]
