class AddDeletedAtoNewModels < ActiveRecord::Migration[5.2]
  def change
    add_column :suppliers, :deleted_at, :datetime
    add_index :suppliers, :deleted_at

    add_column :supplier_orders, :deleted_at, :datetime
    add_index :supplier_orders, :deleted_at
  end
end
