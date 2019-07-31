class AddCurrencyIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :currency_id, :integer
  end
end
