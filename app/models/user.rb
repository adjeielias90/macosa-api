class User < ApplicationRecord
  #
  has_secure_password
  # Do not move has_secure_password below the validations
  # doing this causes a validation error to trigger on the hashing of the password.
  belongs_to :company
  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /@/



  before_save :downcase_email
  before_create :generate_confirmation_instructions

  def downcase_email
    self.email = self.email.delete('').downcase
  end

  def generate_confirmation_instructions!
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.now.utc
    save
  end

  def set_as_admin!
    self.is_admin = true
    save
  end

  def revoke_as_admin!
    self.is_admin = false
    save
  end

  def is_admin?
    self.is_admin == true
  end


end