require "rails_helper"

RSpec.describe "Products", type: :request do
  describe "GET /products" do
    it "公開商品の一覧が表示される" do
      get products_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(products(:one).name)
    end

    it "非公開商品は表示されない" do
      get products_path

      expect(response.body).not_to include(products(:two).name)
    end
  end

  describe "GET /products/:id" do
    it "公開商品の詳細が表示できる" do
      get product_path(products(:one))

      expect(response).to have_http_status(:success)
      expect(response.body).to include(products(:one).name)
    end

    it "非公開商品の詳細は商品一覧へリダイレクトされる" do
      get product_path(products(:two))

      expect(response).to redirect_to(products_path)
    end
  end
end
