FROM ubuntu:14.04
MAINTAINER Lyle Scott, III "lyle@digitalfoo.net"

ENV DEBIAN_FRONTEND noninteractive

USER root

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

#>> Setup syslog-ng to echo postfix log data to the screen
RUN apt-get install -q -y syslog-ng syslog-ng-core
# system() can't be used since Docker doesn't allow access to /proc/kmsg.
# https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
RUN sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf

RUN apt-get install -q -y supervisor
ADD supervisord.conf /etc/supervisor/
ADD init.sh /opt/init.sh

#>> Cleanup
RUN rm -rf /var/lib/apt/lists/* /tmp/*
RUN apt-get autoremove -y
RUN apt-get autoclean

EXPOSE 25

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
