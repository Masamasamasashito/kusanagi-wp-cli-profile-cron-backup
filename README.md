# kusanagi-wp-cli-profile-cron-backup

kusanagi上で動いているワードプレスを同じLinuxマシン内でバックアップを定期自動化するためのシェルスクリプトです。
プロファイル別にcronでバックアップの実行、○ヶ月前よりも古いバックアップファイルの削除など、シンプルに世代管理を出来るようになっています。
##使い方

### 1.rootユーザーでkusanagiのLinuxにsshログイン
Linuxのパスワード認証の無効化やroot接続の無効化は既にできている前提で進めます。
ファイルやディレクトリの構成はrootユーザーで行い、実際の動作はkusanagiユーザーで行います。

### 2.ファイルを配置するプロファイルディレクトリへ移動

`cd /home/kusanagi/プロファイル名`

### 3.バックアップディレクトリを作る

`mkdir ./backup`

`cd ./backup`

### 4.wp-backup.shをコピー

`wget https://github.com/Masamasamasashito/kusanagi-wp-cli-profile-cron-backup/wp-backup.sh`

### 5.バックアップファイル達の保管用fileディレクトリをつくる

`mkdir file`

### 6.Linuxのユーザーkusanagi向けに所有者とグループを変える

`chown kusanagi:kusanagi wp-backup.sh file`

### 7.crontabを設定する

`crontab -e`

毎月の第一日曜日の朝３時２０分にwp-backup.shを実行

`20 03 1-7 * 0 /home/kusanagi/プロファイル名/backup/wp-backup.sh`

### 8.crontabテスト
毎分wp-backup.shを実行

`*/1 * * * * /home/kusanagi/プロファイル名/backup/wp-backup.sh`

