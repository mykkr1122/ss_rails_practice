require "rails_helper"

RSpec.describe "Api::V1::Orders", type: :request do
  describe "GET /api/v1/orders" do
    it "自分の注文一覧を取得できる" do
      get "/api/v1/orders", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:success)
      ids = JSON.parse(response.body).map { |o| o["id"] }
      expect(ids).to include(orders(:one).id)
      expect(ids).not_to include(orders(:two).id)
    end
  end

  describe "GET /api/v1/orders/:id" do
    it "他人の注文詳細は取得できない" do
      get "/api/v1/orders/#{orders(:two).id}", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/orders" do
    it "カートから注文を作成できる" do
      post "/api/v1/orders",
           params: { order: { customer_name: users(:one).name, customer_email: users(:one).email } },
           headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:created)
    end
  end
end
