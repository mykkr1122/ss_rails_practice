class CreateCarts < ActiveRecord::Migration[6.0]
  def up
    return if data_source_exists?(:carts)

    create_table :carts do |t|
      t.timestamps
    end
  end

  def down
    drop_table :carts if data_source_exists?(:carts)
  end
end