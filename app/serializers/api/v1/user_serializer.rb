class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :phone, :email, :is_admin, :owner_id, :user_id
end
