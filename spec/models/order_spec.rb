require "rails_helper"

RSpec.describe Order, type: :model do
  describe ".create_from_cart" do
    it "カートの中身から注文を作成し、在庫を減らしてカートを空にする" do
      cart = carts(:one)
      sku = skus(:one)

      order = Order.create_from_cart(cart, "山田太郎", "yamada@example.com")

      expect(order).to be_persisted
      expect(order.errors).to be_empty
      expect(order.order_items.count).to eq(1)
      expect(order.order_items.first.sku).to eq(sku)
      expect(sku.reload.stock).to eq(0)
      expect(cart.cart_items.reload).to be_empty
    end

    it "カートが空の場合はエラーになる" do
      cart = carts(:two)
      cart.cart_items.destroy_all

      order = Order.create_from_cart(cart, "山田太郎", "yamada@example.com")

      expect(order).not_to be_persisted
      expect(order.errors[:base]).to include(I18n.t("activerecord.errors.models.order.cart_empty"))
    end

    it "非公開になった商品が含まれる場合はエラーになる" do
      cart = carts(:one)
      skus(:one).product.update_column(:status, :hidden)

      order = Order.create_from_cart(cart, "山田太郎", "yamada@example.com")

      expect(order).not_to be_persisted
      expect(order.errors[:base]).to include(I18n.t("activerecord.errors.models.order.not_available"))
    end

    it "在庫が不足している場合はエラーになる" do
      cart = carts(:one)
      skus(:one).update_column(:stock, 0)

      order = Order.create_from_cart(cart, "山田太郎", "yamada@example.com")

      expect(order).not_to be_persisted
      expect(order.errors[:base]).to include(I18n.t("activerecord.errors.models.order.sold_out"))
    end
  end
end
