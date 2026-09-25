require "rails_helper"

RSpec.describe Cart, type: :model do
  describe "#add_sku" do
    it "有効なSKUと数量でカートアイテムを追加できる" do
      cart = carts(:two)
      sku = skus(:one)

      item = cart.add_sku(sku, 1)

      expect(item).to be_persisted
      expect(item.quantity).to eq(1)
    end

    it "既に同じSKUがカートにある場合は数量が加算される" do
      skus(:one).update!(stock: 10)
      cart = carts(:one)

      item = cart.add_sku(skus(:one), 2)

      expect(item).to be_persisted
      expect(item.quantity).to eq(3)
    end

    it "SKUが無い場合はエラーになる" do
      cart = carts(:one)

      item = cart.add_sku(nil, 1)

      expect(item).not_to be_persisted
      expect(item.errors[:sku_id]).to be_present
    end

    it "非公開商品のSKUはエラーになる" do
      cart = carts(:one)
      sku = skus(:two)

      item = cart.add_sku(sku, 1)

      expect(item).not_to be_persisted
      expect(item.errors[:base]).to be_present
    end

    it "数量が0以下だとエラーになる" do
      cart = carts(:two)
      sku = skus(:one)

      item = cart.add_sku(sku, 0)

      expect(item).not_to be_persisted
      expect(item.errors[:quantity]).to be_present
    end
  end

  describe "#merge_from!" do
    it "ゲストカートに同じSKUがある場合は自分のカートの数量に加算し、ゲストカートを削除する" do
      skus(:one).update!(stock: 10)
      user_cart = carts(:one) # 既にskus(:one)のcart_item(quantity: 1)を持つ
      guest_cart = Cart.create!
      guest_cart.cart_items.create!(sku: skus(:one), quantity: 1)

      user_cart.merge_from!(guest_cart)

      expect(user_cart.cart_items.find_by(sku: skus(:one)).quantity).to eq(2)
      expect(Cart.exists?(guest_cart.id)).to be false
    end
  end
end
