class BusinessUnitOrder < ApplicationRecord
  belongs_to :business_unit
  belongs_to :order
end
