class CreateAddresses < ActiveRecord::Migration[6.0]
  def up
    unless data_source_exists?(:addresses)
      create_table :addresses do |t|
        t.references :order, null: false, foreign_key: true
        t.string :address_type, null: false
        t.string :postal_code, null: false
        t.string :prefecture, null: false
        t.string :city, null: false
        t.string :address_line, null: false
        t.timestamps
      end
      add_index :addresses, [:order_id, :address_type], unique: true
    end
  end

  def down
    if data_source_exists?(:addresses)
      drop_table :addresses
    end
  end
end
