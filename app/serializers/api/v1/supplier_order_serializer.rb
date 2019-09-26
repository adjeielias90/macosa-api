class Api::V1::SupplierOrderSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :manufacturer_id, :supplier_no, :order_no, :order_date, :amount, :comments, :eta, :description, :delivered
  # Removing this feature because it slows our API down significantly and causes timeouts
  # belongs_to :order
  belongs_to :manufacturer
end
