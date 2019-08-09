class Api::V1::ManufacturerOrderSerializer < ActiveModel::Serializer
  attributes :id, :manufacturer_id, :amount, :date, :order_id
end
