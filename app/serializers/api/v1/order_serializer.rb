class Api::V1::OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_no, :date, :description, :amount, :profit
  has_many :business_unit_orders, root: :business_unit_orders_attributes
  has_many :manufacturer_orders, root: :manufacturer_orders_attributes
end
