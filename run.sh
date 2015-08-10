#!/bin/bash
chown apache:apache /app -R

echo "tracelyzer.access_key=${APPNETA_ACCESS_KEY}" > /etc/tracelytics.conf
/usr/sbin/appneta-config
/etc/init.d/tracelyzer start
curl https://api.tv.appneta.com/api-v2/assign_app -d key=$APPNETA_ACCESS_KEY -d hostname=$(hostname) -d appname=$APPNETA_APP_NAME
exec httpd -D FOREGROUND
