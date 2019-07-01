class CreateApiV1Companies < ActiveRecord::Migration[5.2]
  def change
    create_table :api_v1_companies do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :website
      t.string :address
      t.references :company_type, foreign_key: true
      t.string :background
      t.references :owner, foreign_key: true

      t.timestamps
    end
  end
end
