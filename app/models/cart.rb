class Cart < ApplicationRecord

  # カートに紐づくカートアイテムを削除する
  has_many :cart_items, dependent: :destroy

  def add_sku(sku, quantity = 1)
    quantity = quantity.to_i
    item = if sku
             cart_items.find_or_initialize_by(sku_id: sku.id)
           else
             cart_items.build
           end

    if sku.blank?
      item.errors.add(:sku_id, :blank)
      return item
    end

    unless sku.product&.published?
      item.errors.add(:base, :not_available)
      return item
    end

    item.quantity = item.quantity.to_i + quantity
    item.save
    item
  end
end
