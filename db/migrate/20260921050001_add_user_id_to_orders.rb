class AddUserIdToOrders < ActiveRecord::Migration[6.0]
  def up
    return unless data_source_exists?(:orders)
    return if column_exists?(:orders, :user_id)

    add_reference :orders, :user, foreign_key: true, null: true
  end

  def down
    return unless data_source_exists?(:orders)
    return unless column_exists?(:orders, :user_id)

    remove_reference :orders, :user, foreign_key: true
  end
end
