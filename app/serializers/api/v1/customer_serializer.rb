class Api::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name
  # has_one :industry
end
