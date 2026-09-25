require "test_helper"

class Api::V1::Orders::PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "自分の注文の支払い状況を取得できる" do
    get "/api/v1/orders/#{orders(:one).id}/payment", headers: auth_headers_for(users(:one))

    assert_response :success
  end

  test "支払いを実行すると注文がcompleteになる" do
    post "/api/v1/orders/#{orders(:one).id}/payment", headers: auth_headers_for(users(:one))

    assert_response :success
    assert orders(:one).reload.status_complete?
  end

  test "支払い済みの注文に再度支払おうとするとエラーになる" do
    post "/api/v1/orders/#{orders(:two).id}/payment", headers: auth_headers_for(users(:two))

    assert_response :unprocessable_entity
  end

  test "他人の注文には支払いできない" do
    post "/api/v1/orders/#{orders(:two).id}/payment", headers: auth_headers_for(users(:one))

    assert_response :not_found
  end
end
