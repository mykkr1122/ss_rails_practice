class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.integer :store_number

      t.timestamps
    end
    add_index :stores, :store_number, unique: true
  end
end
