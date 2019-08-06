class AddIndexToManufacturerOrders < ActiveRecord::Migration[5.2]
  def change
      add_index :manufacturer_orders, :manufaturer_id
      add_index :manufacturer_orders, :order_id
  end
end
