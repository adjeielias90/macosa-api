class Owner < ApplicationRecord
  #Validations
  validates_presence_of :email, :password_digest
  validates :email, uniqueness: true

  #encrypt password
  has_secure_password
  has_one :company
end
