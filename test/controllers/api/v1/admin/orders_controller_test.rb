require "test_helper"

class Api::V1::Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "ログインしていれば注文一覧を取得できる" do
    get "/api/v1/admin/orders", headers: auth_headers_for(users(:one))

    assert_response :success
  end

  test "未ログインだと401になる" do
    get "/api/v1/admin/orders"

    assert_response :unauthorized
  end
end
