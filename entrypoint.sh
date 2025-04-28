#!/bin/sh
echo "🔥 entrypoint.sh is running!" 
set -e

# Secret Filesの.envをコピーして環境変数として使う
if [ -f /etc/secrets/.env ]; then
  echo "Copying .env from /etc/secrets"
  cp /etc/secrets/.env .env
fi

# 必要なGemがインストールされているか確認し、なければインストール
bundle check || bundle install

# 以前のサーバープロセスのPIDファイルを削除
echo "Removing server.pid"
rm -f tmp/pids/server.pid

# データベースのセットアップ（初回のみ）
if [ "$RAILS_ENV" = "production" ]; then
  echo "Running migrations in production"
  bundle exec rails db:migrate
fi

# サーバ起動前の処理
# マイグレーションを本番でも行う（開発環境では上でやっているので、ここは本番環境のみ）
if [ "$RAILS_ENV" != "production" ]; then
  echo "Running migrations in development"
  bundle exec rails db:migrate
fi

# 指定されたコマンド（Rails サーバーなど）を実行
exec "$@"