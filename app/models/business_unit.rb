class BusinessUnit < ApplicationRecord
  acts_as_paranoid
  has_many :business_unit_orders, dependent: :destroy
end
