class AddSkuToCartItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :cart_items, :sku, null: true, foreign_key: true
  end
end
