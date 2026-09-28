require "rails_helper"

RSpec.describe "Api::V1::Carts", type: :request do
  describe "GET /api/v1/cart" do
    it "ログインユーザーは自分のカートを取得できる" do
      get "/api/v1/cart", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["id"]).to eq(carts(:one).id)
    end

    it "未ログインだと401になる" do
      get "/api/v1/cart"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
