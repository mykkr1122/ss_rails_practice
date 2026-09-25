require "rails_helper"

RSpec.describe "Carts", type: :request do
  describe "GET /cart" do
    it "カートが空の場合は空である旨が表示される" do
      get cart_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("カートは空です")
    end

    it "カートに追加した商品が表示される" do
      post cart_items_path, params: {
        product_id: products(:one).id,
        cart_item: { sku_id: skus(:one).id, quantity: 1 }
      }

      get cart_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(products(:one).name)
    end
  end
end
