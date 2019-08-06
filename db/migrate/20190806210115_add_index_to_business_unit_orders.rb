class AddIndexToBusinessUnitOrders < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :id
    # add_index :business_unit_orders, :order_id
  end
end
