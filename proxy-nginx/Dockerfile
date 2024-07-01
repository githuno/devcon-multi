FROM nginx:latest

ARG PROXY_REPO FE_REPO FE_PORT BE_REPO BE_PORT
ENV FE_REPO=${FE_REPO}
ENV FE_PORT=${FE_PORT}
ENV BE_REPO=${BE_REPO}
ENV BE_PORT=${BE_PORT}

COPY ./.devcontainer/${PROXY_REPO}/nginx.conf.template /etc/nginx/nginx.conf.template
COPY ./.devcontainer/${PROXY_REPO}/default.conf.template /etc/nginx/conf.d/default.conf.template

# 環境変数を置換するためのエントリポイントスクリプトを追加
COPY --chmod=764 ./.devcontainer/${PROXY_REPO}/entrypoint.sh /usr/bin/

# tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh \
    && mkdir /var/run/tailscale/

ENTRYPOINT ["entrypoint.sh"]
