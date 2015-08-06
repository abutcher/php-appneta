FROM fedora
MAINTAINER Andrew Butcher <abutcher@redhat.com>

RUN dnf install -y httpd php net-tools && \
    dnf clean all && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

# Add image configuration and scripts
ADD run.sh /run.sh

# Install appneta tracelyzer
ADD install_appneta.sh /install_appneta.sh
RUN chmod 755 /*.sh
RUN ./install_appneta.sh <APPNETA-KEY>
EXPOSE 7831

# Install appneta apache & php instrumentation
RUN dnf install -y libapache2-mod-oboe php-oboe && dnf clean all
RUN ln -s /usr/lib64/php-oboe/oboe_20090626.so /usr/lib64/php/modules/oboe.so
RUN curl -o /usr/lib64/httpd/modules/mod_oboe.so http://files.appneta.com/libapache2-mod-oboe/x64/mod_oboe-apache24.so
COPY oboe.conf /etc/httpd/conf.d/oboe.conf
COPY oboe.ini /etc/php.d/oboe.ini

# Configure /app folder with sample app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
ADD sample/ /app

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
