class RemovePriceAndStockFromProduct < ActiveRecord::Migration[6.0]
  def up
    remove_column :products, :price if column_exists?(:products, :price)
    remove_column :products, :stock if column_exists?(:products, :stock)
  end

  def down
    add_column :products, :price, :integer unless column_exists?(:products, :price)
    add_column :products, :stock, :integer unless column_exists?(:products, :stock)
  end
end