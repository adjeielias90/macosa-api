class AccountManager < ApplicationRecord
  acts_as_paranoid
  has_many :orders
  has_many :business_unit_orders
  has_many :manufacturer_orders
end