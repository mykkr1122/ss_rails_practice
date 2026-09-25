class CreateOrders < ActiveRecord::Migration[6.0]
  def up
    return if data_source_exists?(:orders)

    create_table :orders do |t|
      t.string :customer_name, null: false
      t.string :customer_email, null: false

      t.timestamps
    end
  end

  def down
    drop_table :orders if data_source_exists?(:orders)
  end
end
