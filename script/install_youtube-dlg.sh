#!/bin/bash

function abort {
	echo -e "\e[1;31m$@\e[0m" 1>&2
	exit 1
}

function info {
	echo -e "\e[1;32m$@\e[0m"
}

function confirm {
	read -p "\e[1;31m$@\e[0m(y/n)" YN
}

YDLG_DIR=/usr/lib/python2.7/dist-packages/youtube_dl_gui

function usage {
	echo "Usage: $0 [command]"
	echo
	echo "commands:"
	echo "    install - install Youtube-DL-Gui (Default)"
	echo "    uninstall - uninstall Youtube-DL-Gui"
	echo "    help - show this message and exit"
}

function install_ydlg {
	info "ファイルをダウンロードしています..."
	curl -# "http://ppa.launchpad.net/nilarimogard/webupd8/ubuntu/pool/main/y/youtube-dlg/youtube-dlg_0.4-1~webupd8~bionic9_all.deb" -o /tmp/youtube-dlg.deb || abort "ダウンロードが中断されました"
	curl -L# "https://raw.githubusercontent.com/kazuto28/crostini_easy_setup/master/data/youtube-dlg.patch" -o /tmp/youtube-dlg.patch || abort "ダウンロードが中断されました"
	curl -L# "https://raw.githubusercontent.com/kazuto28/crostini_easy_setup/master/data/youtube_dl_gui.mo" -o /tmp/youtube_dl_gui.mo || abort "ダウンロードが中断されました"

	info "インストールしています..."
	sudo apt install -y /tmp/youtube-dlg.deb
	sudo mkdir -p $YDLG_DIR/locale/ja_JP/LC_MESSAGES
	sudo cp /tmp/youtube_dl_gui.mo $YDLG_DIR/locale/ja_JP/LC_MESSAGES/

	info "Patchを適用しています..."
	sudo apt install patch
	sudo patch -d $YDLG_DIR -p1 < /tmp/youtube-dlg.patch

	sudo rm -f /tmp/youtube-dl_gui.mo /tmp/youtube-dlg.patch /tmp/youtube-dlg.deb

	info "インストールが完了しました"
}

function uninstall_ydlg {
	confirm "Youtube-DL-Guiをアンインストールします。よろしいですか？"
	if [ "${YN}" = "y" ]; then
		sudo apt remove -y youtube-dlg
		sudo apt autoremove -y
	else
		exit
	fi
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