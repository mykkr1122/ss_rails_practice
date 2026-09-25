class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  validates :customer_name, presence: true
  # URI::MailTo::EMAIL_REGEXPでメールアドレスの形式をチェック
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.create_from_cart(cart, customer_name, customer_email)
    order = new(customer_name: customer_name, customer_email: customer_email)
    items = cart&.cart_items.to_a

    if items.empty?
      order.errors.add(:base, :cart_empty)
      return order
    end

    items.each do |cart_item|
      # カートアイテムが公開商品かチェック
      unless cart_item.product&.published?
        order.errors.add(:base, :not_available)
        return order
      end
      # 在庫が不足しているかチェック
      if cart_item.sku.stock < cart_item.quantity
        order.errors.add(:base, :sold_out)
        return order
      end
    end

    # チェックが完了したら注文を作成
    transaction do
      order.save!
      items.each do |cart_item|
        sku = cart_item.sku
        sku.with_lock do
          if sku.stock < cart_item.quantity
            order.errors.add(:base, :sold_out)
            raise ActiveRecord::RecordInvalid.new(order)
          end
          order.order_items.create!(
            sku: sku,
            quantity: cart_item.quantity,
            price: sku.price
          )
          # SKUの在庫を更新
          sku.update!(stock: sku.stock - cart_item.quantity)
        end
      end
      cart.cart_items.destroy_all
    end

    order
  rescue ActiveRecord::RecordInvalid
    order
  end

  def total_price
    order_items.sum(&:sub_total)
  end
end
