FROM mcr.microsoft.com/vscode/devcontainers/go:latest

ARG USERNAME=vscode
ENV DEBIAN_FRONTEND noninteractive

ENV DISPLAY :0
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y --no-install-recommends build-essential manpages-dev \
    git unzip dosfstools curl wget vim sudo ssh tzdata ca-certificates \
    dbus dbus-x11 alsa-utils pulseaudio pulseaudio-utils mesa-utils x11-apps \
    && apt-get clean -y && rm -rf /var/lib/apt/lists

# ユーザーを作成
RUN useradd -ms /bin/bash builder

# ユーザー ${USERNAME} に切り替え
USER ${USERNAME}

# 必要な Go パッケージをインストール
RUN go install golang.org/x/tools/cmd/goimports@latest \
    && go install golang.org/x/tools/gopls@latest \
    && go install golang.org/x/tools/cmd/godoc@latest \
    && go install golang.org/x/lint/golint@latest \
    && go install github.com/rogpeppe/godef@latest \
    && go install github.com/nsf/gocode@latest \
    && go install github.com/cosmtrek/air@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest

# 作業ディレクトリの作成
RUN mkdir -p /home/${USERNAME}/workspace
WORKDIR /home/${USERNAME}/workspace

# スクリプトのコピー
USER root
COPY ./.devcontainer/backend/set_uid.sh /home/
COPY ./.devcontainer/backend/.inject_bashrc /root
RUN cat /root/.inject_bashrc >> /home/${USERNAME}/.bashrc

# エントリーポイントの設定
ENTRYPOINT ["/home/set_uid.sh"]
CMD ["/bin/sh", "-c", "echo Container started ; trap \"exit 0\" 15; while sleep 1 & wait $!; do :; done"]
