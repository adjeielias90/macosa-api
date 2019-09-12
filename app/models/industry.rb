class Industry < ApplicationRecord
  acts_as_paranoid
  has_many :customers
  validates :name, uniqueness: true
  validates :name, presence: true
end
