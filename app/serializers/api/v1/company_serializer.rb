class Api::V1::CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :email, :website, :address, :type_id, :background, :owner_id
end
