require "rails_helper"

RSpec.describe "Api::V1::Orders::Payments", type: :request do
  describe "GET /api/v1/orders/:order_id/payment" do
    it "自分の注文の支払い状況を取得できる" do
      get "/api/v1/orders/#{orders(:one).id}/payment", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/v1/orders/:order_id/payment" do
    it "支払いを実行すると注文がcompleteになる" do
      post "/api/v1/orders/#{orders(:one).id}/payment", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:success)
      expect(orders(:one).reload.status_complete?).to be true
    end

    it "支払い済みの注文に再度支払おうとするとエラーになる" do
      post "/api/v1/orders/#{orders(:two).id}/payment", headers: auth_headers_for(users(:two))

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "他人の注文には支払いできない" do
      post "/api/v1/orders/#{orders(:two).id}/payment", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:not_found)
    end
  end
end
