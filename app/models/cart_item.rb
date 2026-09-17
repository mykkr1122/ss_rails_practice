class CartItem < ApplicationRecord
  # カートアイテムはカートに属している
  belongs_to :cart
  # カートアイテムはSKUに属している
  belongs_to :sku
  delegate :product, to: :sku, allow_nil: true

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0, allow_blank: true}
  validates :sku_id, uniqueness: { scope: :cart_id }
  validate :quantity_must_not_exceed_product_stock
  validate :product_must_be_published


  private

  def quantity_must_not_exceed_product_stock
    return if sku.blank? || quantity.blank?

    if sku.stock.to_i <= 0
      errors.add(:base, :sold_out)
    elsif quantity > sku.stock.to_i
      errors.add(:quantity, :less_than_or_equal_to, count: sku.stock.to_i)
    end
  end

  def product_must_be_published
    # SKU が無いときは return。商品が published でなければ errors.add(:base, :not_available)。
    return if sku.blank?
    return if product&.published?
    errors.add(:base, :not_available)
  end
end
