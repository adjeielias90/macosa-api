class Invitation < ApplicationRecord
  include PublicActivity::Model
  # acts_as_paranoid
  belongs_to :owner



  # Refer to controller to understand the implementation of current_user
  # tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }
  # tracked recipient: ->(controller, model) { model && model }

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
