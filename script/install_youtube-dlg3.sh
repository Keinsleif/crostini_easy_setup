#!/bin/bash

function abort {
    echo -e "\e[1;31m$@\e[0m" 1>&2
    exit 1
}

function info {
    echo -e "\e[1;32m$@\e[0m"
}

function usage {
	echo "Usage: $0 [command]"
	echo
	echo "commands:"
	echo "    install - install Youtube-DL-Gui (Improved) (Default)"
	echo "    uninstall - uninstall Youtube-DL-Gui (Improved)"
    echo "    help - show this message and exit"
}

function install_ydlg {
    info "ファイルをダウンロードしています..."
    curl -L# "https://raw.githubusercontent.com/Keinsleif/youtube-dl-gui/master/packages/youtube-dlg_0.4-1~w2d0_all.deb" -o /tmp/youtube-dlg.deb || abort "ダウンロードが中断されました"
    curl -L# "http://ftp.jaist.ac.jp/debian/pool/main/p/python-pypubsub/python3-pubsub_4.0.3-4_all.deb" -o /tmp/python3-pubsub.deb || abort "ダウンロードが中断されました"

    info "インストールしています..."
    sudo apt install -y /tmp/python3-pubsub.deb /tmp/youtube-dlg.deb
    sudo apt-mark auto python3-pubsub

    sudo rm -f /tmp/youtube-dlg.deb /tmp/python3-pubsub.deb

    info "インストールが完了しました"
}

function uninstall_ydlg {
    sudo apt remove -y youtube-dlg
    sudo apt autoremove -y
}

if [ ! -z "$1" ]; then
    CMD="$1"
fi

case $CMD in
	install)    install_ydlg
		;;
	uninstall)
        read -p "アンインストールを開始します。よろしいですか? (y/N): " yn
        case "$yn" in
            [yY]*) uninstall_ydlg;;
            *) info "中止しました";;
        esac
        ;;
	help)	usage
		;;
	* )	install_ydlg
		;;
esac
