class AddTenantIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tenant_id, :bigint
  end
end
