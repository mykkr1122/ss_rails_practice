class ChangeQuantityNullConstraintsOnCartItems < ActiveRecord::Migration[6.0]
  def up
    return unless data_source_exists?(:cart_items)
    return unless column_exists?(:cart_items, :quantity)

    execute "UPDATE cart_items SET quantity = 1 WHERE quantity IS NULL"
    change_column_null :cart_items, :quantity, false
  end

  def down
    return unless data_source_exists?(:cart_items)
    return unless column_exists?(:cart_items, :quantity)

    change_column_null :cart_items, :quantity, true
  end
end
