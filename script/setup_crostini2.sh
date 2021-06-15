#!/bin/bash

function info
{
echo -e "\e[1;32m$@\e[0m"
}

MOZC_URL="https://github.com/kazuto28/crostini_easy_setup/raw/master/data/config1.db"

info "入力メゾットを設定しています..."
cp ~/.config/fcitx/profile ~/.config/fcitx/profile.bak
sed -i -e "s/.*IMName=.*/IMName=mozc/g" ~/.config/fcitx/profile
sed -i -e "s/.*EnabledIMList=.*/EnabledIMList=fcitx-keyboard-jp:True,mozc:True,fcitx-keyboard-us:False/g" ~/.config/fcitx/profile
cp ~/.config/fcitx/conf/fcitx-xim.config ~/.config/fcitx/conf/fcitx-xim.config.bak
sed -i -e "s/.*UseOnTheSpotStyle=.*/UseOnTheSpotStyle=True/g" ~/.config/fcitx/conf/fcitx-xim.config

info "キー設定を変更しています..."
cp ~/.config/fcitx/config ~/.config/fcitx/config.bak
sed -i -e "s/.*TriggerKey=.*/TriggerKey=ZENKAKUHANKAKU/g" ~/.config/fcitx/config
sed -i -e "s/.*ActivateKey=.*/ActivateKey=HENKANMODE/g" ~/.config/fcitx/config
sed -i -e "s/.*InactivateKey=.*/InactivateKey=MUHENKAN/g" ~/.config/fcitx/config


#mozc
info "Mozc設定ファイルを取得しています..."
curl -L# $MOZC_URL -o /tmp/config1.db || abort "ダウンロードが中断されました"
cp /tmp/config1.db ~/.mozc/
rm /tmp/config1.db

mkdir -p ~/.config/gtk-3.0
echo -e "[Settings]\ngtk-theme-name=CrosAdapta\ngtk-font-name=Noto Sans CJK JP Regular 9" > ~/.config/gtk-3.0/settings.ini

echo -e "include \"/usr/share/themes/CrosAdapta/gtk-2.0/gtkrc\"\nstyle \"user-font\" {\n        font_name = \"Noto Sans CJK JP 9\"\n}\ngtk-font-name=\"Noto Sans CJK JP 9\"" > ~/.gtkrc-2.0

info "インストールが終了しました"
rm ~/.setup_linux2.sh
sed -i -e "s|bash $HOME/\.setup_linux2\.sh||" ~/.bashrc
info "５秒後に再起動します"
sleep 5
sudo /sbin/reboot