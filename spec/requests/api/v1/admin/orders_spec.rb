require "rails_helper"

RSpec.describe "Api::V1::Admin::Orders", type: :request do
  describe "GET /api/v1/admin/orders" do
    it "ログインしていれば注文一覧を取得できる" do
      get "/api/v1/admin/orders", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:success)
    end

    it "未ログインだと401になる" do
      get "/api/v1/admin/orders"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
