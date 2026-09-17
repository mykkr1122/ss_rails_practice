class Sku < ApplicationRecord
  has_many :cart_items, dependent: :restrict_with_error
  belongs_to :product
  
  validates :code, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  
  def code_with_price
    "#{code} (#{price}円)"
  end

end
