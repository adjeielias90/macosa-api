class RenameCompanyTypeIdToTypeId < ActiveRecord::Migration[5.2]
  def change
    def change
      rename_column :company, :company_type_id, :type_id
    end
  end
end
