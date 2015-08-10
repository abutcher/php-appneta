FROM fedora
MAINTAINER Andrew Butcher <abutcher@redhat.com>

RUN dnf install -y httpd php net-tools && \
    dnf clean all && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

# Install appneta tracelyzer & instrumentation
COPY appneta.repo /etc/yum.repos.d/appneta.repo
RUN curl -m 10 --retry 1 -o /etc/pki/rpm-gpg/RPM-GPG-KEY-appneta https://yum-static.appneta.com/RPM-GPG-KEY-appneta && \
    dnf install -y tracelyzer liboboe liboboe-devel libapache2-mod-oboe php-oboe && dnf clean all && \
    ln -s /usr/lib64/php-oboe/oboe_20090626.so /usr/lib64/php/modules/oboe.so && \
    curl -o /usr/lib64/httpd/modules/mod_oboe.so http://files.appneta.com/libapache2-mod-oboe/x64/mod_oboe-apache24.so
COPY oboe.conf /etc/httpd/conf.d/oboe.conf
COPY oboe.ini /etc/php.d/oboe.ini

EXPOSE 7831

# Configure /app folder with sample app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
ADD sample/ /app

# Add image configuration and scripts
ADD run.sh /run.sh

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
