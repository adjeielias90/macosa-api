class AddOrdersCountToCurrencies < ActiveRecord::Migration[5.2]
  def change
    add_column :currencies, :orders_count, :integer
  end
end
