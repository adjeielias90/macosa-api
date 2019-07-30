class Industry < ApplicationRecord
  has_many :customers
  validates :name, uniqueness: true
  validates :name, presence: true
end
