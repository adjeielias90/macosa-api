class Api::V1::ContactSerializer < ActiveModel::Serializer
  attributes :id, :title, :firstname, :lastname, :phone, :email, :background, :company_id
end
