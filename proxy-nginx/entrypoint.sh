#!/bin/sh

# 環境変数を置換
envsubst '$FE_REPO $FE_PORT $BE_REPO $BE_PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
envsubst '$FE_REPO $FE_PORT $BE_REPO $BE_PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Nginx を起動
exec nginx -g 'daemon off;'
