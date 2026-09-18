class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :sku
  delegate :product, to: :sku, allow_nil: true

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def sub_total
    price * quantity
  end
end
