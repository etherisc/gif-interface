#!/bin/env bash

# Install required solidity compiler version
mkdir -p ~/.solcx/ 
wget -O ~/.solcx/solc-v0.8.2 https://binaries.soliditylang.org/linux-amd64/solc-linux-amd64-v0.8.2+commit.661d1103 
chmod 755 ~/.solcx/solc* 

# Retrieve brownie dependencies
export VERSION_OPEN_ZEPPELIN=4.7.3
wget -O /tmp/v${VERSION_OPEN_ZEPPELIN}.tar.gz https://github.com/OpenZeppelin/openzeppelin-contracts/archive/refs/tags/v${VERSION_OPEN_ZEPPELIN}.tar.gz 
mkdir -p ~/.brownie/packages/OpenZeppelin 
cd ~/.brownie/packages/OpenZeppelin 
tar xvfz /tmp/v${VERSION_OPEN_ZEPPELIN}.tar.gz 
mv openzeppelin-contracts-${VERSION_OPEN_ZEPPELIN} openzeppelin-contracts@${VERSION_OPEN_ZEPPELIN} 

# Install ganache
npm install --global ganache

# Install brownie
python3 -m pip install --user pipx
python3 -m pipx ensurepath 
pipx install eth-brownie

