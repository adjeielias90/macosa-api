class Customer < ApplicationRecord
  acts_as_paranoid
  include PublicActivity::Model

  # Refer to controller to understand the implementation of current_user
  tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }
  tracked recipient: ->(controller, model) { model && model }
  belongs_to :industry
  has_many :orders

  validates :name, uniqueness: true
  validates :name, presence: true
  paginates_per 10
end
