class Api::V1::OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_no, :date, :description, :amount, :profit
  has_many :business_orders
  has_many :manufacturer_orders
end
