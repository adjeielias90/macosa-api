class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.bigint :order_no
      t.datetime :date
      t.string :description
      t.decimal :amount
      t.decimal :profit
      t.references :customer, foreign_key: true
      t.references :account_manager, foreign_key: true

      t.timestamps
    end
  end
end
