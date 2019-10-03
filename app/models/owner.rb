class Owner < ApplicationRecord
  include PublicActivity::Model
  #acts_as_paranoid
  #Validations
  # untracked
  validates_presence_of :email, :password_digest
  validates :email, uniqueness: true
  has_many :users
  has_many :invitations


  # Refer to controller to understand the implementation of current_user
  # tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }
  # tracked recipient: ->(controller, model) { model && model }

  #encrypt password
  has_secure_password
  # remove 'dependent: :destroy' to enforce FK constraint
  has_many :companies, dependent: :destroy
end
