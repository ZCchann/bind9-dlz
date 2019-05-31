FROM centos:7

ARG BIND_PREFIX=/usr/local/named
ARG BIND_SYSDIR=/etc/named
ARG BIND_VERSION=9-12-2
ARG BIND_VERSION_DOT=9.12.2

# install bind9
RUN yum install -y gcc make perl-devel openssl-devel mysql-devel libxml2-devel wget gettext sysvinit-tools  \
    && curl -L https://www.isc.org/downloads/file/bind-${BIND_VERSION}/?version=tar-gz -o /tmp/bind.tar.gz \
    && tar -zxvf /tmp/bind.tar.gz -C /tmp \
    && cd /tmp/bind-${BIND_VERSION_DOT} \
    && ./configure --prefix=${BIND_PREFIX} --sysconfdir=${BIND_SYSDIR} --with-dlz-mysql --enable-threads --enable-epoll --disable-chroot --enable-backtrace --enable-largefile --disable-ipv6 --with-openssl  --with-libxml2 \
    && make && make install \
    && cd contrib/dlz/modules/mysql \
    && make && make install \
    && cd /root && rm -rf /tmp/*

COPY named.conf ${BIND_SYSDIR}/named.conf.template
COPY start.sh /

# generate conf
RUN ${BIND_PREFIX}/sbin/rndc-confgen -r /dev/urandom > ${BIND_SYSDIR}/rndc.conf \
    && wget -O ${BIND_SYSDIR}/named.ca  http://www.internic.net/domain/named.root \
    && cd ${BIND_SYSDIR} \
    && tail -10 rndc.conf | head -9 | sed s/#\ //g > named.conf \
    && tail -n 60 ${BIND_SYSDIR}/named.conf.template >> ${BIND_SYSDIR}/named.conf \
    && mkdir /var/log/bind/ && touch /var/log/named.log \
    && chmod 755 /start.sh \
    && yum remove -y gcc make wget \
    && yum clean all

ENV mysql mysqldata
COPY entrypoint.sh /
EXPOSE 53/TCP 53/UDP 953 8053
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/start.sh"]
