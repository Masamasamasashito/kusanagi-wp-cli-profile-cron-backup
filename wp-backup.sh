#!/bin/sh
# kusanagi wp profile backup by wp-cli
# Copyright (c) 2019 https://cocoro-mirai.co.jp Masatoshi Nishimura All rights reserved.

#このファイル自身のパスを取得
script_dir=$(cd $(dirname $0); pwd)

#プロファイルパスを取得
profile_path=${script_dir%/*}

#プロファイル名を取得
profile_name=${profile_path##*/}

#ドキュメントルート
documentroot="$profile_path/DocumentRoot"

#プロファイルディレクトリ内にbackupディレクトリを作る
#backup_dir="$profile_path/backup"
#mkdir -p $backup_dir

#backupディレクトリ内にファイル保管ディレクトリをつくる
#file_dir="$backup_dir/file"
#mkdir -p $file_dir

cd $documentroot

echo "[`date '+%Y-%m-%d %H:%M:%S'`] Start backup."

#wp-config.phpがプロファイルディレクトリにある場合、file_dirにコピー保管
if [ -e $profile_path/wp-config.php ]; then
  echo "[`date '+%Y-%m-%d %H:%M:%S'`] Copy wp-config.php to $file_dir"
  cp -r $profile_path/wp-config.php $file_dir/`date +%Y-%m-%d-%H-%M-%S-`wp-config.php
fi

#バックアップsqlファイルをwp-cliで取得してgzipしてfile_dirに保管
wp db export - | gzip > $file_dir/`date +%Y-%m-%d-%H-%M-%S-`$profile_name.sql.gz

#ドキュメントルート内の全ファイルを圧縮アーカイブしてfile_dirに保管
tar -zcvf $file_dir/`date +%Y-%m-%d-%H-%M-%S-`$profile_name.tar.gz $documentroot

#５分前よりも古いバックアップSQLファイルと圧縮バックアップファイルを削除（-mminを-mtimeに変えると５日前となります）
echo "[`date '+%Y-%m-%d %H:%M:%S'`] Delete BackupFiles."
find $file_dir -mmin +5 | xargs rm -fv

echo "[`date '+%Y-%m-%d %H:%M:%S'`] Finish backup."
