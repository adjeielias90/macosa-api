class Api::V1::InvitationSerializer < ActiveModel::Serializer
  attributes :id, :email, :firstname, :lastname, :is_admin
end
