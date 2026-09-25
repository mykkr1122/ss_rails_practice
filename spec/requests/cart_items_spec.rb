require "rails_helper"

RSpec.describe "CartItems", type: :request do
  let(:sku) { skus(:one) }
  let(:product) { products(:one) }

  describe "POST /cart_items" do
    it "カートに商品を追加できる" do
      expect {
        post cart_items_path, params: {
          product_id: product.id,
          cart_item: { sku_id: sku.id, quantity: 1 }
        }
      }.to change(CartItem, :count).by(1)

      expect(response).to redirect_to(cart_path)
      expect(flash[:notice]).to eq(I18n.t("flash.cart_items.create.notice"))
    end
  end

  describe "PATCH /cart_items/:id" do
    it "カート内商品の数量を更新できる" do
      post cart_items_path, params: {
        product_id: product.id,
        cart_item: { sku_id: sku.id, quantity: 1 }
      }
      item = Cart.find(session[:cart_id]).cart_items.find_by!(sku: sku)
      sku.update!(stock: 5)

      patch cart_item_path(item), params: { cart_item: { quantity: 2 } }

      expect(response).to redirect_to(cart_path)
      expect(flash[:notice]).to eq(I18n.t("flash.cart_items.update.notice"))
      expect(item.reload.quantity).to eq(2)
    end
  end

  describe "DELETE /cart_items/:id" do
    it "カート内商品を削除できる" do
      post cart_items_path, params: {
        product_id: product.id,
        cart_item: { sku_id: sku.id, quantity: 1 }
      }
      item = Cart.find(session[:cart_id]).cart_items.find_by!(sku: sku)

      expect {
        delete cart_item_path(item)
      }.to change(CartItem, :count).by(-1)

      expect(response).to redirect_to(cart_path)
      expect(flash[:notice]).to eq(I18n.t("flash.cart_items.destroy.notice"))
    end
  end
end
