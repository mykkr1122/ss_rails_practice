class SwitchCartItemsFromProductToSku < ActiveRecord::Migration[6.0]
  def up
    change_column_null :cart_items, :sku_id, false
    add_index :cart_items, [:cart_id, :sku_id], unique: true

    remove_index :cart_items, name: 'index_cart_items_on_cart_id_and_product_id'
    remove_reference :cart_items, :product, foreign_key: true
  end

  def down
    add_reference :cart_items, :product, null: true, foreign_key: true
    add_index :cart_items, [:cart_id, :product_id], unique: true

    remove_index :cart_items, column: [:cart_id, :sku_id]
    change_column_null :cart_items, :sku_id, true
  end
end