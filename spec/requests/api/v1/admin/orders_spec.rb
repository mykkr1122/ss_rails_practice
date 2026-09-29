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

  describe "GET /api/v1/admin/orders/:id" do
    it "レスポンスにお届け先住所・請求先住所が含まれる" do
      get "/api/v1/admin/orders/#{orders(:one).id}", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body["shipping_address"]["postal_code"]).to eq(orders(:one).shipping_address.postal_code)
      expect(body["billing_address"]["postal_code"]).to eq(orders(:one).billing_address.postal_code)
    end
  end
end
