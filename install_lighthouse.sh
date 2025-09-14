#! /bin/bash

ARCH=$(uname -m)
case $ARCH in
    x86_64)  PKG_TYPE="amd64" ;;
    aarch64|arm64) PKG_TYPE="arm64" ;;
    armv7l|armv8l) PKG_TYPE="armhf" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome-archive-keyring.gpg

echo "deb [arch=$PKG_TYPE signed-by=/usr/share/keyrings/google-chrome-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

apt update

apt install google-chrome-stable -y

npm install -g @lhci/cli@0.15.x

mkdir -p .lighthouseci