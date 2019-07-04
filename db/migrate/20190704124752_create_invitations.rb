class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.string :token
      t.string :email
      t.boolean :confirmed
      t.references :owner, foreign_key: true

      t.timestamps
    end
  end
end
