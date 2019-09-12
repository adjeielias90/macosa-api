class Invitation < ApplicationRecord
  # acts_as_paranoid
  belongs_to :owner

  def generate_invitation_instructions!
    self.token = SecureRandom.hex(10)
    self.access_token = SecureRandom.hex(4)
    self.confirmed = false
    save
  end

  def mark_as_confirmed!
    self.confirmed = true
    save
  end

  def token_valid?
    (self.created_at + 1.days) > Time.now.utc
  end

  def email_confirmed?
    if self.confirmed == true
      return true
    else
      return false
    end
  end

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
end
