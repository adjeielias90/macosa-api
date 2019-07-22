class Api::V1::OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_no, :date, :description, :amount, :profit
  # has_one :customer
  # has_one :account_manager
end
