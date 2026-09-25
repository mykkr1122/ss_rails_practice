require "test_helper"

class Api::V1::Admin::Orders::CompletionsControllerTest < ActionDispatch::IntegrationTest
  test "新規注文を完了にできる" do
    post "/api/v1/admin/orders/#{orders(:one).id}/completion", headers: auth_headers_for(users(:one))

    assert_response :success
    assert orders(:one).reload.status_complete?
  end

  test "完了済みの注文は再度完了にできない" do
    post "/api/v1/admin/orders/#{orders(:two).id}/completion", headers: auth_headers_for(users(:one))

    assert_response :unprocessable_entity
  end
end
