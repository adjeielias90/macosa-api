class RemoveBackgroundFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :background, :string
  end
end
