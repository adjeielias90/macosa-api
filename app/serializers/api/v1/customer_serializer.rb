class Api::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :industry_id, :name
  # has_one :industry
end
