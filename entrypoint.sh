#!/bin/zsh

echo "start entrypoint.sh"
# 環境変数を設定 .zshrcに色々書いてるのでENVではなく.zshrcに書き込み
cd ~/dotfiles
git pull origin main &> /dev/null
echo 'export CC=/usr/bin/gcc' >> /home/$USERNAME/.zshrc
echo 'export CXX=/usr/bin/g++' >> /home/$USERNAME/.zshrc
echo 'export PROMPT="%F{yellow}[docker]%f %F{green}%n%f:%F{blue}%~%f$ "' >> /home/$USERNAME/.zshrc


cd /workspace

exec "$@"
