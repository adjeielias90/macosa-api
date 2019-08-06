class AddIndexToOrders < ActiveRecord::Migration[5.2]
  def change
    # add_index :orders, :customer_id
    add_index :orders, :account_manager_id
    add_index :orders, :user_id
    add_index :orders, :currency_id
  end
end
