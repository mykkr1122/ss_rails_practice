class Cart < ApplicationRecord

    # カートに紐づくカートアイテムを削除する
  has_many :cart_items, dependent: :destroy

  def add_product(product, quantity = 1)
    quantity = quantity.to_i
    item = if product
             cart_items.find_or_initialize_by(product_id: product.id)
           else
             cart_items.build
           end
  
    unless product&.published?
      item.errors.add(:base, :not_available)
      return item
    end
  
    item.quantity = item.quantity.to_i + quantity
    item.save
    item
  end
end
