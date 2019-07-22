class Api::V1::OwnerSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :name, :website
end
