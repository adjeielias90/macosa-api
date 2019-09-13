class Currency < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }
  acts_as_paranoid
  has_many :orders

  validates :name, uniqueness: true
  validates :name, presence: true
  validates :symbol, uniqueness: true
  validates :symbol, presence: true
end
