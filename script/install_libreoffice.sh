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
    avail_versions=(`printf "%s\n" "${avail_versions[@]}" | sort -n`)
    LO_VERSION=${avail_versions[$((${#a[@]}-2))]}
    if [ -f /usr/local/bin/libreoffice* ]; then
        a=(`/usr/local/bin/libreoffice* --version`)
        IFS=. v=(${a[1]})
        unset v[-1]
        version=`IFS="."; echo "${v[*]}"`
        ver_num=`IFS=""; echo "${v[*]}"`
        IFS=. v=($LO_VERSION)
        lo_ver=`IFS=""; echo "${v[*]}"`
        if [ "${version}" -ge "${LO_VERSION}" ]; then
            info "最新バージョンがすでにインストールされています"
            exit
        elif [ ${ver_num} -lt ${lo_ver} ]; then
            read -p "旧バージョンを削除し、最新版をインストールします。よろしいですか? (y/N): " yn
            case "$yn" in
                [yY]*)
                    uninstall_libreoffice
                    ;;
                *)
                    info "中止しました"
                    exit
                    ;;
            esac
        fi
    fi
    unset IFS

    info "バージョン\"${LO_VERSION}\"をインストールします。"

    info "LibreOfficeを取得しています(数分)..."
    if [ -f /tmp/libreoffice.tar.gz ]; then
        curl -# "https://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/${LO_VERSION}/deb/x86_64/LibreOffice_${LO_VERSION}_Linux_x86-64_deb.tar.gz" -C - -o /tmp/libreoffice_${LO_VERSION}.tar.gz || abort "ダウンロードが中断されました"
    else
        curl -# "https://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/${LO_VERSION}/deb/x86_64/LibreOffice_${LO_VERSION}_Linux_x86-64_deb.tar.gz" -o /tmp/libreoffice_${LO_VERSION}.tar.gz || abort "ダウンロードが中断されました"
    fi
    if [ -f /tmp/libreoffice_lang.tar.gz ]; then
        curl -# "https://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/${LO_VERSION}/deb/x86_64/LibreOffice_${LO_VERSION}_Linux_x86-64_deb_langpack_ja.tar.gz" -C - -o /tmp/libreoffice_lang_${LO_VERSION}.tar.gz || abort "ダウンロードが中断されました"
    else
        curl -# "https://ftp-srv2.kddilabs.jp/office/tdf/libreoffice/stable/${LO_VERSION}/deb/x86_64/LibreOffice_${LO_VERSION}_Linux_x86-64_deb_langpack_ja.tar.gz" -o /tmp/libreoffice_lang_${LO_VERSION}.tar.gz || abort "ダウンロードが中断されました"
    fi

    info "LibreOfficeを解凍しています..."
    cd /tmp
    tar xf libreoffice_${LO_VERSION}.tar.gz
    tar xf libreoffice_lang_${LO_VERSION}.tar.gz

    info "フォントをインストールしています..."
    sudo apt install -y fonts-takao
    #sudo apt install fonts-ipafont fonts-ipaexfont fonts-mplus

    info "LibreOfficeをインストールしています..."
    sudo apt install /tmp/LibreOffice_${LO_VERSION}*_Linux_x86-64_deb*/DEBS/*.deb

    rm -rf /tmp/LibreOffice_${LO_VERSION}*_Linux_x86-64_deb*
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