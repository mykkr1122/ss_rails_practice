class Product < ApplicationRecord
  # 商品の状態
  # 0: 非公開
  # 1: 公開
  enum status: { hidden: 0, published: 1 }

  # 商品は複数のSKUを持つ
  has_many :skus, dependent: :destroy, inverse_of: :product
  # 商品は店舗に属する
  belongs_to :store, optional: true
  # SKUのネストされた属性を受け取る
  accepts_nested_attributes_for :skus, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validate :must_have_sku
  # SKUがカートに入っている場合は削除できない
  validate :cannot_destroy_sku_in_cart

  # 商品を削除する前にカート・注文をチェック
  # prepend: SKU の dependent: :destroy より先に止める
  before_destroy :abort_if_in_cart, prepend: true

  def status_label
    { 'hidden' => '非公開', 'published' => '公開' }[status]
  end

  # 商品の価格を表示
  def display_price
    skus.map(&:price).compact.min
  end

  # 空配列の場合はfalseを返す
  def sold_out?
    skus.any? && skus.all? { |sku| sku.stock.to_i <= 0 }
  end

  private

  def must_have_sku
    remaining = skus.reject(&:marked_for_destruction?)
    errors.add(:skus, :blank) if remaining.empty?
  end

  # SKUの削除制御
  # SKUがカートに入っているか注文中の場合は削除できない
  def cannot_destroy_sku_in_cart
    skus.select(&:marked_for_destruction?).each do |sku|
      if sku.cart_items.exists?
        errors.add(:base, :sku_in_cart)
      elsif sku.order_items.exists?
        errors.add(:base, :sku_in_order)
      end
    end
  end

  # 商品の削除制御
  # 商品を削除する前にカートに入っているか注文中の場合は削除できない
  def abort_if_in_cart
    if skus.joins(:cart_items).exists?
      errors.add(:base, :in_cart)
      throw :abort
    end

    if skus.joins(:order_items).exists?
      errors.add(:base, :in_order)
      throw :abort
    end
  end
end
