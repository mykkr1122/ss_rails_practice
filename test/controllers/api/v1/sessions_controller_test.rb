require "test_helper"

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "ログイン成功時にAuthorizationヘッダーでJWTが発行される" do
    post "/api/v1/login", params: { email: users(:one).email, password: "password" }, as: :json

    assert_response :success
    assert response.headers["Authorization"].present?
    assert_equal users(:one).id, JSON.parse(response.body)["user"]["id"]
  end

  test "パスワードが違う場合は401を返す" do
    post "/api/v1/login", params: { email: users(:one).email, password: "wrong" }, as: :json

    assert_response :unauthorized
    assert response.headers["Authorization"].blank?
  end

  test "ログアウトするとトークンが失効する" do
    token = auth_headers_for(users(:one))["Authorization"]

    delete "/api/v1/logout", headers: { "Authorization" => token }
    assert_response :no_content

    get "/api/v1/orders", headers: { "Authorization" => token }
    assert_response :unauthorized
  end
end
