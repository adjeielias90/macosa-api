class RemoveCompanyIdFromOwners < ActiveRecord::Migration[5.2]
  def change
    remove_column :owners, :company_id, :bigint
  end
end
