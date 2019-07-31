class Api::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :industry_id, :name, :created_at
  # has_one :industry
end
