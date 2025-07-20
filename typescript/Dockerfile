# ベースイメージを指定
FROM ubuntu:22.04

# 必要なパッケージをインストール
COPY apt-packages.txt /home/tmp/apt-packages.txt
RUN apt-get update && \
    xargs apt-get install -y --no-install-recommends < /home/tmp/apt-packages.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Node.jsのインストール（NodeSource経由）
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 引数としてユーザー情報を受け取る
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG CONTAINER_NAME
ENV CONTAINER_NAME=${CONTAINER_NAME}

# sudoをインストールしてユーザーとグループを作成
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /home/$USERNAME

USER $USERNAME

# dotfiles リポジトリをクローン
RUN git clone https://github.com/masahiro-kubota/dotfiles.git

# dotfiles ディレクトリに移動して install.sh を実行
WORKDIR /home/$USERNAME/dotfiles
RUN ./install.sh

# 作業ディレクトリを /workspace に設定
WORKDIR /workspace
RUN sudo chown $USERNAME:$USERNAME /workspace

# Node.js グローバルパッケージのインストール
RUN sudo npm install -g typescript ts-node @types/node yarn pnpm

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# zsh をデフォルトで起動
CMD ["zsh"]