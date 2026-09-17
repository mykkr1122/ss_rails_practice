class ChangeNullConstraintsOnProductsAndSkus < ActiveRecord::Migration[6.0]
  def up
    return unless data_source_exists?(:products)
    return unless data_source_exists?(:skus)

    if column_exists?(:products, :name)
      execute "UPDATE products SET name = '未設定' WHERE name IS NULL"
      change_column_null :products, :name, false
    end

    if column_exists?(:products, :status)
      execute "UPDATE products SET status = 0 WHERE status IS NULL"
      change_column_null :products, :status, false
    end

    if column_exists?(:skus, :code)
      execute "UPDATE skus SET code = CONCAT('TEMP-', id) WHERE code IS NULL"
      change_column_null :skus, :code, false
    end

    if column_exists?(:skus, :price)
      execute "UPDATE skus SET price = 0 WHERE price IS NULL"
      change_column_null :skus, :price, false
    end

    if column_exists?(:skus, :stock)
      execute "UPDATE skus SET stock = 0 WHERE stock IS NULL"
      change_column_null :skus, :stock, false
    end
  end

  def down
    return unless data_source_exists?(:products)
    return unless data_source_exists?(:skus)

    change_column_null :products, :name, true if column_exists?(:products, :name)
    change_column_null :products, :status, true if column_exists?(:products, :status)
    change_column_null :skus, :code, true if column_exists?(:skus, :code)
    change_column_null :skus, :price, true if column_exists?(:skus, :price)
    change_column_null :skus, :stock, true if column_exists?(:skus, :stock)
  end
end
