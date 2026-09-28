class AddTaxRateToOrders < ActiveRecord::Migration[6.0]
  def up
    add_column :orders, :tax_rate, :integer
    Order.update_all(tax_rate: TaxRate::PERCENT)
    change_column_null :orders, :tax_rate, false
  end

  def down
    remove_column :orders, :tax_rate
  end
end
