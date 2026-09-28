class Store < ApplicationRecord
  has_many :products
  validates :store_number, presence: true, uniqueness: true

  def display_name
    "#{store_number} : #{name}"
  end
end
