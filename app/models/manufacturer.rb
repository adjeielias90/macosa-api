class Manufacturer < ApplicationRecord
  acts_as_paranoid
  has_many :manufacturer_orders, dependent: :destroy
end
