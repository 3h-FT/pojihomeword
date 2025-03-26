require "test_helper"

class TopControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    # fixturesからユーザーを取得
    user = users(:one)

    # サインイン
    sign_in user

    # GETリクエストを送信
    get top_index_url

    # レスポンスが成功することを確認
    assert_response :success
  end
end
