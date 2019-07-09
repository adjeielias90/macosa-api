class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :website
      t.string :address
      t.references :type, foreign_key: true
      t.string :background
      t.references :owner, foreign_key: true

      t.timestamps
    end
  end
end
