class Api::V1::BusinessUnitOrderSerializer < ActiveModel::Serializer
  attributes :id, :business_unit_id, :amount, :date, :order_id
end
