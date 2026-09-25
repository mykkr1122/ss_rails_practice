require "test_helper"

class Api::V1::CartsControllerTest < ActionDispatch::IntegrationTest
  test "ログインユーザーは自分のカートを取得できる" do
    get "/api/v1/cart", headers: auth_headers_for(users(:one))

    assert_response :success
    assert_equal carts(:one).id, JSON.parse(response.body)["id"]
  end

  test "未ログインだと401になる" do
    get "/api/v1/cart"

    assert_response :unauthorized
  end
end
