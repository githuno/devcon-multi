ARG OS_VER
FROM ubuntu:${OS_VER}
# ------------------------------------------------------------------------------
ARG NODE_VER NVM_DIR REPO_NAME LOCALUNAME LOCALUPASS COMPOSE_PROJECT_NAME
ENV NODE_VER=$NODE_VER NVM_DIR=$NVM_DIR

# locale要求をスルー：https://qiita.com/mochi_yu2/items/af80a3adc7ff70e58807
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apt update && apt install -y --no-install-recommends \
    vim nano bash git wget curl sudo dumb-init ssh lsof \
    ca-certificates tzdata locales language-pack-ja \
   && apt clean \
   && rm -rf /var/lib/apt/lists/*

WORKDIR /workspaces/${COMPOSE_PROJECT_NAME}

# home shell group を設定
RUN useradd -m -s /bin/bash ${LOCALUNAME} -G sudo \
    && echo ${LOCALUNAME}:${LOCALUPASS} | chpasswd \
    && mkdir /run/user \
    && chown -R ${LOCALUNAME} /workspaces  /usr/local/ /run/user

COPY \
    --chown=${LOCALUNAME} \
    ./${REPO_NAME}/ ./

COPY \
    --chown=${LOCALUNAME} \
    ./.devcontainer/${REPO_NAME}/.bashrc /home/${LOCALUNAME}/

COPY \
    --chown=${LOCALUNAME} \
     --chmod=764 ./.devcontainer/${REPO_NAME}/entrypoint.sh /usr/bin/

# vscode-server:https://code.visualstudio.com/docs/remote/tunnels
# ubuntuでなければCPUアキテクチャの確認とURLの変更が必要かも
RUN mkdir /lib/vsc-sv \
    && curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output /lib/vsc-sv/vscode_cli.tar.gz \
    && tar -xf /lib/vsc-sv/vscode_cli.tar.gz -C /lib/vsc-sv/ \
    && rm /lib/vsc-sv/vscode_cli.tar.gz

# tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh \
    && mkdir /var/run/tailscale/ \
    && chown ${LOCALUNAME}:${LOCALUNAME} -R /var/run/tailscale/

USER ${LOCALUNAME}

# nvm
RUN mkdir ${NVM_DIR} \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install ${NODE_VER} \
    && nvm install-latest-npm
