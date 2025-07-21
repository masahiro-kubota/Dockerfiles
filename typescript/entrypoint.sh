#!/bin/bash

echo "start entrypoint.sh"
cd ~/dotfiles || exit
git pull origin main

# ホストとdockerコンテナ内でprefixを変更する。
echo "set-option -g prefix C-a" >> ~/.tmux.conf

# 環境変数を設定 .zshrcに色々書いてるのでENVではなく.zshrcに書き込み
cat >> ~/.zshrc << 'EOL'
# コンパイラの設定
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++

# プロンプトの設定
export PROMPT="%F{yellow}[${CONTAINER_NAME}]%f %F{green}%n%f:%F{blue}%~%f$ "

# パッケージインストール用の関数定義
apt-add-install() {
    sudo apt-get install -y --no-install-recommends "$1" && \
    echo "$1" >> /home/$USERNAME/apt-packages.txt
}

# エイリアスの設定
alias apt-install='apt-add-install'
EOL

cd /workspace || exit

exec "$@"
