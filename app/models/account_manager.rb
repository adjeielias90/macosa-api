class AccountManager < ApplicationRecord
  has_many :orders
  has_many :business_unit_orders
  has_many :manifucturer_orders
end