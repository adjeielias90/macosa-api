class Company < ApplicationRecord
  acts_as_paranoid
  include PublicActivity::Model

  # Refer to controller to understand the implementation of current_user
  tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }
  tracked recipient: ->(controller, model) { model && model }
  belongs_to :type
  belongs_to :owner

  # remove 'dependent: :destroy' to enforce FK constraint
  has_many :contacts, dependent: :destroy
  paginates_per 10
end
