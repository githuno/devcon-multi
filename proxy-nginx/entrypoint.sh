#!/bin/sh

# Signal handler for cleanup
cleanup() {
  echo ">> Cleaning up..."
  nginx -s stop
  kill -TERM "$tailscaled_pid" 2>/dev/null
  exit 0
}

# Set trap to catch signals and clean up
trap cleanup TERM INT

# tailscale
nohup tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 > /dev/null 2>&1 &
echo ">> 🎉tailscale.. start"
tailscaled_pid=$!

# 環境変数を置換
envsubst '$FE_REPO $FE_PORT $BE_REPO $BE_PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
envsubst '$FE_REPO $FE_PORT $BE_REPO $BE_PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Nginx をバックグラウンドで起動
nginx

# フォアグラウンドで無限ループを実行してコンテナが停止しないようにする
while true; do
  sleep 60 &
  wait $!
done
