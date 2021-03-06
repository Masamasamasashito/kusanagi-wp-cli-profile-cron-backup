# kusanagi-wp-cli-profile-cron-backup

kusanagi上で動いているプロファイル別のワードプレスについて、同じLinuxマシン内でバックアッププラグインに頼らず、バックアップを定期自動取得するシェルスクリプトです。cronで月に１度バックアップの実行、６ヶ月前よりも古いバックアップファイルは全削除など、ドキュメントルートではなく、プロファイルディレクトリの階層でシンプルにバックアップの世代管理を行っています。wp db exportコマンドを使っているため、wp-cli必須となっています。

AWS EBSスナップショット、Azure Backup and Site Recovery 、ConohaVPSのイメージバックアップなど、各社基盤側の提供によるイメージバックアップ機能と合わせて使うことでバックアップの細かい世代管理の助けとなります。

実行権限をLinuxユーザーのkusanagiに絞る、ユーザーkusanagiはパスフレーズ・鍵認証だけ許可するなどセキュリティに気をつけて使うようにしてください。

## 設定

### 1.rootユーザーでkusanagiのLinuxにsshログイン
Linuxのパスワード認証の無効化やroot接続の無効化は既にできている前提で進めます。
ファイルやディレクトリの構成はrootユーザーで行い、実際の動作はkusanagiユーザーで行います。

### 2.ファイルを配置するプロファイルディレクトリへ移動

`cd /home/kusanagi/プロファイル名`

### 3.バックアップディレクトリを作る

`mkdir backup`

`cd ./backup`

### 4.wp-backup.shをコピー

`wget https://raw.githubusercontent.com/Masamasamasashito/kusanagi-wp-cli-profile-cron-backup/master/wp-backup.sh`

### 5.バックアップファイル達の保管用fileディレクトリをつくる

`mkdir file`

### 6.Linuxのユーザーkusanagi向けに所有者とグループを変える

`chown kusanagi:kusanagi wp-backup.sh file`

### 7.生成されたバックアップファイルの保存期間を決める

[wp-backup.sh](https://github.com/Masamasamasashito/kusanagi-wp-cli-profile-cron-backup/blob/master/wp-backup.sh)　の４３行目で -nmin（分単位） -ntime（日単位） と 数値 を変えてファイルの保存期間を決める。保存期間を過ぎたファイルは削除されます。

例）  
`find $file_dir -mtime +180 | xargs rm -fv`  
180日前よりも古いファイルを全削除

### 8.crontabを設定する

`crontab -e`

毎月の第一日曜日の朝３時２０分にwp-backup.shを実行

`20 03 1-7 * 0 /home/kusanagi/プロファイル名/backup/wp-backup.sh`

例）   
`*/1 * * * * /home/kusanagi/プロファイル名/backup/wp-backup.sh`  
毎分wp-backup.shを実行
