class CreateOrderItems < ActiveRecord::Migration[6.0]
  def up
    return if data_source_exists?(:order_items)

    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :sku, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end

  def down
    drop_table :order_items if data_source_exists?(:order_items)
  end
end
