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
	echo "    install - install Wine (Default)"
	echo "    uninstall - uninstall Wine"
    echo "    help - show this message and exit"
}

function install_wine {
    sudo rm -f /tmp/winehq.key /tmp/Release.key /tmp/winetricks /tmp/wine.gpg

    info "ファイルをダウンロードしています..."
    curl -#sSL "https://dl.winehq.org/wine-builds/winehq.key" -o /tmp/winehq.key || abort "ダウンロードが中断されました"
    curl -#sSL "https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key" -o /tmp/Release.key || abort "ダウンロードが中断されました"
    curl -#sSL "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" -o /tmp/winetricks || abort "ダウンロードが中断されました"

    info "インストールの準備をしています..."
    sudo dpkg --add-architecture i386
    sudo mkdir -p /usr/local/share/keyrings
    sudo gpg --no-default-keyring --keyring /tmp/wine.gpg --import /tmp/winehq.key
    sudo gpg --no-default-keyring --keyring /tmp/wine.gpg --import /tmp/Release.key
    sudo gpg --no-default-keyring --keyring /tmp/wine.gpg --export --output /usr/local/share/keyrings/wine.gpg
    sudo bash -c "echo -e 'deb [signed-by=/usr/local/share/keyrings/wine.gpg] https://dl.winehq.org/wine-builds/debian/ buster main\ndeb [signed-by=/usr/local/share/keyrings/wine.gpg] https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./\n' >> /etc/apt/sources.list.d/wine.list"
    sudo apt update
    sudo apt upgrade -y

    info "Wineをインストールしています..."
    sudo apt install -y --install-recommends winehq-stable

    # This is required to use winetricks GUI (not necessary)
    #sudo apt install -y zenity

    info "Wineを設定しています..."
    info "ダイアログが出た場合は\"Install\"を押してください"
    sudo chmod +x /tmp/winetricks
    sudo mv /tmp/winetricks /usr/bin/
    echo 'export WINEARCH=win32 WINEPREFIX=~/.wine32' >> ~/.bashrc
    export WINEARCH=win32 WINEPREFIX=~/.wine32
    winetricks cjkfonts
    sudo rm -f /tmp/winehq.key /tmp/Release.key /tmp/winetricks
    sleep 5
    info "インストールが完了しました"
}

function uninstall_wine {
    sudo apt uninstall -y winehq-stable
    sudo apt autoremove -y
    sudo rm -rf /usr/bin/winetricks ~/.wine32 /etc/apt/sources.list.d/wine.list /usr/local/share/keyrings/wine.gpg
    sed -i "s@export WINEARCH=win32 WINEPREFIX=~/.wine32@@" ~/.bashrc
    sudo apt update
    info "アンインストールが完了しました"
}

if [ ! -z "$1" ]; then
    CMD="$1"
fi

case $CMD in
	install)    install_wine
		;;
	uninstall)
        read -p "アンインストールを開始します。よろしいですか? (y/N): " yn
        case "$yn" in
            [yY]*) uninstall_wine;;
            *) info "中止しました";;
        esac
        ;;
	help)	usage
		;;
	* )	install_wine
		;;
esac