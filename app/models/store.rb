class Store < ApplicationRecord
  has_many :products
  validates :store_number, presence: true, uniqueness: true

  def label_for_select
    "#{store_number} : #{name}"
  end
end
