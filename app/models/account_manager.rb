class AccountManager < ApplicationRecord
  has_many :orders
  has_many :business_unit_orders
  has_many :manufacturer_orders
end