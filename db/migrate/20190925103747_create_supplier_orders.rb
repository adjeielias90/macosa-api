class CreateSupplierOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :supplier_orders do |t|
      t.references :order, foreign_key: true
      t.references :manufacturer, foreign_key: true
      t.string :supplier_no
      t.string :order_no
      t.text :description
      t.text :comments
      t.datetime :order_date
      t.decimal :amount
      t.datetime :eta
      t.boolean :delivered

      t.timestamps
    end
  end
end
