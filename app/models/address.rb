class Address < ApplicationRecord
  ADDRESS_TYPES = %w[Shipping Billing].freeze

  belongs_to :order

  validates :address_type, presence: true, inclusion: { in: ADDRESS_TYPES }
  # 新規注文作成時はorder_idがまだnilのため、このバリデーションは効かない。
  # 実際の重複防止はDBのユニークインデックス(order_id, address_type)が担っている。
  validates :address_type, uniqueness: { scope: :order_id }
  validates :postal_code, :prefecture, :city, :address_line, presence: true
  validates :postal_code, format: { with: /\A\d{7}\z/ }
end
