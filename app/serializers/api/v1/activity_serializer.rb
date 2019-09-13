class PublicActivity::ActivitySerializer < ActiveModel::Serializer
  attributes :id, :trackable_type, :owner_type, :owner_id, :key

  def user_id
    object.owner_id.to_s
  end
end
