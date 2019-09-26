class AddDeletedAtoNewModels < ActiveRecord::Migration[5.2]
  def change
    # Column and index already exist on manufacturer model
    # add_column :manufacturers, :deleted_at, :datetime
    # add_index :manufacturers, :deleted_at

    add_column :supplier_orders, :deleted_at, :datetime
    add_index :supplier_orders, :deleted_at
  end
end
