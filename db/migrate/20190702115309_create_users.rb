class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :title
      t.references :company, foreign_key: true
      t.string :phone
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :background

      t.timestamps
    end
  end
end
