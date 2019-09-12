class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :trackable_type, :owner_type, :owner_id, :key
end
