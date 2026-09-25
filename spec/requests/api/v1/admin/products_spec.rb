require "rails_helper"

RSpec.describe "Api::V1::Admin::Products", type: :request do
  describe "GET /api/v1/admin/products" do
    it "商品一覧を取得できる" do
      get "/api/v1/admin/products", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /api/v1/admin/products/:id" do
    it "商品詳細を取得できる" do
      get "/api/v1/admin/products/#{products(:one).id}", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/v1/admin/products" do
    it "SKU付きで商品を新規作成できる" do
      params = {
        product: {
          name: "新商品",
          status: "published",
          store_id: stores(:one).id,
          skus_attributes: [{ code: "NEW-001", price: 100, stock: 5 }]
        }
      }

      expect {
        post "/api/v1/admin/products", params: params, headers: auth_headers_for(users(:one)), as: :json
      }.to change(Product, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "SKUが無いと作成できない" do
      params = { product: { name: "SKU無し商品", status: "published" } }

      post "/api/v1/admin/products", params: params, headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/admin/products/:id" do
    it "商品名を更新できる" do
      patch "/api/v1/admin/products/#{products(:one).id}",
            params: { product: { name: "更新後の商品名" } },
            headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:success)
      expect(products(:one).reload.name).to eq("更新後の商品名")
    end
  end

  describe "DELETE /api/v1/admin/products/:id" do
    it "商品を削除できる" do
      product = Product.create!(
        name: "削除用商品",
        status: :published,
        skus_attributes: [{ code: "DEL-001", price: 100, stock: 1 }]
      )

      delete "/api/v1/admin/products/#{product.id}", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:no_content)
    end

    it "カートに入っているSKUを持つ商品は削除できない" do
      product = skus(:one).product # cart_items(:one) が参照しているSKUの商品

      delete "/api/v1/admin/products/#{product.id}", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
