class ChangeOrderDeliveredDatatype < ActiveRecord::Migration[5.2]
  def up
    change_column :supplier_orders, :delivered, :boolean
  end

  def down
  end
end
