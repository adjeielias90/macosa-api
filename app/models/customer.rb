class Customer < ApplicationRecord
  belongs_to :industry
  has_many :orders

  validates :name, uniqueness: true
  validates :name, presence: true
end
