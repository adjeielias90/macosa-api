class Owner < ApplicationRecord
  #Validations
  validates_presence_of :email, :password_digest
  validates :email, uniqueness: true
  has_many :users

  #encrypt password
  has_secure_password
  # remove 'dependent: :destroy' to enforce FK constraint
  has_many :companies, dependent: :destroy
end
