class CartItem < ApplicationRecord
  # カートアイテムはカートに属している
  belongs_to :cart
  # カートアイテムは商品に属している
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0, allow_blank: true}
  validates :product_id, uniqueness: { scope: :cart_id }
  validate :quantity_must_not_exceed_product_stock

  private

  def quantity_must_not_exceed_product_stock
    return if product.blank? || quantity.blank?

    if quantity > product.stock.to_i
      errors.add(:quantity, :less_than_or_equal_to, count: product.stock.to_i)
    end
  end
end
