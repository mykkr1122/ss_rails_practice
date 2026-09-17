class CreateSkus < ActiveRecord::Migration[6.0]
  def up
    return if data_source_exists?(:skus)

    create_table :skus do |t|
      t.references :product, null: false, foreign_key: true
      t.string :code
      t.integer :price
      t.integer :stock

      t.timestamps
    end
    add_index :skus, :code, unique: true
  end

  def down
    drop_table :skus if data_source_exists?(:skus)
  end
end
