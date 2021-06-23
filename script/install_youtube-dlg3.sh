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
curl -L# "https://raw.githubusercontent.com/kazuto28/youtube-dl-gui/master/dist/Youtube_DLG-0.4-py3-none-any.whl" -o /tmp/Youtube_DLG-0.4-py3-none-any.whl || abort "ダウンロードが中断されました"
curl -L# "https://bootstrap.pypa.io/get-pip.py" -o /tmp/get-pip.py || abort "ダウンロードが中断されました"

info "必要なパッケージをインストールしています..."
sudo apt install -y gettext python3-wxgtk4.0 python3-twodict python3-distutils
sudo python3 /tmp/get-pip.py
sudo pip3 install -U pip setuptools wheel
sudo pip3 install PyPubSub

info "Youtube-DLGをインストールしています..."
sudo pip3 install /tmp/Youtube_DLG-0.4-py3-none-any.whl

info "インストールが完了しました"
