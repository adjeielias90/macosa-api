class AddOrdersCountToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :orders_count, :integer
  end
end
