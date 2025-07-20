#!/bin/bash
# devcontainer用の環境変数設定スクリプト

# 現在のユーザーのUID/GIDを環境変数として設定
echo "export UID=$(id -u)" >> ~/.bashrc
echo "export GID=$(id -g)" >> ~/.bashrc

# zshを使用している場合
if [ -f ~/.zshrc ]; then
    echo "export UID=$(id -u)" >> ~/.zshrc
    echo "export GID=$(id -g)" >> ~/.zshrc
fi

echo "UID and GID environment variables have been set."
echo "Please restart your shell or run 'source ~/.bashrc' (or 'source ~/.zshrc')"
