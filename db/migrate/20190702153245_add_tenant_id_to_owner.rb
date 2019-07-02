class AddTenantIdToOwner < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :tenant_id, :bigint
  end
end
