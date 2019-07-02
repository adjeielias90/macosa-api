class AddExtraFieldsToOwner < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :name, :string
    add_column :owners, :website, :string
  end
end
