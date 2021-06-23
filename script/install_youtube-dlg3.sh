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

info "ファイルをダウンロードしています..."
curl -L# "https://raw.githubusercontent.com/kazuto28/youtube-dl-gui/master/dist/Youtube_DLG-0.4-py3-none-any.whl" -o /tmp/youtube-dlg.whl || abort "ダウンロードが中断されました"
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py || abort "ダウンロードが中断されました"

info "pipをインストールしています..."
sudo python3 /tmp/get-pip.py
sudo pip3 install -U pip setuptools wheel

info "Youtube-DLGをインストールしています..."
sudo pip3 install /tmp/youtube-dlg.whl

info "インストールが完了しました"
