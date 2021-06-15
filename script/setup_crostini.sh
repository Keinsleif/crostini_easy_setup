#!/bin/bash

function info
{
echo -e "\e[1;32m$@\e[0m"
}

SND_URL="https://github.com/kazuto28/crostini_easy_setup/raw/master/script/setup_crostini2.sh"

info "必要なパッケージをインストールしています..."
sudo apt install -y debconf-i18n apt-utils locales wget

info "システムをアップデートしています..."
sudo apt update
sudo apt upgrade -y

info "システムを日本語に設定しています..."
sudo sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen
sudo locale-gen
sudo update-locale LANG=ja_JP.UTF-8

info "Fcitxをインストールしています..."
sudo apt install -y fcitx-mozc

## This is not necessary.
#info "フォントをインストールしています..."
#sudo apt install -y fonts-noto-cjk fonts-noto-cjk-extra

info "Fcitxを入力メゾットに設定しています..."
sudo sh -c "echo \"Environment=\\\"GTK_IM_MODULE=fcitx\\\"\nEnvironment=\\\"QT_IM_MODULE=fcitx\\\"\nEnvironment=\\\"XMODIFIRES=@im=fcitx\\\"\nEnvironment=\\\"GDK_BACKEND=x11\\\"\n\" >> /etc/systemd/user/cros-garcon.service.d/cros-garcon-override.conf"

echo "/usr/bin/fcitx-autostart" >> ~/.sommelierrc

curl -L# $SND_URL -o ~/.setup_linux2.sh || abort "ダウンロードが中断されました"
echo "bash $HOME/.setup_linux2.sh" >> ~/.bashrc

info "10秒後にシャットダウンします。"
info "再度、ターミナルを起動してください。"
sleep 10
sudo /sbin/reboot