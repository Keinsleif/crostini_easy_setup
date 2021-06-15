#!/bin/bash

function abort
{
echo -e "\e[1;31m$@\e[0m" 1>&2
exit 1
}

function info
{
echo -e "\e[1;32m$@\e[0m"
}

info "インストールの準備をしています..."
sudo dpkg --add-architecture i386
curl -# https://dl.winehq.org/wine-builds/winehq.key -o /tmp/winehq.key || abort "ダウンロードが中断されました"
sudo apt-key add /tmp/winehq.key
sudo sh -c "echo 'deb https://dl.winehq.org/wine-builds/debian/ buster main' >> /etc/apt/sources.list.d/wine.list"

curl -# "https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key" -o /tmp/Release.key || abort "ダウンロードが中断されました"
sudo apt-key add /tmp/Release.key
sudo sh -c "echo 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./' >> /etc/apt/sources.list.d/wine.list"
sudo apt update
sudo apt upgrade -y

info "Wineをインストールしています..."
sudo apt install -y --install-recommends winehq-stable

# This is required to use winetricks GUI (not necessary)
#sudo apt install -y zenity

info "Wineを設定しています..."
info "ダイアログが出た場合は\"Install\"を押してください"
curl -# "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" -o /tmp/winetricks || abort "ダウンロードが中断されました"
sudo chmod +x /tmp/winetricks
sudo mv /tmp/winetricks /usr/bin/
sh -c "echo 'export WINEARCH=win32 WINEPREFIX=~/.wine32' >> ~/.bashrc"
source ~/.bashrc
#export WINEARCH=win32 WINEPREFIX=~/.wine32
winetricks cjkfonts
sleep 5
info "インストールが完了しました"