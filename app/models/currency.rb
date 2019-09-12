class Currency < ApplicationRecord
  include PublicActivity::Model

  tracked owner: Proc.new{ |controller, model| controller.user }

  acts_as_paranoid
  has_many :orders

  validates :name, uniqueness: true
  validates :name, presence: true
  validates :symbol, uniqueness: true
  validates :symbol, presence: true
end
