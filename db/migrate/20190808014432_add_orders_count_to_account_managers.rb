class AddOrdersCountToAccountManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :account_managers, :orders_count, :integer
  end
end
