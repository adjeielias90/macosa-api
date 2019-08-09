class Api::V1::CurrencySerializer < ActiveModel::Serializer
  attributes :id, :name, :symbol
end
