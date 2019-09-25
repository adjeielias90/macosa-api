class CreateSupplierOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :supplier_orders do |t|
      t.references :order, foreign_key: true
      t.references :supplier, foreign_key: true
      t.string :supplier_no
      t.string :order_no
      t.datetime :order_date
      t.decimal :amount
      t.datetime :eta
      t.datetime :delivered

      t.timestamps
    end
  end
end
