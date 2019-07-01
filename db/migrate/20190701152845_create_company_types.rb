class CreateCompanyTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :company_types do |t|
      t.string :typename

      t.timestamps
    end
  end
end
