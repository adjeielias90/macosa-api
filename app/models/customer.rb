class Customer < ApplicationRecord
  acts_as_paranoid
  belongs_to :industry
  has_many :orders

  validates :name, uniqueness: true
  validates :name, presence: true
end
