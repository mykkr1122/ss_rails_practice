require "rails_helper"

RSpec.describe "Api::V1::Orders", type: :request do
  let(:address_params) do
    {
      shipping_address_attributes: { postal_code: "1000001", prefecture: "東京都", city: "千代田区", address_line: "1-1-1" },
      billing_address_attributes: { postal_code: "1000001", prefecture: "東京都", city: "千代田区", address_line: "1-1-1" }
    }
  end

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

    it "レスポンスにお届け先住所・請求先住所が含まれる" do
      get "/api/v1/orders/#{orders(:one).id}", headers: auth_headers_for(users(:one))

      body = JSON.parse(response.body)
      expect(body["shipping_address"]["postal_code"]).to eq(orders(:one).shipping_address.postal_code)
      expect(body["billing_address"]["postal_code"]).to eq(orders(:one).billing_address.postal_code)
    end
  end

  describe "POST /api/v1/orders" do
    it "カートから注文を作成できる" do
      post "/api/v1/orders",
           params: { order: { customer_name: users(:one).name, customer_email: users(:one).email, **address_params } },
           headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["shipping_address"]["postal_code"]).to eq("1000001")
      expect(body["billing_address"]["postal_code"]).to eq("1000001")
    end

    it "住所が無い場合はエラーになる" do
      post "/api/v1/orders",
           params: { order: { customer_name: users(:one).name, customer_email: users(:one).email } },
           headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "レスポンスに小計・消費税・合計・税率が含まれる" do
      skus(:one).update!(price: 105)

      post "/api/v1/orders",
           params: { order: { customer_name: users(:one).name, customer_email: users(:one).email, **address_params } },
           headers: auth_headers_for(users(:one)), as: :json

      body = JSON.parse(response.body)
      expect(body["subtotal"]).to eq(105)
      expect(body["tax"]).to eq(10)
      expect(body["total_price"]).to eq(115)
      expect(body["tax_rate"]).to eq(TaxRate::PERCENT)
    end
  end
end
