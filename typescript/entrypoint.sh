#!/bin/bash
set -e

# エイリアスを定義
alias apt-install='sudo apt-get update && sudo apt-get install -y'

# エイリアスをzshでも使えるようにする
echo "alias apt-install='sudo apt-get update && sudo apt-get install -y'" >> ~/.zshrc

exec "$@"