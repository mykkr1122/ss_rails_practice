class AddUserIdToCarts < ActiveRecord::Migration[6.0]
  def up
    return unless data_source_exists?(:carts)
    return if column_exists?(:carts, :user_id)

    add_reference :carts, :user, foreign_key: true, null: true, index: { unique: true }
  end

  def down
    return unless data_source_exists?(:carts)
    return unless column_exists?(:carts, :user_id)

    remove_reference :carts, :user, foreign_key: true
  end
end
