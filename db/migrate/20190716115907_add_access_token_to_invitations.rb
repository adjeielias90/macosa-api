class AddAccessTokenToInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :access_token, :string
  end
end
