class BusinessUnitOrder < ApplicationRecord
  acts_as_paranoid
  belongs_to :business_unit
  belongs_to :order
end
