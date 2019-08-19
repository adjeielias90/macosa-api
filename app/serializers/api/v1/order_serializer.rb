class Api::V1::OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_no, :date, :description, :amount, :profit, :customer_id, :account_manager_id, :user_id, :currency_id
  has_many :business_unit_orders
  has_many :manufacturer_orders
end
