class CreateBusinessUnitOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :business_unit_orders do |t|
      t.decimal :amount
      t.datetime :date
      t.references :business_unit, foreign_key: true
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
