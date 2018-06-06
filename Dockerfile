# Ubuntu 16.04 with Java 8 installed

FROM ubuntu:16.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean

COPY saiku-server /root/saiku-server/
COPY configure_ldap.sh /root/configure_ldap.sh
RUN chmod +x /root/configure_ldap.sh

CMD cd /root && ./configure_ldap.sh && saiku-server/start-saiku.sh && tail -f saiku-server/tomcat/logs/catalina.out
