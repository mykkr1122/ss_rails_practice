class CreateStores < ActiveRecord::Migration[6.0]
  def up
    return if data_source_exists?(:stores)

    create_table :stores do |t|
      t.string :name
      t.integer :store_number
      t.timestamps
    end
    add_index :stores, :store_number, unique: true
  end

  def down
    drop_table :stores if data_source_exists?(:stores)
  end
end