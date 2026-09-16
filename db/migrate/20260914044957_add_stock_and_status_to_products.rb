class AddStockAndStatusToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :stock, :integer
    add_column :products, :status, :integer
  end
end
