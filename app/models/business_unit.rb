class BusinessUnit < ApplicationRecord
  has_many :business_unit_orders, dependent: :destroy
end
