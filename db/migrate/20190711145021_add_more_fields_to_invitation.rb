class AddMoreFieldsToInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :firstname, :string
    add_column :invitations, :lastname, :string
    add_column :invitations, :is_admin, :boolean
  end
end
