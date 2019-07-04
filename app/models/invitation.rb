class Invitation < ApplicationRecord
  belongs_to :owner

  def generate_invitation_instructions!
    self.token = SecureRandom.hex(10)
    self.confirmed = false
    save
  end

  validates :email, uniqueness: true

end
