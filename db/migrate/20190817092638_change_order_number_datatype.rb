class ChangeOrderNumberDatatype < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :order_no, :string
  end
end
