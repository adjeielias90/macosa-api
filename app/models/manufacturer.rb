class Manufacturer < ApplicationRecord
  has_many :manufacturer_orders, dependent: :destroy
end
