class CreateManufacturerOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :manufacturer_orders do |t|
      t.decimal :amount
      t.datetime :date
      t.references :manufacturer, foreign_key: true
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
