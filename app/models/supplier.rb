class Supplier < ApplicationRecord
  has_many :supplier_orders
  acts_as_paranoid
end
