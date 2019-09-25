class Api::V1::SupplierOrderSerializer < ActiveModel::Serializer
  attributes :id, :supplier_no, :order_no, :order_date, :amount, :eta, :delivered
  has_many :orders
  has_many :suppliers
end
