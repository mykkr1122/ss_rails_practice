class CreateUsers < ActiveRecord::Migration[6.0]
  def up
    return if data_source_exists?(:users)

    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.datetime :remember_created_at

      t.timestamps
    end

    add_index :users, :email, unique: true
  end

  def down
    drop_table :users if data_source_exists?(:users)
  end
end
