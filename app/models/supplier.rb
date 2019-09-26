class Supplier < ApplicationRecord
  # has_many :supplier_orders
  acts_as_paranoid
  validates :name, uniqueness: true
  validates :name, presence: true
end
