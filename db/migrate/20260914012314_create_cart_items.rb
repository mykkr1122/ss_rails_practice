class CreateCartItems < ActiveRecord::Migration[6.0]
  def up
    return if data_source_exists?(:cart_items)

    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.timestamps
    end
  end

  def down
    drop_table :cart_items if data_source_exists?(:cart_items)
  end
end