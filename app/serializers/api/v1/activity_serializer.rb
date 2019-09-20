class PublicActivity::ActivitySerializer < ActiveModel::Serializer
  attributes  :user_id, :id, :trackable_type, :owner_type, :owner_id,:recipient_type, :recipient_id, :key

  def user_id
    object.owner_id.to_s
  end

  # def action
  #   @key = object.key
  #   if @key == "currency.create"

  # end

end
