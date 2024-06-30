#!/bin/bash
set -e

echo ">>> USER: `id -un`"

# PATHの更新
PATH="${NVM_DIR}/versions/node/${NODE_VER}/bin:$PATH"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
echo ">>> PATH: $PATH"
echo ">>> CURRENT DIRECTORY: `pwd`"

# パッケージのインストール
echo "🔨 npm installing ..."
npm install
echo "🎉 npm installed !!"

# バックエンド接続

# vscodeの設定
echo "🔨 /run/user/{ID} creating ... for vscode"
export USER_ID=`id -u`
if [ ! -e "/run/user/${USER_ID}" ]; then
    mkdir /run/user/${USER_ID}
    echo "🎉 /run/user/{ID} created !!"
else
    echo "🎉 /run/user/{ID} is existence already !"
fi

# tailscale
nohup tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 > /dev/null 2>&1 &
echo ">> tailscale.. start"
tailscaled_pid=$!
# Wait for tailscaled to start
while ! pgrep -x "tailscaled" > /dev/null; do
    sleep 1
done
echo ">> 🎉 tailscaled started!!"

# code-server
# nohup /lib/vsc-sv/code serve-web --without-connection-token --accept-server-license-terms --host 0.0.0.0 --port ${PORT_CODE} > /dev/null 2>&1 &
# echo ">> code-server.. start"
# code_pid=$!
# # Wait for code-server to start
# while ! pgrep -x "code" > /dev/null; do
#     sleep 1
# done
# echo ">> 🎉 code-server started!!"

# Check if tailscaled or code-server exited with error
wait $tailscaled_pid
tailscaled_exit_status=$?

# wait $code_pid
# code_server_exit_status=$?

# If either tailscaled or code-server exited with error, exit container
# if [ $tailscaled_exit_status -ne 0 ] || [ $code_server_exit_status -ne 0 ]; then
#     echo "❌ Error: tailscaled or code-server exited with non-zero status. Exiting container..."
#     exit 1
# fi

echo "🎉🎉🎉 entrypoint.sh DONE !!!!"
exec "$@"
