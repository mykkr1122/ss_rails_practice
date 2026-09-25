require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "自分の注文一覧を取得できる" do
    get "/api/v1/orders", headers: auth_headers_for(users(:one))

    assert_response :success
    ids = JSON.parse(response.body).map { |o| o["id"] }
    assert_includes ids, orders(:one).id
    assert_not_includes ids, orders(:two).id
  end

  test "他人の注文詳細は取得できない" do
    get "/api/v1/orders/#{orders(:two).id}", headers: auth_headers_for(users(:one))

    assert_response :not_found
  end

  test "カートから注文を作成できる" do
    post "/api/v1/orders",
         params: { order: { customer_name: users(:one).name, customer_email: users(:one).email } },
         headers: auth_headers_for(users(:one)), as: :json

    assert_response :created
  end
end
