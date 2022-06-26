# crostini_easy_setup
Crostiniの超簡単セットアップスクリプト(sh)

## Crostini Setup
ChromebookのLinux,Crostiniを日本語でセットアップするスクリプトです。
日本語にLInuxを設定し、日本語入力できるようにします。
```
curl -L https://bit.ly/3xpRazQ | bash
```

## LibreOffice Setup
Libreofficeをセットアップするスクリプトです。
```
curl -L https://bit.ly/3pXMizj | bash
```

## Youtube DL GUI Setup (Deprecated)
Youtubeダウンローダーをセットアップするスクリプトです。
最新のCrostini(bullseye以降)では動作しません。
```
curl -L https://bit.ly/3pZBiRX | bash
```

## Youtube DL GUI (Improved) Setup
Youtube-DL-GUIの強化版(自作)です。  
Python3で書かれている他、動画と同じように画質選択ができるようになりました。
```
curl -L https://bit.ly/3xW9GjB | bash
```

## Wine Setup (Experimental)
Windowsのアプリを動かすソフトであるWineをセットアップします。  
注意:)結構容量を食います。最後のセットアップを失敗することがあります。
```
curl -L https://bit.ly/3gCGsPB | bash
```
# Uninstall
```
curl -L {各項目のURL} | bash -s -- uninstall
```