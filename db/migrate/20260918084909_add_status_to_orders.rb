class AddStatusToOrders < ActiveRecord::Migration[6.0]
  def up
    return unless data_source_exists?(:orders)
    return if column_exists?(:orders, :status)

    add_column :orders, :status, :integer, null: false, default: 0 
  end

  def down
    return unless data_source_exists?(:orders)
    remove_column :orders, :status if column_exists?(:orders, :status)
  end
end
