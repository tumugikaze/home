---
title: Linuxの初期セットアップメモ
description: sudoが使えるようになるまでの作業など
slug: linux-init
date: 2026-07-29 21:40:00+0900
image: 
categories:
    - Linux
tags:
    - Home lab
    - Memo
    - Linux
# weight: 1
---

タイトル通りの内容

よくVM作成後`sudo`が使えない場合に何をすればよかったか等、毎回調べていることのメモ


## sudo
1. sudoのインストール
    ```
    apt update && apt install passwd sudo -y
    ```

2. ユーザーをsudoに追加
    - Not Foundの場合は"/usr/sbin/usermod"等をフルパスで指定する
    ```
    usermod -aG sudo ユーザー名
    ```

3. visudoで設定確認・編集
    - こちらもNot Foundの場合は"/usr/sbin/visudo"等をフルパスで指定する
    ```
    EDITOR=vi visudo
    ```

4. %sudo～の行がコメントアウトされてないか確認する
    ```
    # Allow members of group sudo to execute any command
    %sudo   ALL=(ALL:ALL)   ALL
    ```