#!/bin/sh
echo "🔥 entrypoint.sh is running!" 
set -e

# データベースが利用可能になるまで待機（最大30秒）
until pg_isready -h db -U $DB_USER -d $DB_NAME; do
  echo "データベース待機中..."
  sleep 2
done

# 必要なGemがインストールされているか確認し、なければインストール
bundle check || { echo "Bundle install failed!"; exit 1; }

# 以前のサーバープロセスのPIDファイルを削除
rm -f tmp/pids/server.pid

# データベースのセットアップ（本番および開発環境）
if [ "$RAILS_ENV" = "production" ]; then
  echo "Running migrations in production"
  bundle exec rails db:migrate
fi

# 指定されたコマンド（Rails サーバーなど）を実行
exec "$@"