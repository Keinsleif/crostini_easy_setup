#!/bin/bash

function info {
    echo -e "\e[1;32m$@\e[0m"
}

function caution {
    echo -e "\e[1;31m$@\e[0m"
}

MOZC_URL="https://raw.githubusercontent.com/kazuto28/crostini_easy_setup/master/data/config1.db"

info "入力メゾットを設定しています..."
/usr/bin/fcitx-autostart
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
if [ -d ~/.config/mozc ]; then
    cp /tmp/config1.db ~/.config/mozc/
elif [ -d ~/.mozc ]; then
    cp /tmp/config1.db ~/.mozc/
else
    caution "mozc設定ファイルが見つかりません。エラー文とともに開発者に報告してください"
fi
rm /tmp/config1.db

mkdir -p ~/.config/gtk-3.0
echo -e "[Settings]\ngtk-theme-name=CrosAdapta\ngtk-font-name=Noto Sans CJK JP Regular 9" > ~/.config/gtk-3.0/settings.ini

echo -e "include \"/usr/share/themes/CrosAdapta/gtk-2.0/gtkrc\"\nstyle \"user-font\" {\n        font_name = \"Noto Sans CJK JP 9\"\n}\ngtk-font-name=\"Noto Sans CJK JP 9\"" > ~/.gtkrc-2.0

rm ~/.setup_linux2.sh
sed -i -e "s|bash $HOME/\.setup_linux2\.sh||" ~/.bashrc
info "インストールが終了しました\n"
caution "ターミナルアプリを右クリックし、Linuxをシャットダウンしてください。"
caution "その後、再度ターミナルを開いてください。"
while true
do
    sleep 365d
done