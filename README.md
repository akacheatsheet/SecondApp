# SecondApp

`iGameGod`（[https://igamegod.app/](https://igamegod.app/)）が組み込まれた、iOSアプリのサンプルプロジェクトです。

## インストール

- リポジトリを追加してインストール

    `Cydia`や`Sileo`に`https://akacheatsheet.vercel.app/`を追加してインストール

- Releaseからダウンロードしてインストール

    [Release](https://github.com/akacheatsheet/SecondApp/releases/)

- ソースコードからビルドしてインストール

    1. リポジトリをクローン

        ```bash
        git clone https://github.com/akacheatsheet/SecondApp.git
        cd SecondApp
        ```

    2. `Makefile`を編集して、以下の変数を設定
    
        1. `THEOS_DEVICE_IP`: デバイスのIPアドレス
        1. `THEOS_PACKAGE_SCHEME`: `rootless`環境の場合は`THEOS_PACKAGE_SCHEME = rootless`、それ以外はコメントアウトか削除
        1. `NoJB`: 非脱獄端末にインストールする場合は`NoJB = 1`、それ以外はコメントアウトか削除
        1. `PACKAGE_FORMAT`: `deb`か`ipa`を設定

    3. ビルドしてインストール

        ```bash
        make package install
        ```