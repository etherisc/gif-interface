#!/usr/bin/env bash

mkdir -p /home/vscode/.solcx/

if [[ $(uname -m) == 'aarch64' ]]; then
    wget -O /home/vscode/.solcx/solc-v0.8.2 https://github.com/nikitastupin/solc/raw/main/linux/aarch64/solc-v0.8.2
else
    wget -O /home/vscode/.solcx/solc-v0.8.2 https://binaries.soliditylang.org/linux-amd64/solc-linux-amd64-v0.8.2+commit.661d1103
fi

chmod 755 /home/vscode/.solcx/solc*
