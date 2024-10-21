# 開発用ドキュメント

## 実行サーバに入れたもの

```
libonig-dev
libonig5
libz3-4
silversearcher-ag
libgmp-dev
nginx
cmake
libgfortran5
libgcc-14-dev
libtinfo6
snapd
```

これは別枠だけど入れておくやつ

```
python3-venv
```

## nginx

```
# static/cloudflare_params を /etc/nginx/ に配置
# static/develop.wandbox.org.conf と static/wandbox.org.conf を /etc/nging/conf.d に配置
# ドメインの鍵はいい感じに作るか前の環境からコピーするかする
```

## certbot

```
sudo apt install snapd
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
# ここで Cloudflare の DNS を切り替える
# 既存のサイトは止まるので注意
sudo certbot --nginx
# Cloudflare 経由の場合は以下の方法を使う
# https://evt1.com/docs/cloudflare-letsencrypt/
```

## ufw

```
ufw allow 443
```

## その他

```
select-editor # vim を選択
```

```
# AWS CLI を入れる
# https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html を参考に
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# あらかじめ /opt/wandbox-data/script/ ディレクトリを作っておく
# static/archive.sh と static/remove-tmp.sh を /opt/wandbox-data/script/ に配置
# リモートに入って chmod +x /opt/wandbox-data/script/* しておく

# crontab で static/crontab の内容を設定
0 0 * * * /opt/wandbox-data/script/remove-tmp.sh
0 0 2 * * /opt/wandbox-data/script/archive.sh >/opt/wandbox/_log/lastlog.log 2>&1
```
