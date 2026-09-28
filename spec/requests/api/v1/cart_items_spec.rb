require "rails_helper"

RSpec.describe "Api::V1::CartItems", type: :request do
  describe "POST /api/v1/cart_items" do
    it "公開商品のSKUをカートに追加できる" do
      skus(:one).update!(stock: 10)

      post "/api/v1/cart_items",
           params: { cart_item: { sku_id: skus(:one).id, quantity: 2 } },
           headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:created)
    end

    it "非公開商品のSKUは追加できない" do
      post "/api/v1/cart_items",
           params: { cart_item: { sku_id: skus(:two).id, quantity: 1 } },
           headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/cart_items/:id" do
    it "カート内商品の数量を更新できる" do
      skus(:one).update!(stock: 10)

      patch "/api/v1/cart_items/#{cart_items(:one).id}",
            params: { cart_item: { quantity: 5 } },
            headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:success)
      expect(cart_items(:one).reload.quantity).to eq(5)
    end
  end

  describe "DELETE /api/v1/cart_items/:id" do
    it "カート内商品を削除できる" do
      delete "/api/v1/cart_items/#{cart_items(:one).id}", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:no_content)
    end
  end
end
