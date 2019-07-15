class AddResetTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :reset_token, :string
    add_column :users, :reset_sent_at, :date
    add_column :users, :reset_at, :date
  end
end