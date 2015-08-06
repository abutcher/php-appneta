#!/bin/bash
chown apache:apache /app -R

if [ "$ALLOW_OVERRIDE" = "**False**" ]; then
    unset ALLOW_OVERRIDE
else
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf
fi

/usr/sbin/appneta-config
/etc/init.d/tracelyzer start
exec httpd -D FOREGROUND
