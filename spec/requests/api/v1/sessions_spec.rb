require "rails_helper"

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /api/v1/login" do
    it "ログイン成功時にAuthorizationヘッダーでJWTが発行される" do
      post "/api/v1/login", params: { email: users(:one).email, password: "password" }, as: :json

      expect(response).to have_http_status(:success)
      expect(response.headers["Authorization"]).to be_present
      expect(JSON.parse(response.body)["user"]["id"]).to eq(users(:one).id)
    end

    it "パスワードが違う場合は401を返す" do
      post "/api/v1/login", params: { email: users(:one).email, password: "wrong" }, as: :json

      expect(response).to have_http_status(:unauthorized)
      expect(response.headers["Authorization"]).to be_blank
    end
  end

  describe "DELETE /api/v1/logout" do
    it "ログアウトするとトークンが失効する" do
      token = auth_headers_for(users(:one))["Authorization"]

      delete "/api/v1/logout", headers: { "Authorization" => token }
      expect(response).to have_http_status(:no_content)

      get "/api/v1/orders", headers: { "Authorization" => token }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
