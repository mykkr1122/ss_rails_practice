class Product < ApplicationRecord

    # 商品の状態
    # 0: 非公開
    # 1: 公開
  enum status: {hidden: 0, published: 1}

  def status_label
    {'hidden'=> '非公開', 'published'=> '公開'}[status]
  end

  # カートにある商品は管理画面から削除できない
  has_many :cart_items, dependent: :restrict_with_error
  # 商品は店舗に属する
  belongs_to :store, optional: true

  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true,greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true,greater_than_or_equal_to: 0}
end
