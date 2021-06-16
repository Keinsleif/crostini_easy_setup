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

YDLG_DIR=/usr/lib/python2.7/dist-packages/youtube_dl_gui

info "ファイルをダウンロードしています..."
curl -# http://ppa.launchpad.net/nilarimogard/webupd8/ubuntu/pool/main/y/youtube-dlg/youtube-dlg_0.4-1~webupd8~bionic9_all.deb -o /tmp/youtube-dlg.deb || abort "ダウンロードが中断されました"
curl -L# "https://github.com/kazuto28/crostini_easy_setup/raw/master/data/youtube-dlg.patch" -o /tmp/youtube-dlg.patch || abort "ダウンロードが中断されました"
curl -L# "https://github.com/kazuto28/crostini_easy_setup/raw/master/data/youtube_dl_gui.mo" -o /tmp/youtube_dl_gui.mo || abort "ダウンロードが中断されました"
curl -L# "https://github.com/kazuto28/crostini_easy_setup/raw/master/data/youtube-dlg_jp.patch" -o /tmp/youtube-dlg_jp.patch || abort "ダウンロードが中断されました"

info "インストールしています..."
sudo apt install -y /tmp/youtube-dlg.deb

info "Patchを適用しています..."
sudo patch $YDLG_DIR/mainframe.py < /tmp/youtube-dlg.patch

info "言語に日本語を追加しています..."
sudo mkdir -p $YDLG_DIR/locale/ja_JP/LC_MESSAGES
sudo cp /tmp/youtube_dl_gui.mo $YDLG_DIR/locale/ja_JP/LC_MESSAGES/
sudo patch $YDLG_DIR/optionsframe.py < /tmp/youtube-dlg_jp.patch

info "インストールが完了しました"
