# kusanagi-wp-cli-profile-cron-backup

ファイルやディレクトリの構成はrootユーザーで行い、実際の動作はkusanagiユーザーで行います。

## crontabには次のように記載（rootユーザーで crontab -u root -e ）

毎月の第一日曜日の朝３時２０分にwp-backup.shを実行  
20 03 1-7 * 0 /home/kusanagi/bksex_html/backup/wp-backup.sh  

### crontabテスト向け
毎分wp-backup.shを実行
*/1 * * * * /home/kusanagi/bksex_html/backup/wp-backup.sh
