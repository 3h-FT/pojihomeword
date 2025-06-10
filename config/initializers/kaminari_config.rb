# frozen_string_literal: true

Kaminari.configure do |config|
  # デフォルトで取得するレコード数
   config.default_per_page = 10
  # 1ページでn個以上のデータは取得しない
  # config.max_per_page = nil
  # 表示するページのリンク数は4になる
   config.window = 3
  #最初と最後のページ番号のリンク数
   config.outer_window = 1
  #現在のページを中心とせず、左右に別のウィンドウを設定したい
  # config.left = 0
  # config.right = 0
  #モデルに対して .page(x) と書くとページネーションが動く。
   config.page_method_name = :page
  #ページ番号を受け取るパラメータ名。
   config.param_name = :page
  #最大ページ数の制限。
   config.max_pages = 100
  #最初のページ（page=1）のときに、URLに ?page=1 をつけるかどうか
  # config.params_on_first_page = false
end
