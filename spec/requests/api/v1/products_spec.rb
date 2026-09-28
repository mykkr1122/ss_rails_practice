require "rails_helper"

RSpec.describe "Api::V1::Products", type: :request do
  describe "GET /api/v1/products" do
    it "未ログインでも公開商品の一覧が取得できる" do
      get "/api/v1/products"

      expect(response).to have_http_status(:success)
      ids = JSON.parse(response.body).map { |p| p["id"] }
      expect(ids).to include(products(:one).id)
      expect(ids).not_to include(products(:two).id)
    end
  end

  describe "GET /api/v1/products/:id" do
    it "未ログインでも公開商品の詳細が取得できる" do
      get "/api/v1/products/#{products(:one).id}"

      expect(response).to have_http_status(:success)
    end

    it "非公開商品の詳細は404になる" do
      get "/api/v1/products/#{products(:two).id}"

      expect(response).to have_http_status(:not_found)
    end
  end
end
