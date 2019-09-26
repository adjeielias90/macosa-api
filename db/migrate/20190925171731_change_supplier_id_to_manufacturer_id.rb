class ChangeSupplierIdToManufacturerId < ActiveRecord::Migration[5.2]
  def change
    # change_column :supplier_orders, :delivered, :boolean
    rename_column :supplier_orders, :supplier_id, :manufacturer_id


  end
end
