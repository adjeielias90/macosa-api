class AddDeletedAtoNewModels < ActiveRecord::Migration[5.2]
  def change
    # add_column :manufacturers, :deleted_at, :datetime
    add_index :manufacturers, :deleted_at

    add_column :supplier_orders, :deleted_at, :datetime
    add_index :supplier_orders, :deleted_at
  end
end
