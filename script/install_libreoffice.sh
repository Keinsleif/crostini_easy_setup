#!/bin/bash

function abort {
    echo -e "\e[1;31m$@\e[0m" 1>&2
    exit 1
}

function info {
    echo -e "\e[1;32m$@\e[0m"
}

function caution {
    echo -e "\e[1;31m$@\e[0m"
}

function usage {
	echo "Usage: $0 [command]"
	echo
	echo "commands:"
	echo "    install - install Libreoffice (Default)"
	echo "    uninstall - uninstall Libreoffice"
    echo "    help - show this message and exit"
}

function install_libreoffice {
    info "バージョン情報を取得しています..."
    avail_versions=(`curl -fsSL https://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/ | grep "\[DIR\]" | sed -r "s@<img.*?href=\"(.*?)/\".*?-@\1@" | xargs`)
    LO_VERSION=${avail_versions[-1]}
    #LO_VERSION="7.1.4"

    info "バージョン\"${LO_VERSION}\"をインストールします。"

    info "LibreOfficeを取得しています(数分)..."
    if [ -f /tmp/libreoffice.tar.gz ]; then
        curl -# "https://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/${LO_VERSION}/deb/x86_64/LibreOffice_${LO_VERSION}_Linux_x86-64_deb.tar.gz" -C - -o /tmp/libreoffice.tar.gz || abort "ダウンロードが中断されました"
    else
        curl -# "https://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/${LO_VERSION}/deb/x86_64/LibreOffice_${LO_VERSION}_Linux_x86-64_deb.tar.gz" -o /tmp/libreoffice.tar.gz || abort "ダウンロードが中断されました"
    fi
    if [ -f /tmp/libreoffice_lang.tar.gz ]; then
        curl -# "https://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/${LO_VERSION}/deb/x86_64/LibreOffice_${LO_VERSION}_Linux_x86-64_deb_langpack_ja.tar.gz" -C - -o /tmp/libreoffice_lang.tar.gz || abort "ダウンロードが中断されました"
    else
        curl -# "https://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/${LO_VERSION}/deb/x86_64/LibreOffice_${LO_VERSION}_Linux_x86-64_deb_langpack_ja.tar.gz" -o /tmp/libreoffice_lang.tar.gz || abort "ダウンロードが中断されました"
    fi

    info "LibreOfficeを解凍しています..."
    cd /tmp
    tar xf libreoffice.tar.gz
    tar xf libreoffice_lang.tar.gz

    info "フォントをインストールしています..."
    sudo apt install -y fonts-takao
    #sudo apt install fonts-ipafont fonts-ipaexfont fonts-mplus

    info "LibreOfficeをインストールしています..."
    sudo apt install /tmp/LibreOffice_${LO_VERSION}*_Linux_x86-64_deb*/DEBS/*.deb

    rm -rf /tmp/LibreOffice_${LO_VERSION}*_Linux_x86-64_deb*
    rm -f /tmp/libreoffice*.tar.gz
    info "インストールが完了しました。\n"
    caution "ターミナルアプリを右クリックし、Linuxをシャットダウンしてください。"
    caution "その後、再度ターミナルを開いてください。"
    while true
    do
        sleep 365d
    done
}

function uninstall_libreoffice {
    sudo apt remove libreoffice* -y
    info "Libreofficeは正常にアンインストールされました"
}

if [ ! -z "$1" ]; then
    CMD="$1"
fi

case $CMD in
	install)    install_libreoffice
		;;
	uninstall)
        read -p "アンインストールを開始します。よろしいですか? (y/N): " yn
        case "$yn" in
            [yY]*) uninstall_libreoffice;;
            *) info "中止しました";;
        esac
        ;;
	help)	usage
		;;
	* )	install_libreoffice
		;;
esac