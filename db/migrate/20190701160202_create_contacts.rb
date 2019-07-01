class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :title
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :email
      t.string :background
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
