class CreateOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :owners do |t|
      t.string :email
      t.bigint :company_id
      t.string :password_digest

      t.timestamps
    end
  end
end
