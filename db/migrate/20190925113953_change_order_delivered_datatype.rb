class ChangeOrderDeliveredDatatype < ActiveRecord::Migration[5.2]
  def change
    change_column :supplier_orders, :delivered, :boolean
  end
end
