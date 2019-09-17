class Api::V1::OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_no, :date, :description, :amount, :profit, :customer_id, :currency_id, :user_id, :account_manager_id, :business_unit_orders_attributes, :manufacturer_orders_attributes
  # def business_unit_orders_attributes
  #   object.business_unit_orders.collect do |ov|
  #     {
  #       id: ov.id, 
  #       business_unit_id: ov.business_unit_id, 
  #       amount: ov.amount, 
  #       date: ov.date,
  #       order_id: ov.order_id
  #     }
  #   end
  # end

  # def manufacturer_orders_attributes
  #   object.manufacturer_orders.collect do |ov|
  #     {
  #       id: ov.id, 
  #       manufacturer_id: ov.manufacturer_id, 
  #       amount: ov.amount, 
  #       date: ov.date,
  #       order_id: ov.order_id
  #     }
  #   end
  # end
  has_many :business_unit_orders, root: :business_unit_orders_attributes
  has_many :manufacturer_orders, root: :manufacturer_orders_attributes
end
