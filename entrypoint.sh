#!/bin/zsh

echo "start entrypoint.sh"
# 環境変数を設定 .zshrcに色々書いてるのでENVではなく.zshrcに書き込み
cd ~/dotfiles
git pull origin main &> /dev/null
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

cd /workspace

exec "$@"
