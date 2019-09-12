class AddDeletedAtToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :account_managers, :deleted_at, :datetime
    add_index :account_managers, :deleted_at
  
    add_column :business_unit_orders, :deleted_at, :datetime
    add_index :business_unit_orders, :deleted_at

    add_column :business_units, :deleted_at, :datetime
    add_index :business_units, :deleted_at

    add_column :companies, :deleted_at, :datetime
    add_index :companies, :deleted_at    

    add_column :contacts, :deleted_at, :datetime
    add_index :contacts, :deleted_at 

    add_column :currencies, :deleted_at, :datetime
    add_index :currencies, :deleted_at

    add_column :customers, :deleted_at, :datetime
    add_index :customers, :deleted_at

    add_column :industries, :deleted_at, :datetime
    add_index :industries, :deleted_at  
  
    add_column :invitations, :deleted_at, :datetime
    add_index :invitations, :deleted_at  

    add_column :manufacturer_orders, :deleted_at, :datetime
    add_index :manufacturer_orders, :deleted_at

    add_column :manufacturers, :deleted_at, :datetime
    add_index :manufacturers, :deleted_at

    add_column :owners, :deleted_at, :datetime
    add_index :owners, :deleted_at

    add_column :types, :deleted_at, :datetime
    add_index :types, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at


  end
end
